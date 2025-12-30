// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_performance_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminPerformanceStats _$AdminPerformanceStatsFromJson(
  Map<String, dynamic> json,
) => _AdminPerformanceStats(
  avgResponseTimeMs: (json['avgResponseTimeMs'] as num?)?.toDouble() ?? 0.0,
  avgCachedResponseMs: (json['avgCachedResponseMs'] as num?)?.toDouble() ?? 0.0,
  avgUncachedResponseMs:
      (json['avgUncachedResponseMs'] as num?)?.toDouble() ?? 0.0,
  totalSamples: (json['totalSamples'] as num?)?.toInt() ?? 0,
  cacheHitRate: (json['cacheHitRate'] as num?)?.toDouble() ?? 0.0,
  cacheHits: (json['cacheHits'] as num?)?.toInt() ?? 0,
  cacheMisses: (json['cacheMisses'] as num?)?.toInt() ?? 0,
  cacheTotalRequests: (json['cacheTotalRequests'] as num?)?.toInt() ?? 0,
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
  error: json['error'] as String?,
);

Map<String, dynamic> _$AdminPerformanceStatsToJson(
  _AdminPerformanceStats instance,
) => <String, dynamic>{
  'avgResponseTimeMs': instance.avgResponseTimeMs,
  'avgCachedResponseMs': instance.avgCachedResponseMs,
  'avgUncachedResponseMs': instance.avgUncachedResponseMs,
  'totalSamples': instance.totalSamples,
  'cacheHitRate': instance.cacheHitRate,
  'cacheHits': instance.cacheHits,
  'cacheMisses': instance.cacheMisses,
  'cacheTotalRequests': instance.cacheTotalRequests,
  'lastUpdated': instance.lastUpdated?.toIso8601String(),
  'error': instance.error,
};
