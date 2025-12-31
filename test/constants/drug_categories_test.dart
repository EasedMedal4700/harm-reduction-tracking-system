import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';

void main() {
  group('DrugCategories.primaryCategoryFromRaw', () {
    test('returns Placeholder when missing', () {
      expect(DrugCategories.primaryCategoryFromRaw(null), 'Placeholder');
      expect(DrugCategories.primaryCategoryFromRaw('  '), 'Placeholder');
    });

    test('prefers priority categories when multiple are provided', () {
      // Psychedelic ranks higher than Stimulant in the priority list.
      expect(
        DrugCategories.primaryCategoryFromRaw('Stimulant, Psychedelic'),
        'Psychedelic',
      );
    });

    test('returns Experimental for unknown categories', () {
      expect(
        DrugCategories.primaryCategoryFromRaw('MadeUpCategory'),
        'Experimental',
      );
    });
  });
}
