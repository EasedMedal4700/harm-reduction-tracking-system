// MIGRATION:
// State: MODERN
// Navigation: GOROUTER-READY
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod controller for weekday usage sheet

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/day_usage_models.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';

part 'day_usage_controller.g.dart';

@riverpod
class DayUsageController extends _$DayUsageController {
  @override
  Future<List<DayUsageEntry>> build({
    required String substanceName,
    required int weekdayIndex,
  }) async {
    final service = ref.watch(dayUsageServiceProvider);
    return service.fetchForWeekday(
      substanceName: substanceName,
      weekdayIndex: weekdayIndex,
    );
  }
}
