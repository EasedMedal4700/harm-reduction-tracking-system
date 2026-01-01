// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug_catalog_entry.freezed.dart';

@freezed
abstract class DrugCatalogEntry with _$DrugCatalogEntry {
  const factory DrugCatalogEntry({
    required String name,
    required List<String> categories,
    required int totalUses,
    required double avgDose,
    DateTime? lastUsed,
    required WeekdayUsage weekdayUsage,
    required bool favorite,
    required bool archived,
    required String notes,
    required num quantity,
  }) = _DrugCatalogEntry;

  const DrugCatalogEntry._();
}

@freezed
abstract class WeekdayUsage with _$WeekdayUsage {
  const factory WeekdayUsage({
    required List<int> counts,
    required int mostActive,
    required int leastActive,
  }) = _WeekdayUsage;

  const WeekdayUsage._();
}

@freezed
abstract class LocalPrefs with _$LocalPrefs {
  const factory LocalPrefs({
    required bool favorite,
    required bool archived,
    required String notes,
    required num quantity,
  }) = _LocalPrefs;

  const LocalPrefs._();
}
