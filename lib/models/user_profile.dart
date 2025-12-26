// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Data model.
/// User profile model matching the public.users table structure.
///
/// The user profile is automatically created by a database trigger when
/// a new auth user signs up. The app should only READ and UPDATE profiles,
/// never INSERT.
class UserProfile {
  /// The auth user ID (UUID) - primary key, references auth.users(id)
  final String authUserId;

  /// The user's display name
  final String displayName;

  /// Whether the user has admin privileges
  final bool isAdmin;

  /// Email from auth.users (not stored in public.users)
  final String? email;
  const UserProfile({
    required this.authUserId,
    required this.displayName,
    required this.isAdmin,
    this.email,
  });

  /// Create a UserProfile from a database row + auth user data
  factory UserProfile.fromJson(Map<String, dynamic> json, {String? email}) {
    return UserProfile(
      authUserId: json['auth_user_id'] as String,
      displayName: json['display_name'] as String? ?? 'User',
      isAdmin: json['is_admin'] as bool? ?? false,
      email: email,
    );
  }

  /// Convert to JSON for updates (only mutable fields)
  Map<String, dynamic> toUpdateJson() {
    return {
      'display_name': displayName,
      // Note: is_admin should not be updatable by the user themselves
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({String? displayName, bool? isAdmin, String? email}) {
    return UserProfile(
      authUserId: authUserId,
      displayName: displayName ?? this.displayName,
      isAdmin: isAdmin ?? this.isAdmin,
      email: email ?? this.email,
    );
  }

  @override
  String toString() {
    return 'UserProfile(authUserId: $authUserId, displayName: $displayName, isAdmin: $isAdmin, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.authUserId == authUserId &&
        other.displayName == displayName &&
        other.isAdmin == isAdmin &&
        other.email == email;
  }

  @override
  int get hashCode {
    return authUserId.hashCode ^
        displayName.hashCode ^
        isAdmin.hashCode ^
        email.hashCode;
  }
}

/// Exception thrown when user profile operations fail
class UserProfileException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  const UserProfileException(this.message, {this.code, this.originalError});
  @override
  String toString() => 'UserProfileException: $message (code: $code)';

  /// Profile not found - user should contact support
  bool get isProfileMissing => code == 'PROFILE_NOT_FOUND';

  /// RLS blocked the operation
  bool get isUnauthorized => code == '42501' || code == 'UNAUTHORIZED';
}
