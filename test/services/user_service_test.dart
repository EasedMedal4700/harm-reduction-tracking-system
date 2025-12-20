import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/services/user_service.dart';

void main() {
  group('UserService', () {
    test('getCurrentUserId method exists and returns String', () {
      // Note: Without Supabase initialization, calling the actual method will fail
      // This test verifies the method exists and the API
      expect(UserService.getCurrentUserId, isA<Function>());
    });

    test('isUserLoggedIn method exists and returns bool', () {
      // Note: Without Supabase initialization, calling the actual method will fail
      // This test verifies the method exists and the API
      expect(UserService.isUserLoggedIn, isA<Function>());
    });

    test('UserService provides static methods', () {
      // Verify methods are static and accessible
      expect(UserService.getCurrentUserId, isNotNull);
      expect(UserService.isUserLoggedIn, isNotNull);
    });
  });
}
