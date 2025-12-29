import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/day_usage_models.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/personal_library_state.dart';
import 'package:mobile_drug_use_app/features/catalog/models/drug_catalog_entry.dart';

void main() {
  test('Freezed models and state construct', () {
    final usage = DayUsageEntry(
      startTime: DateTime(2025, 1, 1, 12),
      dose: '10 mg',
      route: 'oral',
      isMedical: false,
    );
    expect(usage.dose, '10 mg');

    const catalogEntry = DrugCatalogEntry(
      name: 'Test',
      categories: ['Stimulant'],
      totalUses: 3,
      avgDose: 5.0,
      lastUsed: null,
      weekdayUsage: WeekdayUsage(
        counts: [0, 1, 0, 0, 0, 0, 0],
        mostActive: 1,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );

    final state = PersonalLibraryState(
      catalog: const [catalogEntry],
      filtered: const [catalogEntry],
      query: '',
      showArchived: false,
      summary: const PersonalLibrarySummary(
        totalUses: 3,
        activeSubstances: 1,
        avgUses: 3.0,
        mostUsedCategory: 'Stimulant',
      ),
    );

    expect(state.catalog.single.name, 'Test');
    expect(state.summary.totalUses, 3);
  });
}
