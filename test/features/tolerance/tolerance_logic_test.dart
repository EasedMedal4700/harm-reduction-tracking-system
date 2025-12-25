// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Tests for tolerance logic

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_logic.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';

void main() {
  group('ToleranceLogic', () {
    test('loadToPercent clamps values', () {
      expect(ToleranceLogic.loadToPercent(-1.0), 0.0);
      expect(ToleranceLogic.loadToPercent(0.0), 0.0);
      expect(ToleranceLogic.loadToPercent(0.5), 50.0);
      expect(ToleranceLogic.loadToPercent(1.5), 100.0);
    });

    test('computeTolerance calculates correctly for single entry', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(hours: 1)),
          doseUnits: 100,
        ),
      ];

      final bucket = NeuroBucket(name: 'stimulant', weight: 1.0);
      final model = ToleranceModel(
        neuroBuckets: {'stimulant': bucket},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
        toleranceGainRate: 1.0,
      );

      final models = {'caffeine': model};

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: models,
      );

      expect(result.bucketPercents.containsKey('stimulant'), isTrue);
      expect(result.bucketPercents['stimulant'], greaterThan(0.0));
      expect(
        result.substanceContributions['stimulant']?['caffeine'],
        greaterThan(0.0),
      );
      expect(result.substanceActiveStates['caffeine'], isTrue);
    });

    test('computeTolerance handles empty logs', () {
      final result = ToleranceLogic.computeTolerance(
        useLogs: [],
        toleranceModels: {},
      );

      expect(result.toleranceScore, 0.0);
      expect(result.bucketPercents['stimulant'], 0.0);
    });
  });
}
