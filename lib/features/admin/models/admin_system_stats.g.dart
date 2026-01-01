// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_system_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminSystemStats _$AdminSystemStatsFromJson(Map<String, dynamic> json) =>
    _AdminSystemStats(
      totalEntries: (json['totalEntries'] as num?)?.toInt() ?? 0,
      activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
      cacheHitRate: (json['cacheHitRate'] as num?)?.toDouble() ?? 0.0,
      avgResponseTimeMs: (json['avgResponseTimeMs'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$AdminSystemStatsToJson(_AdminSystemStats instance) =>
    <String, dynamic>{
      'totalEntries': instance.totalEntries,
      'activeUsers': instance.activeUsers,
      'cacheHitRate': instance.cacheHitRate,
      'avgResponseTimeMs': instance.avgResponseTimeMs,
    };
