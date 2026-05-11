<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\FavoriteController;
use App\Http\Controllers\GarageController;
use App\Http\Controllers\ReservationController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/login', [AuthController::class, 'login']);

Route::get('/garages', [GarageController::class, 'index']);
Route::get('/garages/{id}', [GarageController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user/profile', [AuthController::class, 'profile']);
    Route::post('/change-password', [AuthController::class, 'changePassword']);
    Route::post('/reservations', [ReservationController::class, 'store']);
    Route::get('/garage/my', [GarageController::class, 'myGarage']);
    Route::post('/garage/store', [GarageController::class, 'store']);
    Route::post('/garage/update', [GarageController::class, 'update']);
    Route::post('/garage/update-availability', [GarageController::class, 'updateAvailability']);
    Route::post('/reservations', [ReservationController::class, 'store']);
    Route::get('/reservations/my', [ReservationController::class, 'myReservations']);
    Route::get('/reservations/upcoming', [ReservationController::class, 'upcomingReservations']);
    Route::get('/reservations/previous', [ReservationController::class, 'previousReservations']);
    Route::post('/reservations/{id}/cancel', [ReservationController::class, 'cancel']);
    Route::post('/toggle-favorite', [FavoriteController::class, 'toggleFavorite']);
    Route::get('/favorites', [FavoriteController::class, 'getFavorites']);
    Route::post('/reservations/{id}/respond', [ReservationController::class, 'respondToReservation']);
    Route::get('/garage-owner/reservations', [ReservationController::class, 'garageOwnerReservations']);
    // Route::post('/contact/send', [ContactController::class, 'send']);
    Route::get('/garage-owner/statistics', [ReservationController::class, 'statistics']);
});
Route::post('/contact/send', [ContactController::class, 'send']);
