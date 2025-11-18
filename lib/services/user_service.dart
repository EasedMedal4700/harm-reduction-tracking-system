import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/error_handler.dart';
import 'cache_service.dart';

class UserService {
  static int? _cachedUserId;
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
  static Future<int> getIntegerUserId() async {
    // Return cached value if available
    if (_cachedUserId != null) {
      return _cachedUserId!;
    }

    // Check cache service
    final cachedId = _cache.get<int>(CacheKeys.currentUserId);
    if (cachedId != null) {
      _cachedUserId = cachedId;
      return cachedId;
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
      
      // Store in cache service
      _cache.set(CacheKeys.currentUserId, _cachedUserId!, ttl: CacheService.longTTL);
      
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
          .eq('email', user.email!)
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
      _cachedUserId = cachedData['user_id'] as int?;
      _cachedIsAdmin = cachedData['is_admin'] as bool? ?? false;
      return cachedData;
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
    _cachedUserId = null;
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
