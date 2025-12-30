// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: System-level stats surfaced in Admin panel.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_system_stats.freezed.dart';

@freezed
abstract class AdminSystemStats with _$AdminSystemStats {
  const factory AdminSystemStats({
    @Default(0) int totalEntries,
    @Default(0) int activeUsers,
    @Default(0.0) double cacheHitRate,
    @Default(0.0) double avgResponseTimeMs,
  }) = _AdminSystemStats;

  factory AdminSystemStats.fromServiceMap(Map<String, dynamic> map) {
    return AdminSystemStats(
      totalEntries: (map['total_entries'] as int?) ?? 0,
      activeUsers: (map['active_users'] as int?) ?? 0,
      cacheHitRate: ((map['cache_hit_rate'] ?? 0.0) as num).toDouble(),
      avgResponseTimeMs: ((map['avg_response_time'] ?? 0.0) as num).toDouble(),
    );
  }
}
