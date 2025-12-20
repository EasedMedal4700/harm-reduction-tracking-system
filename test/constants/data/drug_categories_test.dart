import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';

void main() {
  group('DrugCategories', () {
    test('categoryPriority has correct order', () {
      expect(DrugCategories.categoryPriority, [
        "Supplement",
        "Psychedelic",
        "Deliriant",
        "Dissociative",
        "Empathogen",
        "Opioid",
        "Benzodiazepine",
        "Barbiturate",
        "Stimulant",
        "Cathinone",
        "Depressant",
        "Nootropic",
        "SSRI",
      ]);
    });

    test('categoryPriority is not empty', () {
      expect(DrugCategories.categoryPriority, isNotEmpty);
    });

    test('categoryPriority contains expected categories', () {
      expect(DrugCategories.categoryPriority, contains('Psychedelic'));
      expect(DrugCategories.categoryPriority, contains('Opioid'));
      expect(DrugCategories.categoryPriority, contains('Stimulant'));
      expect(DrugCategories.categoryPriority, contains('Depressant'));
      expect(DrugCategories.categoryPriority, contains('Supplement'));
    });

    test('categoryPriority has Supplement as first priority', () {
      expect(DrugCategories.categoryPriority.first, 'Supplement');
    });

    test('categoryPriority has Other as last priority', () {
      expect(DrugCategories.categoryPriority.last, 'SSRI');
    });
  });

  group('DrugCategoryColors', () {
    test('psychedelic color is correct', () {
      expect(DrugCategoryColors.psychedelic, const Color(0xFF9C6BFF));
    });

    test('deliriant color is correct', () {
      expect(DrugCategoryColors.deliriant, const Color(0xFFC67EFF));
    });

    test('dissociative color is correct', () {
      expect(DrugCategoryColors.dissociative, const Color(0xFF00BFFF));
    });

    test('empathogen color is correct', () {
      expect(DrugCategoryColors.empathogen, const Color(0xFFFF5FB7));
    });

    test('opioid color is correct', () {
      expect(DrugCategoryColors.opioid, const Color(0xFFFF914D));
    });

    test('depressant color is correct', () {
      expect(DrugCategoryColors.depressant, const Color(0xFF1E90FF));
    });

    test('benzodiazepine color is correct', () {
      expect(DrugCategoryColors.benzodiazepine, const Color(0xFF6EB5FF));
    });

    test('barbiturate color is correct', () {
      expect(DrugCategoryColors.barbiturate, const Color(0xFFFFD86E));
    });

    test('stimulant color is correct', () {
      expect(DrugCategoryColors.stimulant, const Color(0xFF00E0FF));
    });

    test('cathinone color is correct', () {
      expect(DrugCategoryColors.cathinone, const Color(0xFF00C8FF));
    });

    test('nootropic color is correct', () {
      expect(DrugCategoryColors.nootropic, const Color(0xFF00C896));
    });

    test('ssri color is correct', () {
      expect(DrugCategoryColors.ssri, const Color(0xFF8C9EFF));
    });

    test('supplement color is correct', () {
      expect(DrugCategoryColors.supplement, const Color(0xFFA7FF83));
    });

    test('defaultColor equals stimulant', () {
      expect(DrugCategoryColors.defaultColor, DrugCategoryColors.stimulant);
    });

    test('colorFor returns correct color for valid category', () {
      expect(
        DrugCategoryColors.colorFor('psychedelic'),
        DrugCategoryColors.psychedelic,
      );
      expect(
        DrugCategoryColors.colorFor('Psychedelic'),
        DrugCategoryColors.psychedelic,
      );
      expect(
        DrugCategoryColors.colorFor('PSYCHEDELIC'),
        DrugCategoryColors.psychedelic,
      );
    });

    test('colorFor returns defaultColor for invalid category', () {
      expect(
        DrugCategoryColors.colorFor('invalid'),
        DrugCategoryColors.defaultColor,
      );
      expect(
        DrugCategoryColors.colorFor(null),
        DrugCategoryColors.defaultColor,
      );
    });

    test('colorFor returns correct color for cannabinoid', () {
      expect(
        DrugCategoryColors.colorFor('cannabinoid'),
        DrugCategoryColors.supplement,
      );
    });
  });
}
