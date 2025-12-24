import 'package:supabase_flutter/supabase_flutter.dart';

import '../common/logging/app_log.dart';
import '../models/user_profile.dart';
import '../utils/error_handler.dart';
import 'cache_service.dart';

/// Service for managing user profiles.
///
/// User profiles are automatically created by a database trigger when a new
/// auth user signs up. This service only handles READ and UPDATE operations.
///
/// Usage:
/// ```dart
/// final userService = UserService();
/// final profile = await userService.loadUserProfile();
/// await userService.updateDisplayName('New Name');
/// ```
class UserService {
  static bool? _cachedIsAdmin;
  static Map<String, dynamic>? _cachedUserData;
  static UserProfile? _cachedProfile;
  static final _cache = CacheService();

  final SupabaseClient _client;

  UserService([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  /// Get the current authenticated user's UUID
  static String getCurrentUserId() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('User is not logged in.');
    }
    return user.id;
  }

  /// Load the current user's profile from the database.
  ///
  /// This fetches the profile row created by the database trigger.
  /// Throws [UserProfileException] if the profile doesn't exist or on error.
  Future<UserProfile> loadUserProfile() async {
    // Return cached profile if available
    if (_cachedProfile != null) {
      return _cachedProfile!;
    }

    final user = _client.auth.currentUser;
    if (user == null) {
      throw const UserProfileException(
        'User is not logged in.',
        code: 'NOT_AUTHENTICATED',
      );
    }

    try {
      AppLog.i('👤 DEBUG: Loading user profile for ${user.id}');

      final response = await _client
          .from('users')
          .select('auth_user_id, display_name, is_admin')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      if (response == null) {
        AppLog.e('❌ DEBUG: User profile not found in database');
        throw const UserProfileException(
          'User profile not found. The account may not have been set up correctly. '
          'Please contact support.',
          code: 'PROFILE_NOT_FOUND',
        );
      }

      AppLog.i('✅ DEBUG: User profile loaded: ${response['display_name']}');

      final profile = UserProfile.fromJson(response, email: user.email);

      // Cache the profile
      _cachedProfile = profile;
      _cachedIsAdmin = profile.isAdmin;
      _cachedUserData = {
        'auth_user_id': profile.authUserId,
        'email': profile.email,
        'display_name': profile.displayName,
        'is_admin': profile.isAdmin,
      };

      // Store in cache service
      _cache.set(
        CacheKeys.currentUserData,
        _cachedUserData!,
        ttl: CacheService.longTTL,
      );
      _cache.set(
        CacheKeys.currentUserIsAdmin,
        profile.isAdmin,
        ttl: CacheService.longTTL,
      );

      return profile;
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError('UserService.loadUserProfile', e, stackTrace);
      throw UserProfileException(
        'Failed to load user profile: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e, stackTrace) {
      if (e is UserProfileException) rethrow;
      ErrorHandler.logError('UserService.loadUserProfile', e, stackTrace);
      throw UserProfileException(
        'Unexpected error loading profile: $e',
        originalError: e,
      );
    }
  }

  /// Update the user's profile with the given values.
  ///
  /// Only updates the provided fields. Pass null to keep current values.
  /// Note: is_admin cannot be updated by the user themselves.
  Future<UserProfile> updateUserProfile({String? displayName}) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const UserProfileException(
        'User is not logged in.',
        code: 'NOT_AUTHENTICATED',
      );
    }

    final updates = <String, dynamic>{};
    if (displayName != null) {
      updates['display_name'] = displayName;
    }

    if (updates.isEmpty) {
      // Nothing to update, just return current profile
      return await loadUserProfile();
    }

