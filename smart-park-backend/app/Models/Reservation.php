<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Carbon\Carbon;

class Reservation extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'car_owner_id',
        'garage_id',
        'reservation_date',
        'start_time',
        'end_time',
        'number_of_spots',
        'status',
        'price_per_hour',
        'total_cost',
        'cancelled_at',
        'cancel_reason',
        'owner_response_note',
    ];

    protected $casts = [
        'reservation_date' => 'date',
        'cancelled_at' => 'datetime',
    ];

    public function carOwner()
    {
        return $this->belongsTo(User::class, 'car_owner_id');
    }

    public function garage()
    {
        return $this->belongsTo(Garage::class);
    }

    public static function reservedSpotsInTimeRange($garageId, $reservationDate, $startTime, $endTime)
    {
        return self::where('garage_id', $garageId)
            ->where('reservation_date', $reservationDate)
            ->whereIn('status', ['pending', 'accepted'])
            ->where(function ($query) use ($startTime, $endTime) {
                $query->where('start_time', '<', $endTime)
                    ->where('end_time', '>', $startTime);
            })
            ->sum('number_of_spots');
    }

    public static function calculateTotalCost($pricePerHour, $startTime, $endTime, $numberOfSpots = 1)
    {
        $start = Carbon::createFromFormat('H:i:s', $startTime);
        $end = Carbon::createFromFormat('H:i:s', $endTime);

        $hours = $start->diffInMinutes($end) / 60;

        return round($hours * $pricePerHour * $numberOfSpots, 2);
    }
    
}
