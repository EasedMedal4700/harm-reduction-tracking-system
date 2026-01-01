// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => _AdminUser(
  authUserId: json['authUserId'] as String,
  displayName: json['displayName'] as String? ?? 'Unknown',
  email: json['email'] as String? ?? 'N/A',
  isAdmin: json['isAdmin'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  lastActivity: json['lastActivity'] == null
      ? null
      : DateTime.parse(json['lastActivity'] as String),
  entryCount: (json['entryCount'] as num?)?.toInt() ?? 0,
  cravingCount: (json['cravingCount'] as num?)?.toInt() ?? 0,
  reflectionCount: (json['reflectionCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdminUserToJson(_AdminUser instance) =>
    <String, dynamic>{
      'authUserId': instance.authUserId,
      'displayName': instance.displayName,
      'email': instance.email,
      'isAdmin': instance.isAdmin,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'entryCount': instance.entryCount,
      'cravingCount': instance.cravingCount,
      'reflectionCount': instance.reflectionCount,
    };
