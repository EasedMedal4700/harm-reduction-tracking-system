// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Comprehensive tests for tolerance logic

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_logic.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';

void main() {
  group('ToleranceLogic - loadToPercent', () {
    test('converts 0.0 to 0%', () {
      expect(ToleranceLogic.loadToPercent(0.0), 0.0);
    });

    test('converts 0.5 to 50%', () {
      expect(ToleranceLogic.loadToPercent(0.5), 50.0);
    });

    test('converts 1.0 to 100%', () {
      expect(ToleranceLogic.loadToPercent(1.0), 100.0);
    });

    test('clamps negative values to 0%', () {
      expect(ToleranceLogic.loadToPercent(-1.0), 0.0);
      expect(ToleranceLogic.loadToPercent(-0.5), 0.0);
      expect(ToleranceLogic.loadToPercent(-100.0), 0.0);
    });

    test('clamps values above 1.0 to 100%', () {
      expect(ToleranceLogic.loadToPercent(1.5), 100.0);
      expect(ToleranceLogic.loadToPercent(2.0), 100.0);
      expect(ToleranceLogic.loadToPercent(100.0), 100.0);
    });

    test('handles very small values', () {
      expect(ToleranceLogic.loadToPercent(0.001), 0.1);
      expect(ToleranceLogic.loadToPercent(0.0001), closeTo(0.01, 0.001));
    });
  });

  group('ToleranceLogic - computeTolerance', () {
    test('handles empty use logs', () {
      final result = ToleranceLogic.computeTolerance(
        useLogs: [],
        toleranceModels: {},
      );

      expect(result.toleranceScore, 0.0);
      expect(result.bucketPercents['stimulant'], 0.0);
      expect(result.bucketPercents['gaba'], 0.0);
      expect(result.bucketRawLoads.isEmpty, isFalse); // bucketRawLoads has all buckets initialized to 0
      expect(result.substanceContributions.isEmpty, isTrue);
      expect(result.substanceActiveStates.isEmpty, isTrue);
    });

    test('handles empty tolerance models', () {
      final logs = [
        UseLogEntry(
          substanceSlug: 'unknown',
          timestamp: DateTime.now(),
          doseUnits: 100,
        ),
      ];

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {},
      );

      expect(result.toleranceScore, 0.0);
      expect(result.substanceContributions.isEmpty, isTrue);
    });

    test('calculates tolerance for single recent use', () {
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
      expect(result.bucketPercents['stimulant']!, greaterThan(0.0));
      expect(result.toleranceScore, greaterThan(0.0));
      expect(
        result.substanceContributions['stimulant']?['caffeine'],
        greaterThan(0.0),
      );
      expect(result.substanceActiveStates['caffeine'], isTrue);
    });

    test('calculates tolerance for multiple substances', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: now.subtract(const Duration(hours: 2)),
          doseUnits: 20,
        ),
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(hours: 3)),
          doseUnits: 100,
        ),
      ];

      final alcoholBucket = NeuroBucket(name: 'gaba', weight: 0.9);
      final caffeineBucket = NeuroBucket(name: 'stimulant', weight: 1.0);

      final models = {
        'alcohol': ToleranceModel(
          neuroBuckets: {'gaba': alcoholBucket},
          halfLifeHours: 8.0,
          toleranceDecayDays: 3.0,
          standardUnitMg: 10.0,
        ),
        'caffeine': ToleranceModel(
          neuroBuckets: {'stimulant': caffeineBucket},
          halfLifeHours: 5.0,
          toleranceDecayDays: 2.0,
          standardUnitMg: 100.0,
        ),
      };

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: models,
      );

      expect(result.bucketPercents['gaba'], greaterThan(0.0));
      expect(result.bucketPercents['stimulant'], greaterThan(0.0));
      expect(result.substanceContributions['gaba']?['alcohol'], greaterThan(0.0));
      expect(result.substanceContributions['stimulant']?['caffeine'], greaterThan(0.0));
    });

    test('handles multiple uses of same substance', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(hours: 1)),
          doseUnits: 100,
        ),
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(hours: 5)),
          doseUnits: 100,
        ),
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(hours: 10)),
          doseUnits: 100,
        ),
      ];

      final bucket = NeuroBucket(name: 'stimulant', weight: 1.0);
      final model = ToleranceModel(
        neuroBuckets: {'stimulant': bucket},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
      );

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'caffeine': model},
      );

      // Multiple uses should accumulate
      expect(result.bucketPercents['stimulant'], greaterThan(0.0));
      expect(result.bucketRawLoads['stimulant'], greaterThan(0.0));
    });

    test('calculates tolerance decay over time', () {
      final now = DateTime.now();

      final recentLog = UseLogEntry(
        substanceSlug: 'caffeine',
        timestamp: now.subtract(const Duration(hours: 1)),
        doseUnits: 100,
      );

      final oldLog = UseLogEntry(
        substanceSlug: 'caffeine',
        timestamp: now.subtract(const Duration(days: 10)),
        doseUnits: 100,
      );

      final bucket = NeuroBucket(name: 'stimulant', weight: 1.0);
      final model = ToleranceModel(
        neuroBuckets: {'stimulant': bucket},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
      );

      final recentResult = ToleranceLogic.computeTolerance(
        useLogs: [recentLog],
        toleranceModels: {'caffeine': model},
      );

      final oldResult = ToleranceLogic.computeTolerance(
        useLogs: [oldLog],
        toleranceModels: {'caffeine': model},
      );

      expect(
        recentResult.bucketPercents['stimulant']!,
        greaterThan(oldResult.bucketPercents['stimulant']!),
      );
    });

    test('handles substance with multiple neuro buckets', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'mdma',
          timestamp: now.subtract(const Duration(hours: 6)),
          doseUnits: 100,
        ),
      ];

      final models = {
        'mdma': ToleranceModel(
          neuroBuckets: {
            'serotonin_release': NeuroBucket(name: 'serotonin_release', weight: 1.0),
            'stimulant': NeuroBucket(name: 'stimulant', weight: 0.35),
          },
          halfLifeHours: 9.0,
          toleranceDecayDays: 30.0,
          standardUnitMg: 100.0,
        ),
      };

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: models,
      );

      expect(result.bucketPercents['serotonin_release'], greaterThan(0.0));
      expect(result.bucketPercents['stimulant'], greaterThan(0.0));
      expect(
        result.bucketPercents['serotonin_release']!,
        greaterThan(result.bucketPercents['stimulant']!),
      );
    });

    test('respects potency multiplier', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'test',
          timestamp: now.subtract(const Duration(hours: 1)),
          doseUnits: 100,
        ),
      ];

      final normalModel = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
        potencyMultiplier: 1.0,
      );

      final potentModel = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
        potencyMultiplier: 2.0,
      );

      final normalResult = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'test': normalModel},
      );

      final potentResult = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'test': potentModel},
      );

      expect(
        potentResult.bucketPercents['stimulant']!,
        greaterThan(normalResult.bucketPercents['stimulant']!),
      );
    });

    test('respects tolerance gain rate', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'test',
          timestamp: now.subtract(const Duration(hours: 1)),
          doseUnits: 100,
        ),
      ];

      final lowGainModel = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
        toleranceGainRate: 0.5,
      );

      final highGainModel = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
        toleranceGainRate: 2.0,
      );

      final lowResult = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'test': lowGainModel},
      );

      final highResult = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'test': highGainModel},
      );

      expect(
        highResult.bucketPercents['stimulant']!,
        greaterThan(lowResult.bucketPercents['stimulant']!),
      );
    });

    test('calculates days until baseline correctly', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(hours: 1)),
          doseUnits: 100,
        ),
      ];

      final model = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
      );

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'caffeine': model},
      );

      expect(result.daysUntilBaseline['stimulant'], greaterThan(0.0));
      expect(result.overallDaysUntilBaseline, greaterThan(0.0));
    });

    test('handles very old use logs with near-zero tolerance', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.subtract(const Duration(days: 60)),
          doseUnits: 100,
        ),
      ];

      final model = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
      );

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'caffeine': model},
      );

      // Very old logs should have minimal contribution
      expect(result.bucketPercents['stimulant']!, lessThan(1.0));
    });

    test('handles future timestamps gracefully', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'caffeine',
          timestamp: now.add(const Duration(hours: 1)),
          doseUnits: 100,
        ),
      ];

      final model = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
      );

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'caffeine': model},
      );

      // Future timestamps should be ignored
      expect(result.bucketPercents['stimulant'], 0.0);
    });

    test('ignores contributions below threshold', () {
      final now = DateTime.now();
      final logs = [
        UseLogEntry(
          substanceSlug: 'test',
          timestamp: now.subtract(const Duration(days: 30)),
          doseUnits: 0.1, // Very small dose
        ),
      ];

      final model = ToleranceModel(
        neuroBuckets: {'stimulant': NeuroBucket(name: 'stimulant', weight: 0.01)},
        halfLifeHours: 5.0,
        toleranceDecayDays: 2.0,
        standardUnitMg: 100.0,
      );

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: {'test': model},
      );

      // Very small contributions should not appear
      expect(result.substanceContributions['stimulant'], isNull);
    });
  });

  group('ToleranceLogic - classifyState', () {
    test('classifies 0-20% as recovered', () {
      expect(
        ToleranceLogic.classifyState(0.0),
        ToleranceSystemState.recovered,
      );
      expect(
        ToleranceLogic.classifyState(10.0),
        ToleranceSystemState.recovered,
      );
      expect(
        ToleranceLogic.classifyState(19.9),
        ToleranceSystemState.recovered,
      );
    });

    test('classifies 20-40% as light stress', () {
      expect(
        ToleranceLogic.classifyState(20.0),
        ToleranceSystemState.lightStress,
      );
      expect(
        ToleranceLogic.classifyState(30.0),
        ToleranceSystemState.lightStress,
      );
      expect(
        ToleranceLogic.classifyState(39.9),
        ToleranceSystemState.lightStress,
      );
    });

    test('classifies 40-60% as moderate strain', () {
      expect(
        ToleranceLogic.classifyState(40.0),
        ToleranceSystemState.moderateStrain,
      );
      expect(
        ToleranceLogic.classifyState(50.0),
        ToleranceSystemState.moderateStrain,
      );
      expect(
        ToleranceLogic.classifyState(59.9),
        ToleranceSystemState.moderateStrain,
      );
    });

    test('classifies 60-80% as high strain', () {
      expect(
        ToleranceLogic.classifyState(60.0),
        ToleranceSystemState.highStrain,
      );
      expect(
        ToleranceLogic.classifyState(70.0),
        ToleranceSystemState.highStrain,
      );
      expect(
        ToleranceLogic.classifyState(79.9),
        ToleranceSystemState.highStrain,
      );
    });

    test('classifies 80%+ as depleted', () {
      expect(
        ToleranceLogic.classifyState(80.0),
        ToleranceSystemState.depleted,
      );
      expect(
        ToleranceLogic.classifyState(90.0),
        ToleranceSystemState.depleted,
      );
      expect(
        ToleranceLogic.classifyState(100.0),
        ToleranceSystemState.depleted,
      );
    });
  });
}
