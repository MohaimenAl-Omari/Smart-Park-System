import 'package:flutter_test/flutter_test.dart';
import 'package:smart_park/models/user_model.dart';

void main() {
  group('UserModel.fromJson', () {
    test('parses a complete car_owner response correctly', () {
      final json = {
        'id': 1,
        'name': 'Ahmed Ali',
        'email': 'ahmed@example.com',
        'role': 'car_owner',
        'car_type': 'Sedan',
        'approval_status': 'approved',
        'is_active': true,
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'Ahmed Ali');
      expect(user.email, 'ahmed@example.com');
      expect(user.role, 'car_owner');
      expect(user.carType, 'Sedan');
      expect(user.approvalStatus, 'approved');
      expect(user.isActive, true);
    });

    test('parses a garage_owner response correctly', () {
      final json = {
        'id': 2,
        'name': 'Omar Garage',
        'email': 'omar@garage.com',
        'role': 'garage_owner',
        'car_type': null,
        'approval_status': 'pending',
        'is_active': false,
      };

      final user = UserModel.fromJson(json);

      expect(user.role, 'garage_owner');
      expect(user.carType, null);
      expect(user.approvalStatus, 'pending');
      expect(user.isActive, false);
    });

    test('handles id as string (API may return string)', () {
      final json = {
        'id': '42',
        'name': 'Test User',
        'email': 'test@test.com',
        'role': 'car_owner',
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 42);
    });

    test('handles missing optional fields without crashing', () {
      final json = {
        'id': 1,
        'name': 'Minimal User',
        'email': 'minimal@example.com',
        'role': 'car_owner',
      };

      final user = UserModel.fromJson(json);

      expect(user.carType, null);
      expect(user.approvalStatus, null);
      expect(user.isActive, null);
    });

    test('handles is_active as integer 1 (some APIs return 1/0)', () {
      final json = {
        'id': 1,
        'name': 'User',
        'email': 'u@u.com',
        'role': 'car_owner',
        'is_active': 1,
      };

      final user = UserModel.fromJson(json);
      expect(user.isActive, true);
    });

    test('toJson round-trips correctly', () {
      final original = UserModel(
        id: 5,
        name: 'Round Trip',
        email: 'rt@test.com',
        role: 'car_owner',
        carType: 'SUV',
        approvalStatus: 'approved',
        isActive: true,
      );

      final json = original.toJson();
      final restored = UserModel.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.email, original.email);
      expect(restored.role, original.role);
      expect(restored.carType, original.carType);
    });
  });
}
