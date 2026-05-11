<?php

namespace App\Http\Controllers;

use App\Models\Garage;
use App\Models\Reservation;
use Illuminate\Http\Request;

class ReservationController extends Controller
{
    public function store(Request $request)
    {
        $user = $request->user();
        if ($user->role !== 'car_owner') {
            return response()->json([
                'message' => 'Only car owners can create reservations.'
            ], 403);
        }
        $validated = $request->validate([
            'garage_id' => 'required|exists:garages,id',
            'reservation_date' => 'required|date|after_or_equal:today',
            'start_time' => 'required|date_format:H:i',
            'end_time' => 'required|date_format:H:i|after:start_time',
            'number_of_spots' => 'nullable|integer|min:1',
        ]);

        $garage = Garage::findOrFail($validated['garage_id']);
        $numberOfSpots = $validated['number_of_spots'] ?? 1;

        $reservedSpots = Reservation::reservedSpotsInTimeRange(
            $validated['garage_id'],
            $validated['reservation_date'],
            $validated['start_time'],
            $validated['end_time']
        );

        if (($reservedSpots + $numberOfSpots) > $garage->available_spots) {
            return response()->json([
                'message' => 'Not enough available spots for this selected time.'
            ], 409);
        }

        $pricePerHour = $garage->price_per_hour ?? 0;

        $totalCost = Reservation::calculateTotalCost(
            $pricePerHour,
            $validated['start_time'] . ':00',
            $validated['end_time'] . ':00',
            $numberOfSpots
        );

        $reservation = Reservation::create([
            'car_owner_id' => $user->id,
            'garage_id' => $garage->id,
            'reservation_date' => $validated['reservation_date'],
            'start_time' => $validated['start_time'],
            'end_time' => $validated['end_time'],
            'number_of_spots' => $numberOfSpots,
            'status' => 'pending',
            'price_per_hour' => $pricePerHour,
            'total_cost' => $totalCost,
        ]);
        $garage->decrement('available_spots', $numberOfSpots);

        return response()->json([
            'message' => 'Reservation created successfully',
            'reservation' => $reservation->load('garage', 'carOwner'),
        ], 201);
    }

    public function myReservations(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        $reservations = Reservation::with('garage')
            ->where('car_owner_id', $user->id)
            ->orderByDesc('reservation_date')
            ->orderByDesc('start_time')
            ->get();

        return response()->json([
            'reservations' => $reservations
        ]);
    }

    public function upcomingReservations(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        $reservations = Reservation::with('garage')
            ->where('car_owner_id', $user->id)
            ->whereIn('status', ['pending', 'accepted'])
            ->where(function ($query) {
                $query->where('reservation_date', '>', now()->toDateString())
                    ->orWhere(function ($q) {
                        $q->where('reservation_date', now()->toDateString())
                            ->where('end_time', '>=', now()->format('H:i:s'));
                    });
            })
            ->orderBy('reservation_date')
            ->orderBy('start_time')
            ->get();

        return response()->json([
            'reservations' => $reservations
        ]);
    }

    public function previousReservations(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        $reservations = Reservation::with('garage')
            ->where('car_owner_id', $user->id)
            ->where(function ($query) {
                $query->whereIn('status', ['cancelled', 'completed', 'rejected'])
                    ->orWhere(function ($q) {
                        $q->where('reservation_date', '<', now()->toDateString())
                            ->orWhere(function ($qq) {
                                $qq->where('reservation_date', now()->toDateString())
                                    ->where('end_time', '<', now()->format('H:i:s'));
                            });
                    });
            })
            ->orderByDesc('reservation_date')
            ->orderByDesc('start_time')
            ->get();

        return response()->json([
            'reservations' => $reservations
        ]);
    }

    public function cancel(Request $request, $id)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        $request->validate([
            'cancel_reason' => 'nullable|string|max:1000'
        ]);

        $reservation = Reservation::with('garage')
            ->where('id', $id)
            ->where('car_owner_id', $user->id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservation not found'
            ], 404);
        }

        if (in_array($reservation->status, ['cancelled', 'completed', 'rejected'])) {
            return response()->json([
                'message' => 'This reservation cannot be cancelled'
            ], 400);
        }

        $reservation->update([
            'status' => 'cancelled',
            'cancelled_at' => now(),
            'cancel_reason' => $request->cancel_reason,
        ]);
        $reservation->garage->increment('available_spots', $reservation->number_of_spots);
        return response()->json([
            'message' => 'Reservation cancelled successfully',
            'reservation' => $reservation->load('garage', 'carOwner'),
        ]);
    }

    public function garageOwnerReservations(Request $request)
    {
        $user = $request->user();
        $garage = $user->garage;
        if (!$garage) {
            return response()->json([
                'message' => 'Garage not found'
            ], 404);
        }
        $reservations = Reservation::with('carOwner')
            ->where('garage_id', $garage->id)
            ->orderByDesc('reservation_date')
            ->orderByDesc('start_time')
            ->where('status', 'pending')
            ->get();
        return response()->json([
            'reservations' => $reservations
        ]);
    }

    public function respondToReservation(Request $request, $id)
    {
        $user = $request->user();
        if ($user->role !== 'garage_owner') {
            return response()->json([
                'message' => 'Unauthorized'
            ], 403);
        }

        $request->validate([
            'status' => 'required|in:accepted,rejected',
            'owner_response_note' => 'nullable|string|max:1000',
        ]);

        $reservation = Reservation::with('garage')
            ->where('id', $id)
            ->first();

        if (!$reservation) {
            return response()->json([
                'message' => 'Reservation not found'
            ], 404);
        }

        if ($reservation->garage->owner_id !== $user->id) {
            return response()->json([
                'message' => 'You cannot modify this reservation'
            ], 403);
        }

        if ($reservation->status !== 'pending') {
            return response()->json([
                'message' => 'Reservation already processed'
            ], 400);
        }
        if ($request->status === 'rejected') {
            $reservation->garage->increment('available_spots', $reservation->number_of_spots);
        }

        $reservation->update([
            'status' => $request->status,
            'owner_response_note' => $request->owner_response_note,
        ]);

        return response()->json([
            'message' => 'Reservation updated successfully',
            'reservation' => $reservation->load('garage', 'carOwner'),
        ]);
    }

    public function statistics(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'garage_owner') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $garage = $user->garage;

        if (!$garage) {
            return response()->json(['message' => 'Garage not found'], 404);
        }

        $query = Reservation::where('garage_id', $garage->id);

        $total = $query->count();
        $pending = (clone $query)->where('status', 'pending')->count();
        $accepted = (clone $query)->where('status', 'accepted')->count();
        $rejected = (clone $query)->where('status', 'rejected')->count();
        $cancelled = (clone $query)->where('status', 'cancelled')->count();
        $revenue = (clone $query)
            ->where('status', 'accepted')
            ->sum('total_cost');

        return response()->json([
            'total_reservations' => $total,
            'pending_reservations' => $pending,
            'accepted_reservations' => $accepted,
            'rejected_reservations' => $rejected,
            'cancelled' => $cancelled,

            'total_revenue' => $revenue,
        ]);
    }
}
