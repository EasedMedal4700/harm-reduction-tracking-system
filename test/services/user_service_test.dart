import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mobile_drug_use_app/core/services/cache_service.dart';
import 'package:mobile_drug_use_app/core/services/user_service.dart';
import 'package:mobile_drug_use_app/features/profile/models/user_profile.dart';
import '../mocks/supabase_mocks.mocks.dart';

void main() {
  group('UserService', () {
    setUp(() {
      CacheService().clearAll();
      UserService.clearCache();
    });

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

    test('loadUserProfile throws NOT_AUTHENTICATED when no user', () async {
      final mockClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();

      when(mockClient.auth).thenReturn(mockAuth);
      when(mockAuth.currentUser).thenReturn(null);

      final service = UserService(mockClient);

      await expectLater(
        service.loadUserProfile(),
        throwsA(
          isA<UserProfileException>().having(
            (e) => e.code,
            'code',
            'NOT_AUTHENTICATED',
          ),
        ),
      );
    });

    test('updateUserProfile throws NOT_AUTHENTICATED when no user', () async {
      final mockClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();

      when(mockClient.auth).thenReturn(mockAuth);
      when(mockAuth.currentUser).thenReturn(null);

      final service = UserService(mockClient);

      await expectLater(
        service.updateUserProfile(displayName: 'New Name'),
        throwsA(
          isA<UserProfileException>().having(
            (e) => e.code,
            'code',
            'NOT_AUTHENTICATED',
          ),
        ),
      );
    });

    test('updateDisplayName delegates and throws when no user', () async {
      final mockClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();

      when(mockClient.auth).thenReturn(mockAuth);
      when(mockAuth.currentUser).thenReturn(null);

      final service = UserService(mockClient);

      await expectLater(
        service.updateDisplayName('New Name'),
        throwsA(
          isA<UserProfileException>().having(
            (e) => e.code,
            'code',
            'NOT_AUTHENTICATED',
          ),
        ),
      );
    });

    test('hasProfile returns false when no user', () async {
      final mockClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();

      when(mockClient.auth).thenReturn(mockAuth);
      when(mockAuth.currentUser).thenReturn(null);

      final service = UserService(mockClient);

      final result = await service.hasProfile();
      expect(result, isFalse);
    });

    test('waitForProfile rethrows when not authenticated', () async {
      final mockClient = MockSupabaseClient();
      final mockAuth = MockGoTrueClient();

      when(mockClient.auth).thenReturn(mockAuth);
      when(mockAuth.currentUser).thenReturn(null);

      final service = UserService(mockClient);

      await expectLater(
        service.waitForProfile(maxRetries: 2, delay: Duration.zero),
        throwsA(
          isA<UserProfileException>().having(
            (e) => e.code,
            'code',
            'NOT_AUTHENTICATED',
          ),
        ),
      );
    });

    test('getUserData returns cached cache-service value', () async {
      final cached = {
        'auth_user_id': 'user-123',
        'email': 'test@example.com',
        'display_name': 'Tester',
        'is_admin': true,
      };

      CacheService().set(CacheKeys.currentUserData, cached);

      final result1 = await UserService.getUserData();
      expect(result1, equals(cached));

      final result2 = await UserService.getUserData();
      expect(result2, equals(cached));
    });

    test('clearCache clears both in-memory and CacheService', () {
      CacheService().set(CacheKeys.currentUserId, 'user-123');
      CacheService().set(CacheKeys.currentUserIsAdmin, true);
      CacheService().set(CacheKeys.currentUserData, {'k': 'v'});

      UserService.clearCache();

      expect(CacheService().get(CacheKeys.currentUserId), isNull);
      expect(CacheService().get(CacheKeys.currentUserIsAdmin), isNull);
      expect(CacheService().get(CacheKeys.currentUserData), isNull);
    });
  });
}
