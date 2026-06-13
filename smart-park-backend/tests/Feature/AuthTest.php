<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    // ─── REGISTER ──────────────────────────────────────────────────────────────

    public function test_car_owner_can_register_successfully(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Ahmed Ali',
            'email'                 => 'ahmed@example.com',
            'password'              => 'password123',
            'password_confirmation' => 'password123',
            'role'                  => 'car_owner',
            'car_type'              => 'Sedan',
            'phone'                 => '0501234567',
        ]);

        $response->assertStatus(201)
                 ->assertJsonStructure([
                     'message',
                     'token',
                     'user' => ['id', 'name', 'email', 'role'],
                 ]);

        $this->assertDatabaseHas('users', [
            'email' => 'ahmed@example.com',
            'role'  => 'car_owner',
            'phone' => '0501234567',
        ]);
    }

    public function test_garage_owner_can_register_and_is_set_to_pending(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Omar Garage',
            'email'                 => 'omar@garage.com',
            'password'              => 'password123',
            'password_confirmation' => 'password123',
            'role'                  => 'garage_owner',
            'phone'                 => '0509876543',
        ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('users', [
            'email'           => 'omar@garage.com',
            'role'            => 'garage_owner',
            'approval_status' => 'pending',
        ]);
    }

    public function test_register_fails_without_phone(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Ahmed Ali',
            'email'                 => 'ahmed@example.com',
            'password'              => 'password123',
            'password_confirmation' => 'password123',
            'role'                  => 'car_owner',
            'car_type'              => 'Sedan',
            // phone is missing
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['phone']);
    }

    public function test_register_fails_with_invalid_email(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Ahmed Ali',
            'email'                 => 'not-an-email',
            'password'              => 'password123',
            'password_confirmation' => 'password123',
            'role'                  => 'car_owner',
            'phone'                 => '0501234567',
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['email']);
    }

    public function test_register_fails_with_duplicate_email(): void
    {
        User::factory()->create(['email' => 'taken@example.com']);

        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Another User',
            'email'                 => 'taken@example.com',
            'password'              => 'password123',
            'password_confirmation' => 'password123',
            'role'                  => 'car_owner',
            'phone'                 => '0501111111',
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['email']);
    }

    public function test_register_fails_when_passwords_do_not_match(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Ahmed Ali',
            'email'                 => 'ahmed@example.com',
            'password'              => 'password123',
            'password_confirmation' => 'different456',
            'role'                  => 'car_owner',
            'phone'                 => '0501234567',
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['password']);
    }

    public function test_register_fails_with_short_password(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name'                  => 'Ahmed Ali',
            'email'                 => 'ahmed@example.com',
            'password'              => '123',
            'password_confirmation' => '123',
            'role'                  => 'car_owner',
            'phone'                 => '0501234567',
        ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['password']);
    }

    // ─── LOGIN ─────────────────────────────────────────────────────────────────

    public function test_approved_car_owner_can_login(): void
    {
        User::factory()->create([
            'email'           => 'user@example.com',
            'password'        => bcrypt('password123'),
            'role'            => 'car_owner',
            'approval_status' => 'approved',
        ]);

        $response = $this->postJson('/api/auth/login', [
            'email'    => 'user@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
                 ->assertJsonStructure(['token', 'user']);
    }

    public function test_login_fails_with_wrong_password(): void
    {
        User::factory()->create([
            'email'    => 'user@example.com',
            'password' => bcrypt('correct-password'),
        ]);

        $response = $this->postJson('/api/auth/login', [
            'email'    => 'user@example.com',
            'password' => 'wrong-password',
        ]);

        $response->assertStatus(422);
    }

    public function test_login_fails_with_nonexistent_email(): void
    {
        $response = $this->postJson('/api/auth/login', [
            'email'    => 'nobody@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(422);
    }

    public function test_pending_garage_owner_cannot_login(): void
    {
        User::factory()->create([
            'email'           => 'garage@example.com',
            'password'        => bcrypt('password123'),
            'role'            => 'garage_owner',
            'approval_status' => 'pending',
        ]);

        $response = $this->postJson('/api/auth/login', [
            'email'    => 'garage@example.com',
            'password' => 'password123',
        ]);

        $response->assertStatus(403)
                 ->assertJsonFragment(['message' => 'Your account is waiting for admin approval']);
    }
}