    try {
      AppLog.i('👤 DEBUG: Updating user profile: $updates');

      final response = await _client
          .from('users')
          .update(updates)
          .eq('auth_user_id', user.id)
          .select('auth_user_id, display_name, is_admin')
          .single();

      AppLog.i('✅ DEBUG: User profile updated successfully');

      final profile = UserProfile.fromJson(response, email: user.email);

      // Update cache
      _cachedProfile = profile;
      _cachedUserData = {
        'auth_user_id': profile.authUserId,
        'email': profile.email,
        'display_name': profile.displayName,
        'is_admin': profile.isAdmin,
      };
      _cache.set(
        CacheKeys.currentUserData,
        _cachedUserData!,
        ttl: CacheService.longTTL,
      );

      return profile;
    } on PostgrestException catch (e, stackTrace) {
      ErrorHandler.logError('UserService.updateUserProfile', e, stackTrace);

      if (e.code == '42501') {
        throw const UserProfileException(
          'You do not have permission to update this profile.',
          code: 'UNAUTHORIZED',
        );
      }

      throw UserProfileException(
        'Failed to update profile: ${e.message}',
        code: e.code,
        originalError: e,
      );
    }
  }

  /// Convenience method to update just the display name
  Future<UserProfile> updateDisplayName(String newDisplayName) async {
    return updateUserProfile(displayName: newDisplayName);
  }

  /// Check if the profile exists for the current user.
  /// Returns true if profile exists, false otherwise.
  Future<bool> hasProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    try {
      final response = await _client
          .from('users')
          .select('auth_user_id')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      AppLog.e('⚠️ DEBUG: Error checking profile existence: $e');
      return false;
    }
  }

  /// Wait for profile to be created by the trigger (with retries).
  ///
  /// After signup, there may be a brief delay before the trigger creates
  /// the profile. This method retries a few times with a delay.
  Future<UserProfile?> waitForProfile({
    int maxRetries = 5,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final profile = await loadUserProfile();
        return profile;
      } on UserProfileException catch (e) {
        if (e.isProfileMissing && i < maxRetries - 1) {
          AppLog.i(
            '👤 DEBUG: Profile not ready, retry ${i + 1}/$maxRetries...',
          );
          await Future.delayed(delay);
          continue;
        }
        rethrow;
      }
    }
    return null;
  }

  // ============================================
  // Static methods for backward compatibility
  // ============================================

  /// Check if the current user is an admin
  /// Returns false if user is not logged in (no error logged)
  static Future<bool> isAdmin() async {
    // First check if user is even logged in
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return false; // Not logged in, silently return false
    }

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

    try {
      final userService = UserService();
      final profile = await userService.loadUserProfile();
      return profile.isAdmin;
    } catch (e, stackTrace) {
      // Only log if it's not an authentication error
      if (e is! UserProfileException || e.code != 'NOT_AUTHENTICATED') {
        ErrorHandler.logError('UserService.isAdmin', e, stackTrace);
      }
      return false;
    }
  }

  /// Get current user data including display name, email, etc.
  /// @deprecated Use loadUserProfile() instead
  static Future<Map<String, dynamic>> getUserData() async {
    if (_cachedUserData != null) {
      return _cachedUserData!;
    }

    // Check cache service
    final cachedData = _cache.get<Map<String, dynamic>>(
      CacheKeys.currentUserData,
    );
    if (cachedData != null) {
      _cachedUserData = cachedData;
      _cachedIsAdmin = cachedData['is_admin'] as bool? ?? false;
      return cachedData;
    }

    try {
      final userService = UserService();
      final profile = await userService.loadUserProfile();
      return {
        'auth_user_id': profile.authUserId,
        'email': profile.email,
        'display_name': profile.displayName,
        'is_admin': profile.isAdmin,
      };
    } catch (e, stackTrace) {
      ErrorHandler.logError('UserService.getUserData', e, stackTrace);
      throw StateError('Failed to fetch user data: $e');
    }
  }

  /// Clear the cached user data (call on logout)
  static void clearCache() {
    _cachedIsAdmin = null;
    _cachedUserData = null;
    _cachedProfile = null;

    // Clear from cache service
    _cache.remove(CacheKeys.currentUserId);
    _cache.remove(CacheKeys.currentUserIsAdmin);
    _cache.remove(CacheKeys.currentUserData);
  }

  static bool isUserLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
