import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_service.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return true;
    } on AuthException catch (e) {
      debugPrint('Auth error: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.auth.signOut();
      UserService.clearCache(); // Clear cached user ID
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }
}
