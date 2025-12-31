import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/utils/tolerance_calculator.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_model.dart';

void main() {
  group('ToleranceCalculator', () {
    group('loadToPercent', () {
      test('returns 0 for non-positive or invalid loads', () {
        expect(ToleranceCalculator.loadToPercent(0), 0);
        expect(ToleranceCalculator.loadToPercent(-1), 0);
        expect(ToleranceCalculator.loadToPercent(double.nan), 0);
        expect(ToleranceCalculator.loadToPercent(double.negativeInfinity), 0);
      });

      test('maps raw load to percent and clamps to 0–100', () {
        expect(ToleranceCalculator.loadToPercent(0.145), closeTo(14.5, 1e-9));
        expect(ToleranceCalculator.loadToPercent(1.0), closeTo(100.0, 1e-9));
        expect(ToleranceCalculator.loadToPercent(2.0), closeTo(100.0, 1e-9));
      });
    });

    group('classifyState', () {
      test('classifies recovered state (0-20%)', () {
        expect(
          ToleranceCalculator.classifyState(0),
          ToleranceSystemState.recovered,
        );
        expect(
          ToleranceCalculator.classifyState(10),
          ToleranceSystemState.recovered,
        );
        expect(
          ToleranceCalculator.classifyState(19.9),
          ToleranceSystemState.recovered,
        );
      });

      test('classifies light stress state (20-40%)', () {
        expect(
          ToleranceCalculator.classifyState(20),
          ToleranceSystemState.lightStress,
        );
        expect(
          ToleranceCalculator.classifyState(30),
          ToleranceSystemState.lightStress,
        );
        expect(
          ToleranceCalculator.classifyState(39.9),
          ToleranceSystemState.lightStress,
        );
      });

      test('classifies moderate strain state (40-60%)', () {
        expect(
          ToleranceCalculator.classifyState(40),
          ToleranceSystemState.moderateStrain,
        );
        expect(
          ToleranceCalculator.classifyState(50),
          ToleranceSystemState.moderateStrain,
        );
        expect(
          ToleranceCalculator.classifyState(59.9),
          ToleranceSystemState.moderateStrain,
        );
      });

      test('classifies high strain state (60-80%)', () {
        expect(
          ToleranceCalculator.classifyState(60),
          ToleranceSystemState.highStrain,
        );
        expect(
          ToleranceCalculator.classifyState(70),
          ToleranceSystemState.highStrain,
        );
        expect(
          ToleranceCalculator.classifyState(79.9),
          ToleranceSystemState.highStrain,
        );
      });

      test('classifies depleted state (80-100%)', () {
        expect(
          ToleranceCalculator.classifyState(80),
          ToleranceSystemState.depleted,
        );
        expect(
          ToleranceCalculator.classifyState(90),
          ToleranceSystemState.depleted,
        );
        expect(
          ToleranceCalculator.classifyState(100),
          ToleranceSystemState.depleted,
        );
      });
    });

    group('computeAllBucketStates', () {
      test('classifies each bucket independently', () {
        final states = ToleranceCalculator.computeAllBucketStates(
          tolerances: {
            'gaba': 0,
            'stimulant': 25,
            'opioid': 55,
            'nmda': 75,
            'cannabinoid': 95,
          },
        );

        expect(states['gaba'], ToleranceSystemState.recovered);
        expect(states['stimulant'], ToleranceSystemState.lightStress);
        expect(states['opioid'], ToleranceSystemState.moderateStrain);
        expect(states['nmda'], ToleranceSystemState.highStrain);
        expect(states['cannabinoid'], ToleranceSystemState.depleted);
      });
    });

    group('computeAllBucketTolerances', () {
      test('computes a simple single-event tolerance contribution', () {
        final now = DateTime.now();
        final useLogs = [
          UseLogEntry(substanceSlug: 'testdrug', timestamp: now, doseUnits: 10),
        ];

        final model = ToleranceModel(
          neuroBuckets: {'gaba': const NeuroBucket(name: 'gaba', weight: 1.0)},
          halfLifeHours: 6,
          toleranceDecayDays: 2,
          standardUnitMg: 10,
          potencyMultiplier: 1,
          durationMultiplier: 1,
          toleranceGainRate: 1,
          activeThreshold: 0.05,
        );

        final tolerances = ToleranceCalculator.computeAllBucketTolerances(
          useLogs: useLogs,
          toleranceModels: {'testdrug': model},
          debug: false,
        );

        // With dose==standardUnit and hoursSince==0 (inMinutes => 0), the
        // calculator's baseContribution is 0.08, so percent should be 8.0.
        expect(tolerances['gaba'], closeTo(8.0, 1e-6));

        // Ensure all canonical buckets exist.
        for (final bucket in kToleranceBuckets) {
          expect(tolerances.containsKey(bucket), isTrue);
        }
      });

      test('skips substances without a tolerance model', () {
        final tolerances = ToleranceCalculator.computeAllBucketTolerances(
          useLogs: [
            UseLogEntry(
              substanceSlug: 'unknown',
              timestamp: DateTime.now(),
              doseUnits: 10,
            ),
          ],
          toleranceModels: const {},
          debug: false,
        );

        for (final bucket in kToleranceBuckets) {
          expect(tolerances[bucket], 0.0);
        }
      });
    });

    group('computeToleranceFull', () {
      test('returns bucket percents, score, and baseline estimates', () {
        final now = DateTime.now();
        final useLogs = [
          UseLogEntry(substanceSlug: 'testdrug', timestamp: now, doseUnits: 10),
          UseLogEntry(substanceSlug: 'testdrug', timestamp: now, doseUnits: 10),
        ];

        final model = ToleranceModel(
          neuroBuckets: {
            'gaba': const NeuroBucket(name: 'gaba', weight: 1.0),
            'stimulant': const NeuroBucket(name: 'stimulant', weight: 0.5),
          },
          halfLifeHours: 6,
          toleranceDecayDays: 2,
          standardUnitMg: 10,
          potencyMultiplier: 1,
          durationMultiplier: 1,
          toleranceGainRate: 1,
          activeThreshold: 0.05,
        );

        final result = ToleranceCalculatorFull.computeToleranceFull(
          useLogs: useLogs,
          toleranceModels: {'testdrug': model},
          debug: false,
        );

        expect(result.bucketPercents['gaba'], closeTo(16.0, 1e-6));
        expect(result.bucketPercents['stimulant'], closeTo(8.0, 1e-6));
        expect(result.toleranceScore, closeTo(16.0, 1e-6));
        expect(result.daysUntilBaseline['gaba'], greaterThan(0));
        expect(result.overallDaysUntilBaseline, greaterThan(0));
      });

      test('produces 0 load when halfLifeHours <= 0', () {
        final model = ToleranceModel(
          neuroBuckets: {'gaba': const NeuroBucket(name: 'gaba', weight: 1.0)},
          halfLifeHours: 0,
          toleranceDecayDays: 2,
          standardUnitMg: 10,
          potencyMultiplier: 1,
          durationMultiplier: 1,
          toleranceGainRate: 1,
          activeThreshold: 0.05,
        );

        final result = ToleranceCalculatorFull.computeToleranceFull(
          useLogs: [
            UseLogEntry(
              substanceSlug: 'testdrug',
              timestamp: DateTime.now(),
              doseUnits: 10,
            ),
          ],
          toleranceModels: {'testdrug': model},
          debug: false,
        );

        expect(result.bucketPercents['gaba'], 0.0);
        expect(result.toleranceScore, 0.0);
      });
    });

    // NOTE: Other tolerance calculation tests are disabled because they test
    // old static methods that were part of the legacy tolerance engine.
    // The new unified tolerance engine uses ToleranceCalculatorFull.computeToleranceFull
    // which returns a ToleranceResult with all calculated values.
    // Those methods should be tested via integration tests of computeToleranceFull.
  });
}
