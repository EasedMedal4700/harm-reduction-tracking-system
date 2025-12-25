// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Pure logic for tolerance calculation

import 'dart:math' as math;
import '../../../common/logging/app_log.dart';
import '../models/tolerance_models.dart';

class ToleranceLogic {
  static const double _kBaseScaling = 0.08;

  static double loadToPercent(double load) {
    if (load.isNaN || !load.isFinite || load <= 0) return 0.0;
    final pct = load * 100.0;
    return pct.clamp(0.0, 100.0);
  }

  static ToleranceResult computeTolerance({
    required List<UseLogEntry> useLogs,
    required Map<String, ToleranceModel> toleranceModels,
  }) {
    AppLog.d(
      '[ToleranceLogic] Computing tolerance with ${toleranceModels.length} models and ${useLogs.length} use logs',
    );

    // print('\n=== TOLERANCE COMPUTATION START ===');
    // print('Available models (${toleranceModels.length}):');
    // toleranceModels.keys.forEach((slug) {
    //   print('  ✓ "$slug"');
    // });
    // print('\nSubstances in use logs (${useLogs.length} total):');
    // final uniqueSubstances = useLogs.map((e) => e.substanceSlug).toSet();
    // uniqueSubstances.forEach((slug) {
    //   final hasModel = toleranceModels.containsKey(slug);
    //   print(
    //     '  ${hasModel ? "✓" : "✗"} "$slug" ${hasModel ? "(has model)" : "(NO MODEL FOUND!)"}',
    //   );
    // });
    // print('===================================\n');

    final now = DateTime.now();
    final rawLoads = <String, double>{};
    final logsBySubstance = <String, List<UseLogEntry>>{};

    // Group logs
    for (final log in useLogs) {
      logsBySubstance.putIfAbsent(log.substanceSlug, () => []).add(log);
    }
    AppLog.d(
      '[ToleranceLogic] Grouped logs into ${logsBySubstance.length} substances',
    );

    // Compute loads per substance
    for (final entry in logsBySubstance.entries) {
      final slug = entry.key;
      final model = toleranceModels[slug];
      if (model == null) {
        AppLog.w(
          '[ToleranceLogic] No tolerance model found for substance: $slug',
        );
        // print('>>> MODEL LOOKUP FAILED for "$slug"');
        // print('    Available keys: ${toleranceModels.keys.join(", ")}');
        // print('    Checking case-sensitivity...');
        // toleranceModels.keys.forEach((key) {
        //   if (key.toLowerCase() == slug.toLowerCase()) {
        //     print('    ⚠️  CASE MISMATCH! DB has "$key", use log has "$slug"');
        //   }
        // });
        continue;
      }

      AppLog.d(
        '[ToleranceLogic] Processing substance: $slug with ${entry.value.length} logs, ${model.neuroBuckets.length} buckets',
      );
      final bucketLoads = _computeRawLoadsForSubstance(
        slug: slug,
        logs: entry.value,
        model: model,
        now: now,
      );

      bucketLoads.forEach((bucket, value) {
        rawLoads[bucket] = (rawLoads[bucket] ?? 0.0) + value;
        AppLog.d(
          '[ToleranceLogic]   Bucket $bucket: adding ${value.toStringAsFixed(4)}, total now: ${rawLoads[bucket]!.toStringAsFixed(4)}',
        );
      });
    }

    // Ensure all buckets exist
    for (final bucket in kToleranceBuckets) {
      rawLoads.putIfAbsent(bucket, () => 0.0);
    }

    // Convert to percents
    final bucketPercents = {
      for (final entry in rawLoads.entries)
        entry.key: loadToPercent(entry.value),
    };

    AppLog.d('[ToleranceLogic] Final bucket percentages:');
    bucketPercents.forEach((bucket, percent) {
      AppLog.d(
        '[ToleranceLogic]   $bucket: ${percent.toStringAsFixed(2)}% (raw: ${rawLoads[bucket]!.toStringAsFixed(4)})',
      );
    });

    // Tolerance Score (Max bucket)
    final toleranceScore = bucketPercents.values.fold<double>(
      0.0,
      (a, b) => math.max(a, b),
    );

    AppLog.i(
      '[ToleranceLogic] Overall tolerance score: ${toleranceScore.toStringAsFixed(2)}%',
    );

    // print('\n=== FINAL TOLERANCE RESULTS ===');
    // print('Tolerance Score: ${toleranceScore.toStringAsFixed(1)}%');
    // print('Buckets with non-zero tolerance:');
    // bucketPercents.forEach((bucket, percent) {
    //   if (percent > 0.1) {
    //     print(
    //       '  - $bucket: ${percent.toStringAsFixed(1)}% (raw: ${rawLoads[bucket]?.toStringAsFixed(2)})',
    //     );
    //   }
    // });
    // if (bucketPercents.values.every((p) => p <= 0.1)) {
    //   print('  (No buckets above 0.1%)');
    // }
    // print('================================\n');

    // Days until baseline
    final daysUntilBaseline = <String, double>{};
    for (final bucket in rawLoads.keys) {
      final load = rawLoads[bucket] ?? 0.0;
      if (load <= 0.0001) {
        daysUntilBaseline[bucket] = 0.0;
        continue;
      }

      double? effectiveDecayDays;
      for (final entry in logsBySubstance.entries) {
        final slug = entry.key;
        final model = toleranceModels[slug];
        if (model == null) continue;
        if (!model.neuroBuckets.containsKey(bucket)) continue;

        effectiveDecayDays = math.max(
          effectiveDecayDays ?? 0.0,
          model.toleranceDecayDays,
        );
      }

      if (effectiveDecayDays == null || effectiveDecayDays <= 0) {
        daysUntilBaseline[bucket] = 0.0;
        continue;
      }

      final threshold = 0.01;
      final t = -effectiveDecayDays * math.log(threshold / load);
      daysUntilBaseline[bucket] = t.isFinite ? t : 0.0;
    }

    // Overall days
    final overallDays = daysUntilBaseline.values.fold<double>(
      0.0,
      (a, b) => math.max(a, b),
    );

    // Compute contributions
    final substanceContributions = <String, Map<String, double>>{};
    final substanceActiveStates = <String, bool>{};

    for (final entry in logsBySubstance.entries) {
      final slug = entry.key;
      final model = toleranceModels[slug];
      if (model == null) continue;

      // Compute for single substance
      final singleSubstanceLoads = _computeRawLoadsForSubstance(
        slug: slug,
        logs: entry.value,
        model: model,
        now: now,
      );

      singleSubstanceLoads.forEach((bucket, rawLoad) {
        final pct = loadToPercent(rawLoad);
        if (pct > 0.1) {
          substanceContributions.putIfAbsent(bucket, () => {});
          substanceContributions[bucket]![slug] = pct;
          if (rawLoad > 0.0) {
            substanceActiveStates[slug] = true;
          }
        }
      });
    }

    return ToleranceResult(
      bucketPercents: bucketPercents,
      bucketRawLoads: rawLoads,
      toleranceScore: toleranceScore,
      daysUntilBaseline: daysUntilBaseline,
      overallDaysUntilBaseline: overallDays,
      substanceContributions: substanceContributions,
      substanceActiveStates: substanceActiveStates,
    );
  }

