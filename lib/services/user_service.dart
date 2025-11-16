import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  static int? _cachedUserId;
  
  static String getCurrentUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }
    return user.id;
  }

  /// Get the integer user_id from the users table based on the authenticated user's email
  static Future<int> getIntegerUserId() async {
    // Return cached value if available
    if (_cachedUserId != null) {
      return _cachedUserId!;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('user_id')
          .eq('email', user.email!)
          .single();

      _cachedUserId = response['user_id'] as int;
      return _cachedUserId!;
    } catch (e) {
      throw StateError('Failed to fetch user ID from users table: $e');
    }
  }

  /// Clear the cached user ID (call on logout)
  static void clearCache() {
    _cachedUserId = null;
  }

  static bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
