// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Riverpod state for admin panel.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'admin_cache_stats.dart';
import 'admin_performance_stats.dart';
import 'admin_system_stats.dart';
import 'admin_user.dart';

part 'admin_panel_state.freezed.dart';

@freezed
class AdminPanelState with _$AdminPanelState {
  const factory AdminPanelState({
    @Default(true) bool isLoading,
    @Default(<AdminUser>[]) List<AdminUser> users,
    @Default(AdminSystemStats()) AdminSystemStats systemStats,
    @Default(AdminCacheStats()) AdminCacheStats cacheStats,
    @Default(AdminPerformanceStats()) AdminPerformanceStats performanceStats,
    String? errorMessage,
  }) = _AdminPanelState;
}
