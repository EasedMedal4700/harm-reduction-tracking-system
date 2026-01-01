// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Comprehensive tests for tolerance models

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';

void main() {
  group('Tolerance Models - NeuroBucket', () {
    test('creates NeuroBucket with all fields', () {
      const bucket = NeuroBucket(
        name: 'gaba',
        weight: 0.9,
        toleranceType: 'gaba',
      );

      expect(bucket.name, 'gaba');
      expect(bucket.weight, 0.9);
      expect(bucket.toleranceType, 'gaba');
    });

    test('creates NeuroBucket with minimal fields', () {
      const bucket = NeuroBucket(name: 'stimulant', weight: 1.0);

      expect(bucket.name, 'stimulant');
      expect(bucket.weight, 1.0);
      expect(bucket.toleranceType, isNull);
    });

    test('supports equality comparison', () {
      const bucket1 = NeuroBucket(name: 'gaba', weight: 0.9);
      const bucket2 = NeuroBucket(name: 'gaba', weight: 0.9);
      const bucket3 = NeuroBucket(name: 'gaba', weight: 0.8);

      expect(bucket1, equals(bucket2));
      expect(bucket1, isNot(equals(bucket3)));
    });
  });

  group('Tolerance Models - UseLogEntry', () {
    test('creates UseLogEntry with required fields', () {
      final timestamp = DateTime.now();
      final entry = UseLogEntry(
        substanceSlug: 'caffeine',
        timestamp: timestamp,
        doseUnits: 100.0,
      );

      expect(entry.substanceSlug, 'caffeine');
      expect(entry.timestamp, timestamp);
      expect(entry.doseUnits, 100.0);
    });

    test('is immutable and supports equality', () {
      final timestamp = DateTime.now();
      final entry1 = UseLogEntry(
        substanceSlug: 'caffeine',
        timestamp: timestamp,
        doseUnits: 100.0,
      );
      final entry2 = UseLogEntry(
        substanceSlug: 'caffeine',
        timestamp: timestamp,
        doseUnits: 100.0,
      );
      final entry3 = UseLogEntry(
        substanceSlug: 'caffeine',
        timestamp: timestamp,
        doseUnits: 200.0,
      );

      expect(entry1, equals(entry2));
      expect(entry1, isNot(equals(entry3)));
    });

    test('handles zero dose units', () {
      final entry = UseLogEntry(
        substanceSlug: 'test',
        timestamp: DateTime.now(),
        doseUnits: 0.0,
      );

      expect(entry.doseUnits, 0.0);
    });

    test('handles very large dose units', () {
      final entry = UseLogEntry(
        substanceSlug: 'test',
        timestamp: DateTime.now(),
        doseUnits: 999999.99,
      );

      expect(entry.doseUnits, 999999.99);
    });
  });

  group('Tolerance Models - ToleranceModel', () {
    test('creates ToleranceModel with all fields', () {
      const model = ToleranceModel(
        notes: 'Test model',
        neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
        halfLifeHours: 8.0,
        toleranceDecayDays: 3.0,
        standardUnitMg: 10.0,
        potencyMultiplier: 1.5,
        durationMultiplier: 1.2,
        toleranceGainRate: 0.8,
        activeThreshold: 0.05,
      );

      expect(model.notes, 'Test model');
      expect(model.neuroBuckets.length, 1);
      expect(model.halfLifeHours, 8.0);
      expect(model.toleranceDecayDays, 3.0);
      expect(model.standardUnitMg, 10.0);
      expect(model.potencyMultiplier, 1.5);
      expect(model.durationMultiplier, 1.2);
      expect(model.toleranceGainRate, 0.8);
      expect(model.activeThreshold, 0.05);
    });

    test('creates ToleranceModel with default values', () {
      const model = ToleranceModel(
        neuroBuckets: {
          'stimulant': NeuroBucket(name: 'stimulant', weight: 1.0),
        },
        halfLifeHours: 5.0,
      );

      expect(model.notes, '');
      expect(model.toleranceDecayDays, 2.0);
      expect(model.standardUnitMg, 10.0);
      expect(model.potencyMultiplier, 1.0);
      expect(model.durationMultiplier, 1.0);
      expect(model.toleranceGainRate, 1.0);
      expect(model.activeThreshold, 0.05);
    });

    test('supports multiple neuro buckets', () {
      const model = ToleranceModel(
        neuroBuckets: {
          'gaba': NeuroBucket(name: 'gaba', weight: 0.9),
          'nmda': NeuroBucket(name: 'nmda', weight: 0.6),
          'opioid': NeuroBucket(name: 'opioid', weight: 0.3),
        },
        halfLifeHours: 10.0,
      );

      expect(model.neuroBuckets.length, 3);
      expect(model.neuroBuckets.containsKey('gaba'), isTrue);
      expect(model.neuroBuckets.containsKey('nmda'), isTrue);
      expect(model.neuroBuckets.containsKey('opioid'), isTrue);
    });

    test('supports equality comparison', () {
      const model1 = ToleranceModel(
        neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
        halfLifeHours: 8.0,
      );

      const model2 = ToleranceModel(
        neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
        halfLifeHours: 8.0,
      );

      const model3 = ToleranceModel(
        neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
        halfLifeHours: 10.0,
      );

      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });
  });

  group('Tolerance Models - ToleranceResult', () {
    test('creates ToleranceResult with all fields', () {
      const result = ToleranceResult(
        bucketPercents: {'gaba': 25.5, 'stimulant': 10.2},
        bucketRawLoads: {'gaba': 0.255, 'stimulant': 0.102},
        toleranceScore: 25.5,
        daysUntilBaseline: {'gaba': 2.5, 'stimulant': 1.5},
        overallDaysUntilBaseline: 2.5,
        substanceContributions: {
          'gaba': {'alcohol': 25.5},
          'stimulant': {'caffeine': 10.2},
        },
        substanceActiveStates: {'alcohol': true, 'caffeine': true},
      );

      expect(result.bucketPercents['gaba'], 25.5);
      expect(result.toleranceScore, 25.5);
      expect(result.daysUntilBaseline['gaba'], 2.5);
      expect(result.overallDaysUntilBaseline, 2.5);
      expect(result.substanceContributions['gaba']?['alcohol'], 25.5);
      expect(result.substanceActiveStates['alcohol'], isTrue);
    });

    test('creates ToleranceResult with default values', () {
      const result = ToleranceResult(
        bucketPercents: {},
        bucketRawLoads: {},
        toleranceScore: 0.0,
        daysUntilBaseline: {},
        overallDaysUntilBaseline: 0.0,
      );

      expect(result.bucketPercents.isEmpty, isTrue);
      expect(result.bucketRawLoads.isEmpty, isTrue);
      expect(result.toleranceScore, 0.0);
      expect(result.daysUntilBaseline.isEmpty, isTrue);
      expect(result.overallDaysUntilBaseline, 0.0);
      expect(result.substanceContributions.isEmpty, isTrue);
      expect(result.substanceActiveStates.isEmpty, isTrue);
    });
  });

  group('Tolerance Models - ToleranceSystemState', () {
    test('has correct display names', () {
      expect(ToleranceSystemState.recovered.displayName, 'Recovered');
      expect(ToleranceSystemState.lightStress.displayName, 'Light Stress');
      expect(
        ToleranceSystemState.moderateStrain.displayName,
        'Moderate Strain',
      );
      expect(ToleranceSystemState.highStrain.displayName, 'High Strain');
      expect(ToleranceSystemState.depleted.displayName, 'Depleted');
    });

    test('has all expected states', () {
      expect(ToleranceSystemState.values.length, 5);
    });
  });

  group('Tolerance Models - kToleranceBuckets', () {
    test('contains all expected bucket names', () {
      expect(kToleranceBuckets.contains('gaba'), isTrue);
      expect(kToleranceBuckets.contains('stimulant'), isTrue);
      expect(kToleranceBuckets.contains('serotonin_release'), isTrue);
      expect(kToleranceBuckets.contains('serotonin_psychedelic'), isTrue);
      expect(kToleranceBuckets.contains('opioid'), isTrue);
      expect(kToleranceBuckets.contains('nmda'), isTrue);
      expect(kToleranceBuckets.contains('cannabinoid'), isTrue);
    });

    test('has exactly 7 bucket types', () {
      expect(kToleranceBuckets.length, 7);
    });

    test('bucket names are lowercase', () {
      for (final bucket in kToleranceBuckets) {
        expect(bucket, equals(bucket.toLowerCase()));
      }
    });
  });
}
