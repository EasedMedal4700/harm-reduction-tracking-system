// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Riverpod state for admin panel using Freezed model for immutability.

import 'package:freezed_annotation/freezed_annotation.dart';

import 'admin_cache_stats.dart';
import 'admin_performance_stats.dart';
import 'admin_system_stats.dart';
import 'admin_user.dart';

part 'admin_panel_state.freezed.dart'; // This generates the Freezed class
part 'admin_panel_state.g.dart'; // This generates the JSON serialization code

@freezed
abstract class AdminPanelState with _$AdminPanelState {
  const factory AdminPanelState({
    @Default(true) bool isLoading,
    @Default(<AdminUser>[]) List<AdminUser> users,
    @Default(AdminSystemStats()) AdminSystemStats systemStats,
    @Default(AdminCacheStats()) AdminCacheStats cacheStats,
    @Default(AdminPerformanceStats()) AdminPerformanceStats performanceStats,
    String? errorMessage,
  }) = _AdminPanelState;

  const AdminPanelState._(); // Private constructor for additional methods

  // Factory method for JSON serialization
  factory AdminPanelState.fromJson(Map<String, dynamic> json) =>
      _$AdminPanelStateFromJson(json); // This generates the `fromJson` and `toJson` methods
}
