// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Cache stats for admin display.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_cache_stats.freezed.dart';

@freezed
class AdminCacheStats with _$AdminCacheStats {
  const factory AdminCacheStats({
    @Default(0) int totalEntries,
    @Default(0) int activeEntries,
    @Default(0) int expiredEntries,
  }) = _AdminCacheStats;

  factory AdminCacheStats.fromCacheServiceMap(Map<String, dynamic> map) {
    return AdminCacheStats(
      totalEntries: (map['total_entries'] as int?) ?? 0,
      activeEntries: (map['active_entries'] as int?) ?? 0,
      expiredEntries: (map['expired_entries'] as int?) ?? 0,
    );
  }
}
