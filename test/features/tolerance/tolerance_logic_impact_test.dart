import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_logic.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';

void main() {
  group('ToleranceLogic - Impact Calculation', () {
    test('calculates individual log impacts correctly', () {
      final now = DateTime.now();
      // Two logs: one recent (high impact), one old (low impact)
      final recentLog = UseLogEntry(
        substanceSlug: 'test_drug',
        timestamp: now.subtract(const Duration(hours: 1)),
        doseUnits: 100,
      );

      final oldLog = UseLogEntry(
        substanceSlug: 'test_drug',
        timestamp: now.subtract(const Duration(days: 5)),
        doseUnits: 100,
      );

      final logs = [recentLog, oldLog];

      final bucket = NeuroBucket(name: 'dopamine', weight: 1.0);
      final model = ToleranceModel(
        neuroBuckets: {'dopamine': bucket},
        halfLifeHours: 5.0,
        toleranceDecayDays: 7.0,
        standardUnitMg: 100.0,
        toleranceGainRate: 1.0,
        durationMultiplier: 1.0,
        activeThreshold: 0.1,
        potencyMultiplier: 1.0,
      );

      final models = {'test_drug': model};

      final result = ToleranceLogic.computeTolerance(
        useLogs: logs,
        toleranceModels: models,
      );

      // Verify log impacts
      expect(
        result.logImpacts.containsKey('dopamine'),
        isTrue,
        reason: 'Should have impacts for dopamine bucket',
      );
      final impacts = result.logImpacts['dopamine']!;

      // Recent log should have higher impact
      // Note: toIso8601String might differ in precision/timezone depending on env, so we match carefully or just rely on the logic being consistent.
      final recentKey = recentLog.timestamp.toIso8601String();
      final oldKey = oldLog.timestamp.toIso8601String();

      expect(impacts.containsKey(recentKey), isTrue);
      expect(impacts.containsKey(oldKey), isTrue);

      final recentImpact = impacts[recentKey]!;
      final oldImpact = impacts[oldKey]!;

      // Calculate expected roughly
      // Recent: ~1h hours ago. activeLevel ~ exp(-0.2) ~ 0.8. > threshold. decayFactor = 1.0.
      // Base contribution = 1(dose) * 1(weight) * 1(potency) * 1(gain) * 0.08(kBase) = 0.08
      // Load = 0.08. Pct = 8%

      // Old: 5 days = 120h. activeLevel ~ 0.
      // activeWindow w/ halflike 5 and threshold 0.1 (default activeThreshold logic)
      // activeWindow = -5 * ln(0.1) = -5 * -2.3 = 11.5 hours.
      // hoursPastActive = 120 - 11.5 = 108.5h. = 4.5 days.
      // decayDays = 7.
      // decayFactor = exp(-4.5/7) = exp(-0.64) ~ 0.52.
      // Load = 0.08 * 0.52 = 0.0416. Pct ~ 4.16%

      expect(recentImpact, greaterThan(oldImpact));
      expect(recentImpact, greaterThan(1.0)); // Should be > 1%

      // Verify relevant logs
      expect(result.relevantLogs.containsKey('dopamine'), isTrue);
      final relevantLogList = result.relevantLogs['dopamine']!;
      expect(relevantLogList.length, 2);
      expect(
        relevantLogList.any((l) => l.timestamp == recentLog.timestamp),
        isTrue,
      );
      expect(
        relevantLogList.any((l) => l.timestamp == oldLog.timestamp),
        isTrue,
      );
    });
  });
}
