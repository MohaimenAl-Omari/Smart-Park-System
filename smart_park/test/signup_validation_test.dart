import 'package:flutter_test/flutter_test.dart';

// Mirrors the validator functions used in SignupScreen.
// Testing them in isolation gives fast, reliable pass/fail results.

String? validateName(String? v) {
  if (v == null || v.trim().isEmpty) return 'Name is required';
  if (v.trim().length < 3) return 'Name must be at least 3 characters';
  return null;
}

String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
    return 'Enter a valid email';
  }
  return null;
}

String? validatePhone(String? v) {
  if (v == null || v.trim().isEmpty) return 'Mobile is required';
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (v.length < 6) return 'Password must be at least 6 characters';
  return null;
}

String? validateConfirmPassword(String? v, String password) {
  if (v == null || v.isEmpty) return 'Confirm password is required';
  if (v != password) return 'Passwords do not match';
  return null;
}

String? validateCarType(String? v, String role) {
  if (role == 'car_owner' && (v == null || v.isEmpty)) {
    return 'Car type is required';
  }
  return null;
}

void main() {
  group('Name validation', () {
    test('accepts a valid name', () {
      expect(validateName('Ahmed Ali'), null);
    });

    test('rejects empty name', () {
      expect(validateName(''), isNotNull);
    });

    test('rejects name shorter than 3 characters', () {
      expect(validateName('Jo'), isNotNull);
    });

    test('rejects whitespace-only name', () {
      expect(validateName('   '), isNotNull);
    });
  });

  group('Email validation', () {
    test('accepts valid email', () {
      expect(validateEmail('user@example.com'), null);
    });

    test('rejects missing @', () {
      expect(validateEmail('userexample.com'), isNotNull);
    });

    test('rejects missing domain', () {
      expect(validateEmail('user@'), isNotNull);
    });

    test('rejects empty email', () {
      expect(validateEmail(''), isNotNull);
    });

    test('rejects null', () {
      expect(validateEmail(null), isNotNull);
    });
  });

  group('Phone validation', () {
    test('accepts valid phone number', () {
      expect(validatePhone('0501234567'), null);
    });

    test('rejects empty phone', () {
      expect(validatePhone(''), isNotNull);
    });

    test('rejects null phone', () {
      expect(validatePhone(null), isNotNull);
    });
  });

  group('Password validation', () {
    test('accepts password with 6+ characters', () {
      expect(validatePassword('abc123'), null);
    });

    test('rejects password shorter than 6 characters', () {
      expect(validatePassword('abc'), isNotNull);
    });

    test('rejects empty password', () {
      expect(validatePassword(''), isNotNull);
    });
  });

  group('Confirm password validation', () {
    test('passes when passwords match', () {
      expect(validateConfirmPassword('abc123', 'abc123'), null);
    });

    test('fails when passwords do not match', () {
      expect(validateConfirmPassword('abc123', 'different'), isNotNull);
    });

    test('fails when confirm is empty', () {
      expect(validateConfirmPassword('', 'abc123'), isNotNull);
    });
  });

  group('Car type validation', () {
    test('car_owner must provide car type', () {
      expect(validateCarType(null, 'car_owner'), isNotNull);
    });

    test('car_owner with car type passes', () {
      expect(validateCarType('Sedan', 'car_owner'), null);
    });

    test('garage_owner does not need car type', () {
      expect(validateCarType(null, 'garage_owner'), null);
    });
  });
}
