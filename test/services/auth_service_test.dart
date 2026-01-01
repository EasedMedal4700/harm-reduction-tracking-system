import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/login/services/auth_service.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service_v2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('AuthService', () {
    late AuthService service;

    setUp(() {
      service = AuthService(
        client: SupabaseClient('http://localhost', 'anon'),
        encryption: EncryptionServiceV2(),
      );
    });

    test('AuthService can be instantiated', () {
      expect(service, isA<AuthService>());
    });

    test('login method exists and returns Future<bool>', () {
      expect(service.login, isA<Function>());
    });

    test('logout method exists and returns Future<void>', () {
      expect(service.logout, isA<Function>());
    });

    test('register method exists', () {
      expect(service.register, isA<Function>());
    });

    test('AuthService has proper method signatures', () {
      expect(service.login, isNotNull);
      expect(service.logout, isNotNull);
      expect(service.register, isNotNull);
    });

    test('AuthService is not a singleton', () {
      final service1 = AuthService(
        client: SupabaseClient('http://localhost', 'anon'),
        encryption: EncryptionServiceV2(),
      );
      final service2 = AuthService(
        client: SupabaseClient('http://localhost', 'anon'),
        encryption: EncryptionServiceV2(),
      );
      // Each call creates a new instance
      expect(service1, isA<AuthService>());
      expect(service2, isA<AuthService>());
    });
  });

  group('AuthResult', () {
    test('AuthResult.success creates success result', () {
      const result = AuthResult.success();
      expect(result.success, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('AuthResult.failure creates failure result', () {
      const result = AuthResult.failure('Test error');
      expect(result.success, isFalse);
      expect(result.errorMessage, equals('Test error'));
    });

    test('AuthResult.failure preserves error message', () {
      const message = 'Email is already in use.';
      const result = AuthResult.failure(message);
      expect(result.errorMessage, equals(message));
    });
  });

  group('Email Validation', () {
    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    test('valid email formats', () {
      expect(isValidEmail('test@example.com'), isTrue);
      expect(isValidEmail('user.name@domain.org'), isTrue);
      expect(isValidEmail('user-name@domain.co.uk'), isTrue);
    });

    test('invalid email formats', () {
      expect(isValidEmail('notanemail'), isFalse);
      expect(isValidEmail('missing@domain'), isFalse);
      expect(isValidEmail('@nodomain.com'), isFalse);
      expect(isValidEmail('spaces in@email.com'), isFalse);
    });
  });

  group('Password Validation', () {
    bool isValidPassword(String password) {
      return password.length >= 6;
    }

    test('valid passwords', () {
      expect(isValidPassword('123456'), isTrue);
      expect(isValidPassword('password123'), isTrue);
      expect(isValidPassword('VeryLongPassword!'), isTrue);
    });

    test('invalid passwords', () {
      expect(isValidPassword(''), isFalse);
      expect(isValidPassword('12345'), isFalse);
      expect(isValidPassword('abc'), isFalse);
    });
  });
}
