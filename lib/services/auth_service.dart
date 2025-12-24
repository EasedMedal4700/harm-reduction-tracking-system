import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'user_service.dart';
import 'encryption_service_v2.dart';
import '../common/logging/app_log.dart';

class AuthService {
  AuthService({
    required SupabaseClient client,
    required EncryptionServiceV2 encryption,
  }) : _client = client,
       _encryption = encryption;

  final SupabaseClient _client;
  final EncryptionServiceV2 _encryption;

  Future<bool> login(String email, String password) async {
    try {
      AppLog.d('🔐 DEBUG: Starting login for email: $email');
      AppLog.d('🔐 DEBUG: Attempting sign in with password...');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      AppLog.d('✅ DEBUG: Login successful!');
      AppLog.d('✅ DEBUG: User ID: ${response.user?.id}');
      AppLog.d('✅ DEBUG: Session exists: ${response.session != null}');
      AppLog.d('✅ DEBUG: Session expires at: ${response.session?.expiresAt}');

      // Note: Encryption initialization is handled by login_page.dart
      // which checks for migration/PIN setup and routes appropriately

      return true;
    } on AuthException catch (e, stackTrace) {
      AppLog.e('❌ DEBUG: AuthException during login');
      AppLog.e('❌ DEBUG: Error message: ${e.message}');
      AppLog.e('❌ DEBUG: Status code: ${e.statusCode}');
      ErrorHandler.logError('AuthService.login.AuthException', e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      AppLog.e('❌ DEBUG: Generic exception during login');
      AppLog.e('❌ DEBUG: Error: $e');
      AppLog.e('❌ DEBUG: Stack trace: $stackTrace');
      ErrorHandler.logError('AuthService.login', e, stackTrace);
      return false;
    }
  }

  Future<AuthResult> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // Note: User profile is created automatically by a database trigger
    // when the auth user is created. We pass display_name via user metadata.

    try {
      final friendlyName = displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : email;

      AppLog.d('📝 DEBUG: Starting registration for email: $email');
      AppLog.d('📝 DEBUG: Display name: $friendlyName');

      // Create Supabase Auth user with display_name in metadata
      // The database trigger will read this and create the user profile
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': friendlyName},
      );

      final user = response.user;
      if (user == null) {
        return const AuthResult.failure(
          'Unable to create account. Please try again.',
        );
      }

      AppLog.d('✅ DEBUG: Auth user created: ${user.id}');
      AppLog.d('✅ DEBUG: User metadata: ${user.userMetadata}');
      AppLog.d('ℹ️ DEBUG: User profile will be created by database trigger');

      // Note: The database trigger (handle_new_user) will automatically
      // create a row in public.users with the display_name from metadata.
      // We no longer INSERT into users table directly.

      // Initialize encryption for the new user
      // Note: PIN-based encryption is set up in PIN setup screen after registration
      // The user will be prompted to create a PIN which will initialize encryption
      ErrorHandler.logInfo(
        'AuthService',
        'User registered, PIN setup will initialize encryption',
      );

      return const AuthResult.success();
    } on AuthException catch (e, stackTrace) {
      ErrorHandler.logError(
        'AuthService.register.AuthException',
        e,
        stackTrace,
      );
      AppLog.e('❌ DEBUG: AuthException: ${e.message}');
      final message = e.message.contains('already registered')
          ? 'Email is already in use.'
          : e.message;
      return AuthResult.failure(message);
    } catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.register', e, stackTrace);
      AppLog.e('❌ DEBUG: Unexpected error: $e');
      return const AuthResult.failure(
        'Unexpected error occurred while creating the account.',
      );
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      UserService.clearCache(); // Clear cached user ID
      _encryption.lock(); // Clear encryption keys from memory
    } catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.logout', e, stackTrace);
    }
  }
}

class AuthResult {
  final bool success;
  final String? errorMessage;

  const AuthResult._(this.success, this.errorMessage);
  const AuthResult.success() : this._(true, null);
  const AuthResult.failure(String message) : this._(false, message);
}
