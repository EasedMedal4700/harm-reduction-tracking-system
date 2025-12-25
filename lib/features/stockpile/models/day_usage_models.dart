// MIGRATION:
// State: MODERN
// Navigation: GOROUTER-READY
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE

import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_usage_models.freezed.dart';

@freezed
class DayUsageEntry with _$DayUsageEntry {
  const factory DayUsageEntry({
    required DateTime startTime,
    required String dose,
    required String route,
    required bool isMedical,
  }) = _DayUsageEntry;

  const DayUsageEntry._();
}
