// Integration test for tolerance feature navigation and data display
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_logic.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';
import 'package:mobile_drug_use_app/common/logging/app_log.dart';
import 'tolerance_test_config.dart';

void main() {
  group('Tolerance Page Integration Tests', () {
    test('Tolerance calculation produces non-zero GABA bucket for alcohol', () {
      // Setup: Create mock data
      final mockModels = {
        'alcohol': const ToleranceModel(
          notes: 'Test alcohol model',
          neuroBuckets: {
            'gaba': NeuroBucket(
              name: 'gaba',
              weight: 0.9,
              toleranceType: 'gaba',
            ),
            'nmda': NeuroBucket(
              name: 'nmda',
              weight: 0.6,
              toleranceType: 'nmda',
            ),
          },
          halfLifeHours: 8.0,
          toleranceDecayDays: 3.0,
          standardUnitMg: 10.0,
          potencyMultiplier: 1.0,
          durationMultiplier: 1.0,
          toleranceGainRate: 1.0,
          activeThreshold: 0.05,
        ),
      };

      final mockUseLogs = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          doseUnits: 3.0, // 3 units of alcohol
        ),
      ];

      // Import the logic to test directly
      final result = _simulateToleranceCalculation(
        models: mockModels,
        useLogs: mockUseLogs,
      );

      // Verify GABA bucket is above threshold
      final gabaBucket = result.bucketPercents[ToleranceTestConfig.testBucket];

      AppLog.i('[Test] GABA bucket result: $gabaBucket%');

      expect(
        gabaBucket,
        isNotNull,
        reason: 'GABA bucket should be present in results',
      );
      expect(
        gabaBucket! > ToleranceTestConfig.minBucketPercent,
        isTrue,
        reason:
            'GABA bucket should be above ${ToleranceTestConfig.minBucketPercent}%, got $gabaBucket%',
      );

      // Additional verification: Check that calculation used alcohol model
      // substanceContributions is structured as: [bucket][substance] = contribution%
      expect(
        result.substanceContributions.containsKey('gaba'),
        isTrue,
        reason: 'GABA bucket should have contributions',
      );

      final gabaContributions = result.substanceContributions['gaba'];
      expect(
        gabaContributions?['alcohol'],
        greaterThan(0.0),
        reason: 'Alcohol should contribute to GABA bucket',
      );
    });

    test('Multiple substances contribute correctly to buckets', () {
      final mockModels = {
        'alcohol': const ToleranceModel(
          notes: 'Test alcohol',
          neuroBuckets: {
            'gaba': NeuroBucket(
              name: 'gaba',
              weight: 0.9,
              toleranceType: 'gaba',
            ),
          },
          halfLifeHours: 8.0,
          toleranceDecayDays: 3.0,
        ),
        'mdma': const ToleranceModel(
          notes: 'Test MDMA',
          neuroBuckets: {
            'serotonin_release': NeuroBucket(
              name: 'serotonin_release',
              weight: 1.0,
              toleranceType: 'serotonin_release',
            ),
            'stimulant': NeuroBucket(
              name: 'stimulant',
              weight: 0.35,
              toleranceType: 'stimulant',
            ),
          },
          halfLifeHours: 9.0,
          toleranceDecayDays: 30.0,
        ),
      };

      final mockUseLogs = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          doseUnits: 2.0,
        ),
        UseLogEntry(
          substanceSlug: 'mdma',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          doseUnits: 1.0,
        ),
      ];

      final result = _simulateToleranceCalculation(
        models: mockModels,
        useLogs: mockUseLogs,
      );

      // Verify multiple buckets are populated
      expect(result.bucketPercents['gaba'], greaterThan(0.0));
      expect(result.bucketPercents['serotonin_release'], greaterThan(0.0));
      expect(result.bucketPercents['stimulant'], greaterThan(0.0));

      AppLog.i('[Test] Multi-substance results: ${result.bucketPercents}');
    });

    test('Empty use logs produce zero tolerance', () {
      final mockModels = {
        'alcohol': const ToleranceModel(
          notes: 'Test',
          neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
          halfLifeHours: 8.0,
        ),
      };

      final result = _simulateToleranceCalculation(
        models: mockModels,
        useLogs: [],
      );

      // All buckets should be 0%
      result.bucketPercents.forEach((bucket, percent) {
        expect(
          percent,
          equals(0.0),
          reason: '$bucket should be 0% with no use logs',
        );
      });
    });

    test('Decay calculation reduces tolerance over time', () {
      final model = {
        'alcohol': const ToleranceModel(
          notes: 'Test',
          neuroBuckets: {'gaba': NeuroBucket(name: 'gaba', weight: 0.9)},
          halfLifeHours: 4.0, // 4-hour half-life
        ),
      };

      // Recent use
      final recentLog = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          doseUnits: 3.0,
        ),
      ];

      // Old use (3 half-lives ago = 12 hours)
      final oldLog = [
        UseLogEntry(
          substanceSlug: 'alcohol',
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          doseUnits: 3.0,
        ),
      ];

      final recentResult = _simulateToleranceCalculation(
        models: model,
        useLogs: recentLog,
      );

      final oldResult = _simulateToleranceCalculation(
        models: model,
        useLogs: oldLog,
      );

      final recentGaba = recentResult.bucketPercents['gaba'] ?? 0.0;
      final oldGaba = oldResult.bucketPercents['gaba'] ?? 0.0;

      AppLog.i('[Test] Recent GABA: $recentGaba%, Old GABA: $oldGaba%');

      expect(
        recentGaba > oldGaba,
        isTrue,
        reason: 'Recent use should have higher tolerance than old use',
      );
    });
  });
}

/// Helper to simulate tolerance calculation without widget tree
ToleranceResult _simulateToleranceCalculation({
  required Map<String, ToleranceModel> models,
  required List<UseLogEntry> useLogs,
}) {
  // Use the actual ToleranceLogic class
  return ToleranceLogic.computeTolerance(
    toleranceModels: models,
    useLogs: useLogs,
  );
}
