// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';

/// User profile model matching the public.users table structure.
///
/// The user profile is automatically created by a database trigger when
/// a new auth user signs up. The app should only READ and UPDATE profiles,
/// never INSERT.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    /// The auth user ID (UUID) - primary key, references auth.users(id)
    required String authUserId,

    /// The user's display name
    @Default('User') String displayName,

    /// Whether the user has admin privileges
    @Default(false) bool isAdmin,

    /// Email from auth.users (not stored in public.users)
    String? email,
  }) = _UserProfile;

  const UserProfile._();

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      authUserId:
          (json['auth_user_id'] as String?) ??
          (json['authUserId'] as String?) ??
          '',
      displayName:
          (json['display_name'] as String?) ??
          (json['displayName'] as String?) ??
          'User',
      isAdmin:
          (json['is_admin'] as bool?) ?? (json['isAdmin'] as bool?) ?? false,
      email: (json['email'] as String?),
    );
  }

  /// Create a UserProfile from a database row + auth user data
  factory UserProfile.fromServiceJson(
    Map<String, dynamic> json, {
    String? email,
  }) {
    return UserProfile.fromJson({...json, if (email != null) 'email': email});
  }

  /// Convert to JSON for updates (only mutable fields)
  Map<String, dynamic> toUpdateJson() {
    return {
      'display_name': displayName,
      // Note: is_admin should not be updatable by the user themselves
    };
  }
}

/// Exception thrown when user profile operations fail
@freezed
abstract class UserProfileException
    with _$UserProfileException
    implements Exception {
  const factory UserProfileException(
    String message, {
    String? code,
    Object? originalError,
  }) = _UserProfileException;

  const UserProfileException._();

  @override
  String toString() => 'UserProfileException: $message (code: $code)';

  /// Profile not found - user should contact support
  bool get isProfileMissing => code == 'PROFILE_NOT_FOUND';

  /// RLS blocked the operation
  bool get isUnauthorized => code == '42501' || code == 'UNAUTHORIZED';
}
