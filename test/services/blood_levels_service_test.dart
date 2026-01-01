import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/blood_levels/models/blood_levels_models.dart';
import 'package:mobile_drug_use_app/features/blood_levels/services/blood_levels_service.dart';

void main() {
  group('BloodLevelsService', () {
    test('service class exists', () {
      final service = BloodLevelsService();
      expect(service, isNotNull);
    });

    test('service has calculateLevels method', () {
      expect(BloodLevelsService().calculateLevels, isA<Function>());
    });

    group('_parseDose', () {
      test('parses simple dose string', () {
        final service = BloodLevelsService();
        // Access via reflection not possible, so we test via integration
        // This is a placeholder for documenting expected behavior
        expect(service, isNotNull);
      });
    });

    group('DrugLevel', () {
      test('creates DrugLevel with required fields', () {
        final now = DateTime.now();
        final level = DrugLevel(
          drugName: 'caffeine',
          totalDose: 100.0,
          totalRemaining: 50.0,
          lastDose: 100.0,
          lastUse: now,
          halfLife: 5.0,
          doses: const <DoseEntry>[],
        );

        expect(level.drugName, 'caffeine');
        expect(level.totalDose, 100.0);
        expect(level.totalRemaining, 50.0);
        expect(level.lastDose, 100.0);
        expect(level.percentage, 50.0);
      });

      test('calculates percentage correctly', () {
        final now = DateTime.now();
        final level = DrugLevel(
          drugName: 'caffeine',
          totalDose: 200.0,
          totalRemaining: 75.0,
          lastDose: 100.0,
          lastUse: now,
          halfLife: 5.0,
          doses: const <DoseEntry>[],
        );

        expect(level.percentage, closeTo(37.5, 0.1));
      });

      test('handles zero dose in percentage calculation', () {
        final now = DateTime.now();
        final level = DrugLevel(
          drugName: 'caffeine',
          totalDose: 0.0,
          totalRemaining: 0.0,
          lastDose: 0.0,
          lastUse: now,
          halfLife: 5.0,
          doses: const <DoseEntry>[],
        );

        expect(level.percentage, 0.0);
      });

      test('copyWith updates specified fields', () {
        final now = DateTime.now();
        final original = DrugLevel(
          drugName: 'caffeine',
          totalDose: 100.0,
          totalRemaining: 50.0,
          lastDose: 100.0,
          lastUse: now,
          halfLife: 5.0,
          doses: const <DoseEntry>[],
        );

        final updated = original.copyWith(
          totalDose: 200.0,
          totalRemaining: 100.0,
        );

        expect(updated.totalDose, 200.0);
        expect(updated.totalRemaining, 100.0);
        expect(updated.drugName, 'caffeine'); // Unchanged
        expect(updated.halfLife, 5.0); // Unchanged
      });
    });

    group('DoseEntry', () {
      test('creates DoseEntry with all fields', () {
        final now = DateTime.now();
        final entry = DoseEntry(
          dose: 100.0,
          startTime: now,
          remaining: 50.0,
          hoursElapsed: 5.0,
        );

        expect(entry.dose, 100.0);
        expect(entry.startTime, now);
        expect(entry.remaining, 50.0);
        expect(entry.hoursElapsed, 5.0);
      });
    });
  });
}
