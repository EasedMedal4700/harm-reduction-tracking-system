import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_user.freezed.dart';
part 'admin_user.g.dart'; // Ensure this part file is generated for JSON serialization

@freezed
abstract class AdminUser with _$AdminUser {
  const factory AdminUser({
    required String authUserId,
    @Default('Unknown') String displayName,
    @Default('N/A') String email,
    @Default(false) bool isAdmin,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivity,
    @Default(0) int entryCount,
    @Default(0) int cravingCount,
    @Default(0) int reflectionCount,
  }) = _AdminUser;

  const AdminUser._();

  int get totalActivity => entryCount + cravingCount + reflectionCount;

  // Method to parse DateTime if needed
  static DateTime? _parseDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  // Add fromServiceMap for converting a map to AdminUser
  factory AdminUser.fromServiceMap(Map<String, dynamic> map) {
    return AdminUser(
      authUserId: (map['auth_user_id'] as String?) ?? '',
      displayName:
          (map['display_name'] as String?) ??
          (map['username'] as String?) ??
          'Unknown',
      email: (map['email'] as String?) ?? 'N/A',
      isAdmin: (map['is_admin'] as bool?) ?? false,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      lastActivity: _parseDate(map['last_activity'] ?? map['last_active']),
      entryCount: (map['entry_count'] as int?) ?? 0,
      cravingCount: (map['craving_count'] as int?) ?? 0,
      reflectionCount: (map['reflection_count'] as int?) ?? 0,
    );
  }

  // Optional: JSON serialization
  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);
}
