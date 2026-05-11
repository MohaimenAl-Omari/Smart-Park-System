<?php

namespace App\Http\Controllers;

use App\Models\Garage;
use Illuminate\Http\Request;

class GarageController extends Controller
{
    public function index()
    {
        $garages = Garage::where('is_approved', 1)->get();
        return response()->json([
            'garages' => $garages
        ], 200);
    }
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'city' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'price_per_hour' => 'required|numeric|min:0',
            'capacity' => 'required|integer|min:1',
            'open_time' => 'nullable',
            'close_time' => 'nullable',
            'description' => 'nullable|string',
        ]);

        $user = $request->user();

        if ($user->role !== 'garage_owner') {
            return response()->json([
                'message' => 'Only garage owners can add garage information'
            ], 403);
        }

        if ($user->garage()->exists()) {
            return response()->json([
                'message' => 'Garage information already exists'
            ], 409);
        }

        $garage = Garage::createGarage($validated, $user->id);

        return response()->json([
            'message' => 'Garage information added successfully',
            'garage' => $garage,
        ], 201);
    }

    public function myGarage(Request $request)
    {
        $user = $request->user();

        if ($user->role !== 'garage_owner') {
            return response()->json([
                'message' => 'Only garage owners can view garage information'
            ], 403);
        }

        $garage = $user->garage;

        return response()->json([
            'garage' => $garage,
            'has_garage' => $garage ? true : false,
        ]);
    }

    public function update(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'city' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'price_per_hour' => 'required|numeric|min:0',
            'capacity' => 'required|integer|min:1',
            'open_time' => 'nullable',
            'close_time' => 'nullable',
            'description' => 'nullable|string',
            'is_active' => 'required|boolean',
        ]);

        $user = $request->user();

        if ($user->role !== 'garage_owner') {
            return response()->json([
                'message' => 'Only garage owners can edit garage information'
            ], 403);
        }

        $garage = $user->garage;

        if (!$garage) {
            return response()->json([
                'message' => 'Garage information not found'
            ], 404);
        }

        $updatedGarage = Garage::updateGarage($garage, $validated);

        return response()->json([
            'message' => 'Garage information updated successfully',
            'garage' => $updatedGarage,
        ], 200);
    }
    public function updateAvailability(Request $request)
    {
        $validated = $request->validate([
            'available_spots' => 'required|integer|min:0',
            'is_active' => 'required|boolean',
        ]);

        $user = $request->user();

        if ($user->role !== 'garage_owner') {
            return response()->json([
                'message' => 'Only garage owners can update garage availability'
            ], 403);
        }

        $garage = $user->garage;

        if (!$garage) {
            return response()->json([
                'message' => 'Garage information not found'
            ], 404);
        }

        $updatedGarage = Garage::updateAvailability($garage, $validated);

        return response()->json([
            'message' => 'Garage availability updated successfully',
            'garage' => $updatedGarage,
        ], 200);
    }
}
