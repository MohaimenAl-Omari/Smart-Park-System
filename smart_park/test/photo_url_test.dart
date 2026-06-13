import 'package:flutter_test/flutter_test.dart';

// Mirrors the photoUrl logic from GaragePhotosController
// so we can test it in isolation.
const String _storageUrl = 'http://127.0.0.1:8000/storage';

String photoUrl(String path) =>
    path.startsWith('http') ? path : '$_storageUrl/$path';

// Mirrors the garage_details_screen URL builder.
String detailScreenUrl(String path) => path.startsWith('http')
    ? path
    : 'http://127.0.0.1:8000/storage/$path';

void main() {
  group('photoUrl (GaragePhotosController)', () {
    test('relative path gets storage prefix', () {
      final url = photoUrl('garage_images/1/photo.jpg');
      expect(url, 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg');
    });

    test('already-absolute URL is returned unchanged', () {
      const full = 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg';
      expect(photoUrl(full), full);
    });

    test('empty path still gets prefix (edge case)', () {
      final url = photoUrl('');
      expect(url, 'http://127.0.0.1:8000/storage/');
    });

    test('path with subdirectories is handled correctly', () {
      final url = photoUrl('garage_images/42/abc123.jpg');
      expect(url, 'http://127.0.0.1:8000/storage/garage_images/42/abc123.jpg');
    });
  });

  group('detailScreenUrl (GarageDetailsScreen)', () {
    test('relative path produces correct URL', () {
      final url = detailScreenUrl('garage_images/1/photo.jpg');
      expect(url, 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg');
    });

    test('absolute URL passes through unchanged', () {
      const full = 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg';
      expect(detailScreenUrl(full), full);
    });
  });

  group('API url field (from GarageImage model)', () {
    test('url field from API is used directly when present', () {
      final photo = {
        'id': 1,
        'image_path': 'garage_images/1/photo.jpg',
        'url': 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg',
      };

      // Simulates: photo['url']?.toString() ?? photoUrl(photo['image_path'])
      final url = photo['url']?.toString() ??
          photoUrl(photo['image_path']?.toString() ?? '');

      expect(url, 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg');
    });

    test('falls back to photoUrl when url field is missing', () {
      final photo = {
        'id': 1,
        'image_path': 'garage_images/1/photo.jpg',
      };

      final url = photo['url']?.toString() ??
          photoUrl(photo['image_path']?.toString() ?? '');

      expect(url, 'http://127.0.0.1:8000/storage/garage_images/1/photo.jpg');
    });
  });
}
