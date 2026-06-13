<?php

namespace Tests\Feature;

use App\Models\Garage;
use App\Models\GarageImage;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class GaragePhotoTest extends TestCase
{
    use RefreshDatabase;

    // ─── Helpers ───────────────────────────────────────────────────────────────

    private function makeGarageOwner(): User
    {
        return User::factory()->create([
            'role'            => 'garage_owner',
            'approval_status' => 'approved',
        ]);
    }

    private function makeGarageForOwner(User $owner): Garage
    {
        return Garage::create([
            'owner_id'        => $owner->id,
            'name'            => 'Test Garage',
            'city'            => 'Riyadh',
            'address'         => '123 King Fahd Road',
            'price_per_hour'  => 10.00,
            'capacity'        => 20,
            'available_spots' => 20,
            'approval_status' => 'approved',
            'is_active'       => true,
        ]);
    }

    // ─── FETCH ─────────────────────────────────────────────────────────────────

    public function test_garage_owner_can_fetch_photos(): void
    {
        Storage::fake('public');

        $owner  = $this->makeGarageOwner();
        $garage = $this->makeGarageForOwner($owner);

        GarageImage::create([
            'garage_id'  => $garage->id,
            'image_path' => 'garage_images/1/test.jpg',
        ]);

        $response = $this->actingAs($owner, 'sanctum')
                         ->getJson('/api/garage/photos');

        $response->assertStatus(200)
                 ->assertJsonStructure(['photos'])
                 ->assertJsonCount(1, 'photos');
    }

    public function test_car_owner_cannot_fetch_garage_photos(): void
    {
        $carOwner = User::factory()->create([
            'role'            => 'car_owner',
            'approval_status' => 'approved',
        ]);

        $response = $this->actingAs($carOwner, 'sanctum')
                         ->getJson('/api/garage/photos');

        $response->assertStatus(403);
    }

    public function test_fetch_returns_empty_when_no_photos(): void
    {
        $owner = $this->makeGarageOwner();
        $this->makeGarageForOwner($owner);

        $response = $this->actingAs($owner, 'sanctum')
                         ->getJson('/api/garage/photos');

        $response->assertStatus(200)
                 ->assertJsonCount(0, 'photos');
    }

    // ─── UPLOAD ────────────────────────────────────────────────────────────────

    public function test_garage_owner_can_upload_photos(): void
    {
        Storage::fake('public');

        $owner  = $this->makeGarageOwner();
        $garage = $this->makeGarageForOwner($owner);

        $fakeImage = UploadedFile::fake()->image('garage.jpg', 800, 600);

        $response = $this->actingAs($owner, 'sanctum')
                         ->postJson('/api/garage/photos', [
                             'photos' => [$fakeImage],
                         ]);

        $response->assertStatus(201)
                 ->assertJsonFragment(['message' => 'Photos uploaded successfully'])
                 ->assertJsonStructure(['photos']);

        $this->assertDatabaseCount('garage_images', 1);
    }

    public function test_upload_fails_without_photos(): void
    {
        $owner = $this->makeGarageOwner();
        $this->makeGarageForOwner($owner);

        $response = $this->actingAs($owner, 'sanctum')
                         ->postJson('/api/garage/photos', []);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['photos']);
    }

    public function test_upload_fails_with_non_image_file(): void
    {
        Storage::fake('public');

        $owner = $this->makeGarageOwner();
        $this->makeGarageForOwner($owner);

        $fakeFile = UploadedFile::fake()->create('document.pdf', 100);

        $response = $this->actingAs($owner, 'sanctum')
                         ->postJson('/api/garage/photos', [
                             'photos' => [$fakeFile],
                         ]);

        $response->assertStatus(422)
                 ->assertJsonValidationErrors(['photos.0']);
    }

    // ─── DELETE ────────────────────────────────────────────────────────────────

    public function test_garage_owner_can_delete_their_photo(): void
    {
        Storage::fake('public');

        $owner  = $this->makeGarageOwner();
        $garage = $this->makeGarageForOwner($owner);

        $photo = GarageImage::create([
            'garage_id'  => $garage->id,
            'image_path' => 'garage_images/1/test.jpg',
        ]);

        $response = $this->actingAs($owner, 'sanctum')
                         ->deleteJson("/api/garage/photos/{$photo->id}");

        $response->assertStatus(200)
                 ->assertJsonFragment(['message' => 'Photo deleted successfully']);

        $this->assertDatabaseMissing('garage_images', ['id' => $photo->id]);
    }

    public function test_garage_owner_cannot_delete_another_owners_photo(): void
    {
        Storage::fake('public');

        $owner1  = $this->makeGarageOwner();
        $garage1 = $this->makeGarageForOwner($owner1);

        $owner2  = $this->makeGarageOwner();

        $photo = GarageImage::create([
            'garage_id'  => $garage1->id,
            'image_path' => 'garage_images/1/test.jpg',
        ]);

        // owner2 tries to delete owner1's photo
        $response = $this->actingAs($owner2, 'sanctum')
                         ->deleteJson("/api/garage/photos/{$photo->id}");

        $response->assertStatus(404);

        $this->assertDatabaseHas('garage_images', ['id' => $photo->id]);
    }

    public function test_delete_returns_404_for_nonexistent_photo(): void
    {
        $owner = $this->makeGarageOwner();
        $this->makeGarageForOwner($owner);

        $response = $this->actingAs($owner, 'sanctum')
                         ->deleteJson('/api/garage/photos/9999');

        $response->assertStatus(404);
    }

    // ─── URL ───────────────────────────────────────────────────────────────────

    public function test_photo_response_includes_full_url(): void
    {
        Storage::fake('public');

        $owner  = $this->makeGarageOwner();
        $garage = $this->makeGarageForOwner($owner);

        GarageImage::create([
            'garage_id'  => $garage->id,
            'image_path' => 'garage_images/1/test.jpg',
        ]);

        $response = $this->actingAs($owner, 'sanctum')
                         ->getJson('/api/garage/photos');

        $response->assertStatus(200);

        $photos = $response->json('photos');
        $this->assertNotEmpty($photos);
        $this->assertArrayHasKey('url', $photos[0]);
        $this->assertStringContainsString('garage_images/1/test.jpg', $photos[0]['url']);
    }
}
