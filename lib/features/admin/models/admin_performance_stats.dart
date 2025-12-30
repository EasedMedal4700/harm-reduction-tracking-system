// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Performance metrics surfaced in Admin panel.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_performance_stats.freezed.dart'; // Freezed part
part 'admin_performance_stats.g.dart'; // JSON serialization part

@freezed
abstract class AdminPerformanceStats with _$AdminPerformanceStats {
  const factory AdminPerformanceStats({
    @Default(0.0) double avgResponseTimeMs,
    @Default(0.0) double avgCachedResponseMs,
    @Default(0.0) double avgUncachedResponseMs,
    @Default(0) int totalSamples,
    @Default(0.0) double cacheHitRate,
    @Default(0) int cacheHits,
    @Default(0) int cacheMisses,
    @Default(0) int cacheTotalRequests,
    DateTime? lastUpdated,
    String? error,
  }) = _AdminPerformanceStats;

  // Method to parse date (if needed for manual JSON mapping)
  static DateTime? _parseDate(dynamic v) {
    if (v is DateTime) return v;
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }

  // Adding the fromJson and toJson methods for JSON serialization
  factory AdminPerformanceStats.fromJson(Map<String, dynamic> json) =>
      _$AdminPerformanceStatsFromJson(json); // Generated from json_serializable

  factory AdminPerformanceStats.fromServiceMap(Map<String, dynamic> map) {
    return AdminPerformanceStats(
      avgResponseTimeMs: ((map['avg_response_time'] ?? 0.0) as num).toDouble(),
      avgCachedResponseMs: ((map['avg_cached_response'] ?? 0.0) as num)
          .toDouble(),
      avgUncachedResponseMs: ((map['avg_uncached_response'] ?? 0.0) as num)
          .toDouble(),
      totalSamples: (map['total_samples'] as int?) ?? 0,
      cacheHitRate: ((map['cache_hit_rate'] ?? 0.0) as num).toDouble(),
      cacheHits: (map['cache_hits'] as int?) ?? 0,
      cacheMisses: (map['cache_misses'] as int?) ?? 0,
      cacheTotalRequests: (map['cache_total_requests'] as int?) ?? 0,
      lastUpdated: _parseDate(map['last_updated']),
      error: map['error'] as String?,
    );
  }
}
