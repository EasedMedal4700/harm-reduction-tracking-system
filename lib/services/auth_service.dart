import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'user_service.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return true;
    } on AuthException catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.login.AuthException', e, stackTrace);
      return false;
    } catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.login', e, stackTrace);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      UserService.clearCache(); // Clear cached user ID
    } catch (e, stackTrace) {
      ErrorHandler.logError('AuthService.logout', e, stackTrace);
    }
  }
}
