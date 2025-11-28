import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'user_service.dart';
import 'encryption_service.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;
  final _encryption = EncryptionService();

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

      // Initialize encryption for the logged-in user
      try {
        await _encryption.initialize();
        print('🔐 DEBUG: Encryption initialized successfully');
      } catch (e) {
        print('⚠️ DEBUG: Failed to initialize encryption: $e');
        // Don't fail login if encryption fails - log and continue
        ErrorHandler.logError('AuthService.login.encryption', e, StackTrace.current);
      }

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
    try {
      final existingUser = await _client
          .from('users')
          .select('user_id')
          .eq('email', email)
          .maybeSingle();

      if (existingUser != null) {
        return const AuthResult.failure('Email is already in use.');
      }
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.register.checkEmail', e, stackTrace);
      return const AuthResult.failure(
        'Unable to verify email. Please try again later.',
      );
    }

    try {
      // Create Supabase Auth user
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return const AuthResult.failure(
          'Unable to create account. Please try again.',
        );
      }

      final friendlyName =
          displayName?.trim().isNotEmpty == true ? displayName!.trim() : email;

      // Insert into users table and verify it succeeds
      try {
        final insertResponse = await _client.from('users').insert({
          'email': email,
          'display_name': friendlyName,
          'is_admin': false,
        }).select('user_id').single();

        // Verify we got a user_id back
        if (insertResponse['user_id'] == null) {
          return const AuthResult.failure(
            'Failed to create user profile. Please try again.',
          );
        }
      } on PostgrestException catch (e, stackTrace) {
        ErrorHandler.logError('AuthService.register.insertUser', e, stackTrace);
        
        if (e.code == '23505') {
          // Unique constraint violation
          return const AuthResult.failure('Email is already in use.');
        }
        return const AuthResult.failure(
          'Failed to create user profile. Please try again.',
        );
      }

      // Initialize encryption for the new user
      try {
        await _encryption.initialize();
        ErrorHandler.logInfo('AuthService', 'Encryption initialized for new user');
      } catch (e, stackTrace) {
        ErrorHandler.logError('AuthService.register.encryption', e, stackTrace);
        // Don't fail registration if encryption fails - log and continue
      }

      return const AuthResult.success();
    } on AuthException catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.register.AuthException', e, stackTrace);
      final message = e.message.contains('already registered')
          ? 'Email is already in use.'
          : e.message;
      return AuthResult.failure(message);
    } catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.register', e, stackTrace);
      return const AuthResult.failure(
        'Unexpected error occurred while creating the account.',
      );
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      UserService.clearCache(); // Clear cached user ID
      _encryption.dispose(); // Clear encryption keys from memory
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
