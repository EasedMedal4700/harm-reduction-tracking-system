import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'user_service.dart';
import 'encryption_service_v2.dart';

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
      print('🔐 DEBUG: Starting login for email: $email');
      print('🔐 DEBUG: Attempting sign in with password...');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('✅ DEBUG: Login successful!');
      print('✅ DEBUG: User ID: ${response.user?.id}');
      print('✅ DEBUG: Session exists: ${response.session != null}');
      print('✅ DEBUG: Session expires at: ${response.session?.expiresAt}');

      // Note: Encryption initialization is handled by login_page.dart
      // which checks for migration/PIN setup and routes appropriately

      return true;
    } on AuthException catch (e, stackTrace) {
      print('❌ DEBUG: AuthException during login');
      print('❌ DEBUG: Error message: ${e.message}');
      print('❌ DEBUG: Status code: ${e.statusCode}');
      ErrorHandler.logError('AuthService.login.AuthException', e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      print('❌ DEBUG: Generic exception during login');
      print('❌ DEBUG: Error: $e');
      print('❌ DEBUG: Stack trace: $stackTrace');
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

      print('📝 DEBUG: Starting registration for email: $email');
      print('📝 DEBUG: Display name: $friendlyName');

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

      print('✅ DEBUG: Auth user created: ${user.id}');
      print('✅ DEBUG: User metadata: ${user.userMetadata}');
      print('ℹ️ DEBUG: User profile will be created by database trigger');

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
      print('❌ DEBUG: AuthException: ${e.message}');
      final message = e.message.contains('already registered')
          ? 'Email is already in use.'
          : e.message;
      return AuthResult.failure(message);
    } catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.register', e, stackTrace);
      print('❌ DEBUG: Unexpected error: $e');
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
