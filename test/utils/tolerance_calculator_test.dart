import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/utils/tolerance_calculator.dart';
import 'package:mobile_drug_use_app/models/tolerance_model.dart';

void main() {
  group('ToleranceCalculator', () {
    group('classifySystemState', () {
      test('classifies recovered state (0-20%)', () {
        expect(ToleranceCalculator.classifySystemState(0), ToleranceSystemState.recovered);
        expect(ToleranceCalculator.classifySystemState(10), ToleranceSystemState.recovered);
        expect(ToleranceCalculator.classifySystemState(19.9), ToleranceSystemState.recovered);
      });

      test('classifies light stress state (20-40%)', () {
        expect(ToleranceCalculator.classifySystemState(20), ToleranceSystemState.lightStress);
        expect(ToleranceCalculator.classifySystemState(30), ToleranceSystemState.lightStress);
        expect(ToleranceCalculator.classifySystemState(39.9), ToleranceSystemState.lightStress);
      });

      test('classifies moderate strain state (40-60%)', () {
        expect(ToleranceCalculator.classifySystemState(40), ToleranceSystemState.moderateStrain);
        expect(ToleranceCalculator.classifySystemState(50), ToleranceSystemState.moderateStrain);
        expect(ToleranceCalculator.classifySystemState(59.9), ToleranceSystemState.moderateStrain);
      });

      test('classifies high strain state (60-80%)', () {
        expect(ToleranceCalculator.classifySystemState(60), ToleranceSystemState.highStrain);
        expect(ToleranceCalculator.classifySystemState(70), ToleranceSystemState.highStrain);
        expect(ToleranceCalculator.classifySystemState(79.9), ToleranceSystemState.highStrain);
      });

      test('classifies depleted state (80-100%)', () {
        expect(ToleranceCalculator.classifySystemState(80), ToleranceSystemState.depleted);
        expect(ToleranceCalculator.classifySystemState(90), ToleranceSystemState.depleted);
        expect(ToleranceCalculator.classifySystemState(100), ToleranceSystemState.depleted);
      });
    });

    group('loadToPercent', () {
      test('returns 0 for zero load', () {
        expect(ToleranceCalculator.loadToPercent(0), 0.0);
      });

      test('returns 0 for negative load', () {
        expect(ToleranceCalculator.loadToPercent(-10), 0.0);
      });

      test('returns increasing percentages for increasing loads', () {
        final load1 = ToleranceCalculator.loadToPercent(10);
        final load2 = ToleranceCalculator.loadToPercent(50);
        final load3 = ToleranceCalculator.loadToPercent(100);
        
        expect(load1, greaterThan(0));
        expect(load2, greaterThan(load1));
        expect(load3, greaterThan(load2));
      });

      test('clamps result to 100%', () {
        final result = ToleranceCalculator.loadToPercent(10000);
        expect(result, lessThanOrEqualTo(100.0));
      });
    });

    group('computeAllBucketStates', () {
      test('computes states for all tolerance values', () {
        final tolerances = {
          'gaba': 15.0,
          'stimulant': 35.0,
          'serotonin': 55.0,
          'opioid': 75.0,
          'nmda': 95.0,
          'cannabinoid': 5.0,
        };

        final states = ToleranceCalculator.computeAllBucketStates(
          tolerances: tolerances,
        );

        expect(states['gaba'], ToleranceSystemState.recovered);
        expect(states['stimulant'], ToleranceSystemState.lightStress);
        expect(states['serotonin'], ToleranceSystemState.moderateStrain);
        expect(states['opioid'], ToleranceSystemState.highStrain);
        expect(states['nmda'], ToleranceSystemState.depleted);
        expect(states['cannabinoid'], ToleranceSystemState.recovered);
      });
    });

    group('effectivePlasmaLevel', () {
      test('returns full dose at time zero', () {
        final now = DateTime.now();
        final level = ToleranceCalculator.effectivePlasmaLevel(
          useTime: now,
          currentTime: now,
          halfLifeHours: 5.0,
          initialDose: 100.0,
        );
        
        expect(level, closeTo(100.0, 0.01));
      });

      test('returns approximately half after one half-life', () {
        final useTime = DateTime.now().subtract(const Duration(hours: 5));
        final currentTime = DateTime.now();
        
        final level = ToleranceCalculator.effectivePlasmaLevel(
          useTime: useTime,
          currentTime: currentTime,
          halfLifeHours: 5.0,
          initialDose: 100.0,
        );
        
        expect(level, closeTo(50.0, 5.0));
      });

      test('returns 0 for negative time', () {
        final futureTime = DateTime.now().add(const Duration(hours: 5));
        final now = DateTime.now();
        
        final level = ToleranceCalculator.effectivePlasmaLevel(
          useTime: futureTime,
          currentTime: now,
          halfLifeHours: 5.0,
          initialDose: 100.0,
        );
        
        expect(level, 0.0);
      });

      test('returns 0 for zero half-life', () {
        final now = DateTime.now();
        
        final level = ToleranceCalculator.effectivePlasmaLevel(
          useTime: now.subtract(const Duration(hours: 5)),
          currentTime: now,
          halfLifeHours: 0.0,
          initialDose: 100.0,
        );
        
        expect(level, 0.0);
      });
    });

    group('toleranceScore', () {
      test('returns 0 for empty use events', () {
        final score = ToleranceCalculator.toleranceScore(
          useEvents: [],
          halfLifeHours: 5.0,
          currentTime: DateTime.now(),
        );
        
        expect(score, 0.0);
      });

      test('returns score for single use event', () {
        final now = DateTime.now();
        final events = [
          UseEvent(
            timestamp: now.subtract(const Duration(hours: 2)),
            dose: 100.0,
            substanceName: 'caffeine',
          ),
        ];
        
        final score = ToleranceCalculator.toleranceScore(
          useEvents: events,
          halfLifeHours: 5.0,
          currentTime: now,
        );
        
        expect(score, greaterThan(0));
        expect(score, lessThanOrEqualTo(100));
      });

      test('returns higher score for multiple recent uses', () {
        final now = DateTime.now();
        final singleUse = [
          UseEvent(
            timestamp: now.subtract(const Duration(hours: 2)),
            dose: 100.0,
            substanceName: 'caffeine',
          ),
        ];
        
        final multipleUses = [
          UseEvent(
            timestamp: now.subtract(const Duration(hours: 1)),
            dose: 100.0,
            substanceName: 'caffeine',
          ),
          UseEvent(
            timestamp: now.subtract(const Duration(hours: 2)),
            dose: 100.0,
            substanceName: 'caffeine',
          ),
          UseEvent(
            timestamp: now.subtract(const Duration(hours: 3)),
            dose: 100.0,
            substanceName: 'caffeine',
          ),
        ];
        
        final scoreSingle = ToleranceCalculator.toleranceScore(
          useEvents: singleUse,
          halfLifeHours: 5.0,
          currentTime: now,
        );
        
        final scoreMultiple = ToleranceCalculator.toleranceScore(
          useEvents: multipleUses,
          halfLifeHours: 5.0,
          currentTime: now,
        );
        
        expect(scoreMultiple, greaterThan(scoreSingle));
      });
    });

    group('decayFunction', () {
      test('returns 1.0 at time zero', () {
        final decay = ToleranceCalculator.decayFunction(
          daysSinceLastUse: 0.0,
          toleranceDecayDays: 14.0,
        );
        
        expect(decay, 1.0);
      });

      test('returns value between 0 and 1 for positive days', () {
        final decay = ToleranceCalculator.decayFunction(
          daysSinceLastUse: 7.0,
          toleranceDecayDays: 14.0,
        );
        
        expect(decay, greaterThan(0.0));
        expect(decay, lessThan(1.0));
      });

      test('approaches 0 for many days', () {
        final decay = ToleranceCalculator.decayFunction(
          daysSinceLastUse: 100.0,
          toleranceDecayDays: 14.0,
        );
        
        expect(decay, lessThan(0.1));
      });

      test('returns 0 for zero tolerance decay days', () {
        final decay = ToleranceCalculator.decayFunction(
          daysSinceLastUse: 7.0,
          toleranceDecayDays: 0.0,
        );
        
        expect(decay, 0.0);
      });
    });

    group('daysUntilBaseline', () {
      test('returns 0 when already at baseline', () {
        final days = ToleranceCalculator.daysUntilBaseline(
          currentTolerance: 4.0,
          toleranceDecayDays: 14.0,
        );
        
        expect(days, 0.0);
      });

      test('returns positive days for elevated tolerance', () {
        final days = ToleranceCalculator.daysUntilBaseline(
          currentTolerance: 50.0,
          toleranceDecayDays: 14.0,
        );
        
        expect(days, greaterThan(0.0));
      });

      test('returns higher days for higher tolerance', () {
        final days1 = ToleranceCalculator.daysUntilBaseline(
          currentTolerance: 30.0,
          toleranceDecayDays: 14.0,
        );
        
        final days2 = ToleranceCalculator.daysUntilBaseline(
          currentTolerance: 80.0,
          toleranceDecayDays: 14.0,
        );
        
        expect(days2, greaterThan(days1));
      });

      test('caps result at 365 days', () {
        final days = ToleranceCalculator.daysUntilBaseline(
          currentTolerance: 99.9,
          toleranceDecayDays: 100.0,
        );
        
        expect(days, lessThanOrEqualTo(365.0));
      });
    });

    group('neuroBucketContribution', () {
      test('calculates contribution correctly', () {
        final contribution = ToleranceCalculator.neuroBucketContribution(
          bucketWeight: 0.5,
          toleranceScore: 80.0,
        );
        
        expect(contribution, 40.0);
      });

      test('clamps to 100', () {
        final contribution = ToleranceCalculator.neuroBucketContribution(
          bucketWeight: 2.0,
          toleranceScore: 80.0,
        );
        
        expect(contribution, 100.0);
      });
    });
  });
}
