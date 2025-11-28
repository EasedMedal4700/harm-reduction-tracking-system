import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'cache_service.dart';

class UserService {
  static bool? _cachedIsAdmin;
  static Map<String, dynamic>? _cachedUserData;
  static final _cache = CacheService();
  
  static String getCurrentUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }
    return user.id;
  }

  /// Get the integer user_id from the users table based on the authenticated user's email
  /// NOTE: user_id no longer exists - use getCurrentUserId() for auth_user_id instead
  @Deprecated('user_id column removed - use getCurrentUserId() instead')
  static Future<int> getIntegerUserId() async {
    // user_id column no longer exists in users table
    throw StateError('user_id column removed from users table. Use getCurrentUserId() for auth_user_id instead.');
  }

  /// Check if the current user is an admin
  static Future<bool> isAdmin() async {
    // Return cached value if available
    if (_cachedIsAdmin != null) {
      return _cachedIsAdmin!;
    }

    // Check cache service
    final cachedAdmin = _cache.get<bool>(CacheKeys.currentUserIsAdmin);
    if (cachedAdmin != null) {
      _cachedIsAdmin = cachedAdmin;
      return cachedAdmin;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return false;
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('is_admin')
          .eq('auth_user_id', user.id)
          .single();

      _cachedIsAdmin = response['is_admin'] as bool? ?? false;
      
      // Store in cache service
      _cache.set(CacheKeys.currentUserIsAdmin, _cachedIsAdmin!, ttl: CacheService.longTTL);
      
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

    // Check cache service
    final cachedData = _cache.get<Map<String, dynamic>>(CacheKeys.currentUserData);
    if (cachedData != null) {
      _cachedUserData = cachedData;
      _cachedIsAdmin = cachedData['is_admin'] as bool? ?? false;
      return cachedData;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }

    try {
      // Query public.users by auth_user_id
      final response = await Supabase.instance.client
          .from('users')
          .select('display_name, is_admin')
          .eq('auth_user_id', user.id)
          .single();

      // Merge with auth user data (email comes from auth.users)
      _cachedUserData = {
        'auth_user_id': user.id,
        'email': user.email ?? user.userMetadata?['email'] as String?,
        'display_name': response['display_name'],
        'is_admin': response['is_admin'] as bool? ?? false,
        'created_at': user.createdAt,
        'updated_at': user.updatedAt,
      };
      _cachedIsAdmin = response['is_admin'] as bool? ?? false;
      
      // Store in cache service
      _cache.set(CacheKeys.currentUserData, _cachedUserData!, ttl: CacheService.longTTL);
      
      return _cachedUserData!;
    } catch (e, stackTrace) {
      ErrorHandler.logError('UserService.getUserData', e, stackTrace);
      throw StateError('Failed to fetch user data: $e');
    }
  }

  /// Clear the cached user data (call on logout)
  static void clearCache() {
    _cachedIsAdmin = null;
    _cachedUserData = null;
    
    // Clear from cache service
    _cache.remove(CacheKeys.currentUserId);
    _cache.remove(CacheKeys.currentUserIsAdmin);
    _cache.remove(CacheKeys.currentUserData);
  }

  static bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
