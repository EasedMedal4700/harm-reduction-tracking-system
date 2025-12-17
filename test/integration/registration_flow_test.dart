import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/services/auth_service.dart';
import 'package:mobile_drug_use_app/services/encryption_service_v2.dart';
import 'package:mobile_drug_use_app/services/user_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Registration Flow Tests', () {
    late AuthService authService;
    late SupabaseClient client;
    final testEmail = 'test_${DateTime.now().millisecondsSinceEpoch}@example.com';
    final testPassword = 'TestPassword123!';
    final testDisplayName = 'Test User';

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      // Initialize Supabase
      await Supabase.initialize(
        url: const String.fromEnvironment('SUPABASE_URL'),
        anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      );
      client = Supabase.instance.client;
      authService = AuthService(
        client: client,
        encryption: EncryptionServiceV2(),
      );
    });

    tearDown(() async {
      // Cleanup: logout and attempt to delete test user
      try {
        await authService.logout();
      } catch (_) {}
      
      // Clean up test data from users table if it exists
      try {
        await client.from('users').delete().eq('email', testEmail);
      } catch (_) {}
    });

    test('Successful registration creates both Auth user and database entry', () async {
      // Register new user
      final result = await authService.register(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      expect(result.success, true, reason: 'Registration should succeed');
      expect(result.errorMessage, null, reason: 'Should not have error message');

      // Verify we can login with the new credentials
      final loginResult = await authService.login(testEmail, testPassword);

      expect(loginResult, true, reason: 'Should be able to login after registration');

      // Verify user is authenticated
      expect(
        client.auth.currentUser,
        isNotNull,
        reason: 'Should have authenticated user',
      );

      // Verify users table entry exists and has correct data
      final userData = await UserService.getUserData();
      expect(userData['email'], testEmail, reason: 'Email should match');
      expect(
        userData['display_name'],
        testDisplayName,
        reason: 'Display name should match',
      );
      expect(userData['is_admin'], false, reason: 'New users should not be admin');
      expect(
        userData['user_id'],
        isNotNull,
        reason: 'Should have integer user_id',
      );

      // Verify we can get the user ID
      final userId = UserService.getCurrentUserId();
      expect(userId, isA<String>(), reason: 'User ID should be a string (UUID)');
      expect(userId.isNotEmpty, true, reason: 'User ID should not be empty');
    });

    test('Registration with duplicate email fails', () async {
      // Register first user
      final firstResult = await authService.register(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      expect(firstResult.success, true, reason: 'First registration should succeed');

      // Logout
      await authService.logout();

      // Try to register again with same email
      final duplicateResult = await authService.register(
        email: testEmail,
        password: testPassword,
        displayName: 'Another Name',
      );

      expect(
        duplicateResult.success,
        false,
        reason: 'Duplicate registration should fail',
      );
      expect(
        duplicateResult.errorMessage?.toLowerCase(),
        contains('already'),
        reason: 'Error should mention email already in use',
      );
    });

    test('Registration with empty display name uses email as fallback', () async {
      final result = await authService.register(
        email: testEmail,
        password: testPassword,
        displayName: '', // Empty display name
      );

      expect(result.success, true, reason: 'Registration should succeed');

      // Login and verify display name
      await authService.login(testEmail, testPassword);
      final userData = await UserService.getUserData();
      
      expect(
        userData['display_name'],
        testEmail,
        reason: 'Display name should default to email when empty',
      );
    });

    test('Registration with null display name uses email as fallback', () async {
      final result = await authService.register(
        email: testEmail,
        password: testPassword,
        displayName: null, // Null display name
      );

      expect(result.success, true, reason: 'Registration should succeed');

      // Login and verify display name
      await authService.login(testEmail, testPassword);
      final userData = await UserService.getUserData();
      
      expect(
        userData['display_name'],
        testEmail,
        reason: 'Display name should default to email when null',
      );
    });

    test('Registration with invalid email format fails', () async {
      final result = await authService.register(
        email: 'not-an-email',
        password: testPassword,
        displayName: testDisplayName,
      );

      expect(
        result.success,
        false,
        reason: 'Registration with invalid email should fail',
      );
      expect(
        result.errorMessage,
        isNotNull,
        reason: 'Should have error message',
      );
    });

    test('Registration with weak password fails', () async {
      final result = await authService.register(
        email: testEmail,
        password: '123', // Weak password
        displayName: testDisplayName,
      );

      expect(
        result.success,
        false,
        reason: 'Registration with weak password should fail',
      );
      expect(
        result.errorMessage,
        isNotNull,
        reason: 'Should have error message',
      );
    });

    test('User data can be retrieved after registration and login', () async {
      // Register
      await authService.register(
        email: testEmail,
        password: testPassword,
        displayName: testDisplayName,
      );

      // Login
      await authService.login(testEmail, testPassword);

      // Get user data multiple times to test caching
      final userData1 = await UserService.getUserData();
      final userData2 = await UserService.getUserData();
      
      expect(userData1['user_id'], userData2['user_id']);
      expect(userData1['email'], testEmail);
      expect(userData1['display_name'], testDisplayName);

      // Test getCurrentUserId consistency
      final userId1 = UserService.getCurrentUserId();
      final userId2 = UserService.getCurrentUserId();
      expect(userId1, userId2, reason: 'User ID should be consistent');

      // Test isAdmin
      final isAdmin = await UserService.isAdmin();
      expect(isAdmin, false, reason: 'New user should not be admin');
    });
  }, skip: const String.fromEnvironment('SUPABASE_URL').isEmpty ? 'Supabase credentials not provided' : null);
}
