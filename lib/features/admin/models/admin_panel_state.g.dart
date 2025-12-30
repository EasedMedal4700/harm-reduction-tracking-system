// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_panel_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminPanelState _$AdminPanelStateFromJson(
  Map<String, dynamic> json,
) => _AdminPanelState(
  isLoading: json['isLoading'] as bool? ?? true,
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminUser>[],
  systemStats: json['systemStats'] == null
      ? const AdminSystemStats()
      : AdminSystemStats.fromJson(json['systemStats'] as Map<String, dynamic>),
  cacheStats: json['cacheStats'] == null
      ? const AdminCacheStats()
      : AdminCacheStats.fromJson(json['cacheStats'] as Map<String, dynamic>),
  performanceStats: json['performanceStats'] == null
      ? const AdminPerformanceStats()
      : AdminPerformanceStats.fromJson(
          json['performanceStats'] as Map<String, dynamic>,
        ),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$AdminPanelStateToJson(_AdminPanelState instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'users': instance.users,
      'systemStats': instance.systemStats,
      'cacheStats': instance.cacheStats,
      'performanceStats': instance.performanceStats,
      'errorMessage': instance.errorMessage,
    };
