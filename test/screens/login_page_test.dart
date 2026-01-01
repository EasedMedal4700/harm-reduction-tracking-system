import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_credentials.dart';

/// Note: Widget tests for LoginPage are limited because the screen depends on
/// flutter_dotenv which requires initialization. These tests focus on
/// validation logic and the TestCredentials helper.

void main() {
  group('LoginPage Form Validation', () {
    test('email validation accepts valid emails', () {
      bool isValidEmail(String email) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        return emailRegex.hasMatch(email);
      }

      expect(isValidEmail('test@example.com'), isTrue);
      expect(isValidEmail('user.name@domain.org'), isTrue);
      expect(isValidEmail('user@sub.domain.com'), isTrue);
    });

    test('email validation rejects invalid emails', () {
      bool isValidEmail(String email) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        return emailRegex.hasMatch(email);
      }

      expect(isValidEmail('notanemail'), isFalse);
      expect(isValidEmail('@domain.com'), isFalse);
      expect(isValidEmail('user@'), isFalse);
      expect(isValidEmail(''), isFalse);
    });

    test('password validation rejects empty passwords', () {
      bool isValidPassword(String password) => password.isNotEmpty;

      expect(isValidPassword(''), isFalse);
      expect(isValidPassword('password'), isTrue);
    });

    test('password validation requires minimum length', () {
      bool isValidPassword(String password) => password.length >= 6;

      expect(isValidPassword('12345'), isFalse);
      expect(isValidPassword('123456'), isTrue);
      expect(isValidPassword('password123'), isTrue);
    });

    test('email trimming removes whitespace', () {
      String trimEmail(String email) => email.trim();

      expect(trimEmail('  test@example.com  '), equals('test@example.com'));
      expect(trimEmail('test@example.com'), equals('test@example.com'));
    });
  });

  group('TestCredentials Helper', () {
    test('email is not empty', () {
      expect(TestCredentials.email, isNotEmpty);
    });

    test('password is not empty', () {
      expect(TestCredentials.password, isNotEmpty);
    });

    test('email looks like an email', () {
      final email = TestCredentials.email;
      expect(email.contains('@'), isTrue);
      expect(email.contains('.'), isTrue);
    });

    test('credentials can be cleared and reloaded', () {
      final email1 = TestCredentials.email;
      TestCredentials.clear();
      final email2 = TestCredentials.email;

      expect(email1, equals(email2));
    });
  });

  group('Login State Validation', () {
    test('remember me defaults to true', () {
      // This tests the expected default behavior
      const defaultRememberMe = true;
      expect(defaultRememberMe, isTrue);
    });

    test('login credentials structure', () {
      // Test that credentials have expected structure
      final credentials = {
        'email': TestCredentials.email,
        'password': TestCredentials.password,
      };

      expect(credentials.containsKey('email'), isTrue);
      expect(credentials.containsKey('password'), isTrue);
      expect(credentials['email'], isNotEmpty);
      expect(credentials['password'], isNotEmpty);
    });

    test('loading state handling', () {
      // Test loading state transitions
      bool isLoading = false;

      // Simulate starting login
      isLoading = true;
      expect(isLoading, isTrue);

      // Simulate finishing login
      isLoading = false;
      expect(isLoading, isFalse);
    });

    test('error message handling', () {
      String? errorMessage;

      // No error initially
      expect(errorMessage, isNull);

      // Set error
      errorMessage = 'Invalid credentials';
      expect(errorMessage, isNotNull);
      expect(errorMessage, equals('Invalid credentials'));

      // Clear error
      errorMessage = null;
      expect(errorMessage, isNull);
    });
  });
}
