<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class GarageImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'garage_id',
        'image_path',
    ];

    protected $appends = ['url'];

    public function getUrlAttribute(): string
    {
        return Storage::disk('public')->url($this->image_path);
    }

    public function garage()
    {
        return $this->belongsTo(Garage::class, 'garage_id');
    }
}