  static Map<String, double> _computeRawLoadsForSubstance({
    required String slug,
    required List<UseLogEntry> logs,
    required ToleranceModel model,
    required DateTime now,
  }) {
    // print('\n>>> Computing raw loads for "$slug" (${logs.length} logs)');

    final result = <String, double>{};
    if (model.neuroBuckets.isEmpty) {
      // print('    No neuro buckets!');
      return result;
    }

    final halfLife = model.halfLifeHours;
    final decayDays = model.toleranceDecayDays;
    final standardUnit = model.standardUnitMg > 0 ? model.standardUnitMg : 10.0;
    final potency = model.potencyMultiplier;
    final gain = model.toleranceGainRate;
    final durationMult = model.durationMultiplier;
    final activeThreshold =
        (model.activeThreshold <= 0 || model.activeThreshold >= 1)
        ? 0.05
        : model.activeThreshold;

    final activeWindowHours = (halfLife > 0)
        ? -halfLife * math.log(activeThreshold)
        : 0.0;

    // print(
    //   '    Model params: halfLife=${halfLife}h, decayDays=$decayDays, standardUnit=$standardUnit, potency=$potency, gain=$gain',
    // );
    // print(
    //   '    Active window: ${activeWindowHours.toStringAsFixed(1)} hours, threshold=$activeThreshold',
    // );

    for (final bucketEntry in model.neuroBuckets.entries) {
      final bucketName = bucketEntry.key;
      final bucket = bucketEntry.value;
      double rawTotal = 0.0;

      // print('    Processing bucket: $bucketName (weight=${bucket.weight})');
      int logCount = 0;

      for (final log in logs) {
        final hoursSince = now.difference(log.timestamp).inMinutes / 60.0;
        if (hoursSince < 0) continue;

        final activeLevel = (halfLife > 0)
            ? math.exp(-hoursSince / halfLife)
            : 0.0;

        final doseNorm = log.doseUnits / standardUnit;
        final baseContribution =
            doseNorm *
            bucket.weight *
            potency *
            gain *
            _kBaseScaling *
            durationMult;

        double decayFactor;
        if (halfLife <= 0 || decayDays <= 0) {
          decayFactor = 0.0;
        } else if (activeLevel >= activeThreshold) {
          decayFactor = 1.0;
        } else {
          final hoursPastActive = math.max(0.0, hoursSince - activeWindowHours);
          final daysPastActive = hoursPastActive / 24.0;
          decayFactor = math.exp(-daysPastActive / decayDays);
        }

        final eventTolNow = baseContribution * decayFactor;
        rawTotal += eventTolNow;

        // if (logCount < 3) {
        //   print(
        //     '      Log ${logCount + 1}: dose=${log.doseUnits}, ${hoursSince.toStringAsFixed(1)}h ago, activeLevel=${activeLevel.toStringAsFixed(3)}, decayFactor=${decayFactor.toStringAsFixed(3)}, contribution=${eventTolNow.toStringAsFixed(4)}',
        //   );
        // }
        // logCount++;
      }

      // print(
      //   '    Bucket $bucketName total: ${rawTotal.toStringAsFixed(4)} (from $logCount logs)',
      // );

      if (rawTotal > 0) {
        result[bucketName] = rawTotal;
      }
    }
    return result;
  }

  static ToleranceSystemState classifyState(double pct) {
    if (pct < 20.0) {
      return ToleranceSystemState.recovered;
    } else if (pct < 40.0) {
      return ToleranceSystemState.lightStress;
    } else if (pct < 60.0) {
      return ToleranceSystemState.moderateStrain;
    } else if (pct < 80.0) {
      return ToleranceSystemState.highStrain;
    } else {
      return ToleranceSystemState.depleted;
    }
  }
}
