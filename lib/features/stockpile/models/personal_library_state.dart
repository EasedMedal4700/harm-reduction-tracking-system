// MIGRATION:
// State: MODERN
// Navigation: GOROUTER-READY
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_drug_use_app/features/catalog/models/drug_catalog_entry.dart';

part 'personal_library_state.freezed.dart';

@freezed
abstract class PersonalLibrarySummary with _$PersonalLibrarySummary {
  const factory PersonalLibrarySummary({
    @Default(0) int totalUses,
    @Default(0) int activeSubstances,
    @Default(0.0) double avgUses,
    @Default('None') String mostUsedCategory,
  }) = _PersonalLibrarySummary;

  const PersonalLibrarySummary._();
}

@freezed
abstract class PersonalLibraryState with _$PersonalLibraryState {
  const factory PersonalLibraryState({
    @Default(<DrugCatalogEntry>[]) List<DrugCatalogEntry> catalog,
    @Default(<DrugCatalogEntry>[]) List<DrugCatalogEntry> filtered,
    @Default('') String query,
    @Default(false) bool showArchived,
    @Default(PersonalLibrarySummary()) PersonalLibrarySummary summary,
  }) = _PersonalLibraryState;

  const PersonalLibraryState._();
}
