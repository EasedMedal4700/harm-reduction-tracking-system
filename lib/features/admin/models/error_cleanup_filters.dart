// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Typed result for error log cleanup dialog.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_cleanup_filters.freezed.dart';

@freezed
abstract class ErrorCleanupFilters with _$ErrorCleanupFilters {
  const factory ErrorCleanupFilters({
    @Default(false) bool deleteAll,
    int? olderThanDays,
    String? platform,
    String? screenName,
  }) = _ErrorCleanupFilters;
}
