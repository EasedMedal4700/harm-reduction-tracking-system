// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cache_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminCacheStats _$AdminCacheStatsFromJson(Map<String, dynamic> json) =>
    _AdminCacheStats(
      totalEntries: (json['totalEntries'] as num?)?.toInt() ?? 0,
      activeEntries: (json['activeEntries'] as num?)?.toInt() ?? 0,
      expiredEntries: (json['expiredEntries'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdminCacheStatsToJson(_AdminCacheStats instance) =>
    <String, dynamic>{
      'totalEntries': instance.totalEntries,
      'activeEntries': instance.activeEntries,
      'expiredEntries': instance.expiredEntries,
    };
