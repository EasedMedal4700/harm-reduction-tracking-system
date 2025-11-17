import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';

class UserService {
  static int? _cachedUserId;
  static bool? _cachedIsAdmin;
  static Map<String, dynamic>? _cachedUserData;
  
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
    } catch (e, stackTrace) {
      ErrorHandler.logError('UserService.getIntegerUserId', e, stackTrace);
      throw StateError('Failed to fetch user ID from users table: $e');
    }
  }

  /// Check if the current user is an admin
  static Future<bool> isAdmin() async {
    // Return cached value if available
    if (_cachedIsAdmin != null) {
      return _cachedIsAdmin!;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return false;
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('is_admin')
          .eq('email', user.email!)
          .single();

      _cachedIsAdmin = response['is_admin'] as bool? ?? false;
      return _cachedIsAdmin!;
    } catch (e, stackTrace) {
      ErrorHandler.logError('UserService.isAdmin', e, stackTrace);
      return false;
    }
  }

  /// Get current user data including display name, email, etc.
  static Future<Map<String, dynamic>> getUserData() async {
    if (_cachedUserData != null) {
      return _cachedUserData!;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('user_id, email, display_name, is_admin, created_at, updated_at')
          .eq('email', user.email!)
          .single();

      _cachedUserData = response;
      _cachedUserId = response['user_id'] as int?;
      _cachedIsAdmin = response['is_admin'] as bool? ?? false;
      
      return _cachedUserData!;
    } catch (e, stackTrace) {
      ErrorHandler.logError('UserService.getUserData', e, stackTrace);
      throw StateError('Failed to fetch user data: $e');
    }
  }

  /// Clear the cached user data (call on logout)
  static void clearCache() {
    _cachedUserId = null;
    _cachedIsAdmin = null;
    _cachedUserData = null;
  }

  static bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
