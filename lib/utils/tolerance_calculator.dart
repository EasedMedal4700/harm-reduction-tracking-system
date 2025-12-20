import 'dart:math' as math;

import '../models/tolerance_model.dart';

/// Core math for tolerance calculation.
///
/// Everything that turns raw use logs + tolerance models into:
/// - bucket percentages (0–100%),
/// - system states,
/// - and debug output
/// lives in here.
class ToleranceCalculator {
  // Global scaling constant so we can tune the whole system in one place.
  // This is the old hard-coded 0.08, just made explicit.
  static const double _kBaseScaling = 0.08;

  /// Map a raw tolerance “load” value (dimensionless) to a 0–100% score.
  ///
  /// Your existing debug output shows 0.145 -> 14.5%, 0.1687 -> 16.9%, etc,
  /// so a simple linear 100× mapping (clamped) is exactly what you were doing.
  static double loadToPercent(double load) {
    if (load.isNaN || !load.isFinite || load <= 0) return 0.0;
    final pct = load * 100.0;
    return pct.clamp(0.0, 100.0);
  }

  /// Compute tolerance for all neuro buckets for a user.
  ///
  /// Returns a map like:
  /// {
  ///   'stimulant': 27.1,
  ///   'gaba':      14.5,
  ///   ...
  /// }
  static Map<String, double> computeAllBucketTolerances({
    required List<UseLogEntry> useLogs,
    required Map<String, ToleranceModel> toleranceModels,
    bool debug = false,
  }) {
    final now = DateTime.now();

    // Accumulate raw loads per bucket (not yet converted to %).
    final bucketRawLoads = <String, double>{};

    // Group logs per substance so debug output is nicer.
    final logsBySubstance = <String, List<UseLogEntry>>{};
    for (final log in useLogs) {
      logsBySubstance.putIfAbsent(log.substanceSlug, () => []).add(log);
    }

    if (debug) {
      // ignore: avoid_print
      print(
        '📊 Found ${toleranceModels.length} substances with tolerance models',
      );
      // ignore: avoid_print
      print(
        '📊 Found ${useLogs.length} use log entries (${useLogs.isEmpty ? 0 : 30} days)',
      );
      // ignore: avoid_print
      print('');
    }

    for (final entry in logsBySubstance.entries) {
      final slug = entry.key;
      final logs = entry.value
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      final model = toleranceModels[slug];
      if (model == null) {
        // Substance not configured for tolerance => skip.
        continue;
      }

      final perBucketLoads = _computeRawLoadsForSubstance(
        slug: slug,
        logs: logs,
        model: model,
        now: now,
        debug: debug,
      );

      // Add into global per-bucket totals.
      perBucketLoads.forEach((bucket, raw) {
        bucketRawLoads[bucket] = (bucketRawLoads[bucket] ?? 0.0) + raw;
      });
    }

    if (debug) {
      // ignore: avoid_print
      print('══════════════════════════════════════════════════════════');
      // ignore: avoid_print
      print('📈 FINAL BUCKET CONTRIBUTIONS:');
      for (final e in bucketRawLoads.entries) {
        final pct = loadToPercent(e.value);
        // ignore: avoid_print
        print(
          '  ${e.key}  ->  ${pct.toStringAsFixed(1)}%  (raw: ${e.value.toStringAsFixed(4)})',
        );
      }
      // ignore: avoid_print
      print('══════════════════════════════════════════════════════════');
      // ignore: avoid_print
      print('');
    }

    // Convert raw loads to percentages for the UI and state logic.
    final bucketPercents = <String, double>{};
    bucketRawLoads.forEach((bucket, raw) {
      bucketPercents[bucket] = loadToPercent(raw);
    });

    // Make sure all canonical buckets exist in the map.
    for (final bucket in kToleranceBuckets) {
      bucketPercents.putIfAbsent(bucket, () => 0.0);
    }

    return bucketPercents;
  }

  /// Compute raw tolerance loads for a single substance across all its buckets.
  ///
  /// Returns Map<bucketName, rawLoad>.
  static Map<String, double> _computeRawLoadsForSubstance({
    required String slug,
    required List<UseLogEntry> logs,
    required ToleranceModel model,
    required DateTime now,
    bool debug = false,
  }) {
    final result = <String, double>{};

    if (model.neuroBuckets.isEmpty) {
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

    if (debug) {
      // ignore: avoid_print
      print('─────────────────────────────────────────────────────────');
      // ignore: avoid_print
      print('💊 Processing: $slug');
      if (logs.isEmpty) {
        // ignore: avoid_print
        print('  !  No use events found - skipping');
        return result;
      }
      // ignore: avoid_print
      print('  📅 Use events: ${logs.length}');
      for (final log in logs) {
        // ignore: avoid_print
        print(
          '    - ${log.timestamp.toUtc()} : ${log.doseUnits.toStringAsFixed(1)}mg',
        );
      }
      // ignore: avoid_print
      print('  📏 Standard unit: ${standardUnit.toStringAsFixed(1)}mg');
    }

    // Pre-calc active window (when "no decay yet") in hours.
    final activeWindowHours = (halfLife > 0)
        ? -halfLife * math.log(activeThreshold)
        : 0.0;

    // For each bucket this substance touches, accumulate raw load from all events.
    for (final bucketEntry in model.neuroBuckets.entries) {
      final bucketName = bucketEntry.key;
      final bucket = bucketEntry.value;

      double rawTotal = 0.0;

      if (debug) {
        // ignore: avoid_print
        print('  🔍 DETAILED CALCULATION FOR BUCKET: $bucketName');
        // ignore: avoid_print
        print(
          '     halfLife: ${halfLife.toStringAsFixed(1)}h, '
          'gainRate: ${gain.toStringAsFixed(3)}, '
          'decayDays: ${decayDays.toStringAsFixed(1)}',
        );
        // ignore: avoid_print
        print(
          '     standardUnit: ${standardUnit.toStringAsFixed(1)}mg, '
          'weight: ${bucket.weight.toStringAsFixed(3)}, '
          'potency: ${potency.toStringAsFixed(3)}',
        );
        // ignore: avoid_print
        print('     Processing ${logs.length} events:');
      }

      for (final log in logs) {
        final hoursSince = now.difference(log.timestamp).inMinutes / 60.0;
        if (hoursSince < 0) {
          // Event in the future -> ignore.
          continue;
        }

        // PK active level.
        final activeLevel = (halfLife > 0)
            ? math.exp(-hoursSince / halfLife)
            : 0.0;

        // Normalized dose vs the "standard" unit for this drug.
        final doseNorm = log.doseUnits / standardUnit;

        // Base contribution before long-term decay.
        final baseContribution =
            doseNorm *
            bucket.weight *
            potency *
            gain *
            _kBaseScaling *
            durationMult;

        // Long-term decay factor for tolerance.
        double decayFactor;
        if (halfLife <= 0 || decayDays <= 0) {
          decayFactor = 0.0;
        } else if (activeLevel >= activeThreshold) {
          // STILL in active window: tolerance does not decay yet.
          decayFactor = 1.0;
        } else {
          final hoursPastActive = math.max(0.0, hoursSince - activeWindowHours);
          final daysPastActive = hoursPastActive / 24.0;
          decayFactor = math.exp(-daysPastActive / decayDays);
        }

        final eventTolNow = baseContribution * decayFactor;
        rawTotal += eventTolNow;

        if (debug) {
          // ignore: avoid_print
          print(
            '       └─ doseNorm: ${doseNorm.toStringAsFixed(3)}, '
            'baseContribution: ${baseContribution.toStringAsFixed(4)}',
          );
          // ignore: avoid_print
          print(
            '       └─ decayFactor: ${decayFactor.toStringAsFixed(4)}, '
            'eventTolNow: ${eventTolNow.toStringAsFixed(4)}, '
            'total: ${rawTotal.toStringAsFixed(4)}',
          );
        }
      }

      if (rawTotal > 0) {
        result[bucketName] = rawTotal;

        if (debug) {
          final pct = loadToPercent(rawTotal);
          // ignore: avoid_print
          print(
            '     ✅ FINAL TOLERANCE: ${rawTotal.toStringAsFixed(4)} (${pct.toStringAsFixed(1)}%)',
          );
          // ignore: avoid_print
          print('  🎯 Bucket Results:');
          // ignore: avoid_print
          print(
            '    - $bucketName: ${pct.toStringAsFixed(1)}% (raw: ${rawTotal.toStringAsFixed(4)}, active: ${pct > 0})',
          );
        }
      } else if (debug) {
        // ignore: avoid_print
        print('     ✅ FINAL TOLERANCE: 0.0000 (0.0%)');
      }
    }

    return result;
  }

  /// Turn bucket percentages into a qualitative state.
  static Map<String, ToleranceSystemState> computeAllBucketStates({
    required Map<String, double> tolerances,
  }) {
    final states = <String, ToleranceSystemState>{};

    for (final entry in tolerances.entries) {
      final pct = entry.value;
      final state = classifyState(pct);
      states[entry.key] = state;
    }

    return states;
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

/// Full tolerance result including additional metrics.
/// Returned by computeToleranceFull().
class ToleranceResult {
  final Map<String, double> bucketPercents; // 0–100%
  final Map<String, double> bucketRawLoads; // raw loads
  final double toleranceScore; // combined score
  final Map<String, double> daysUntilBaseline; // per bucket
  final double overallDaysUntilBaseline;

  const ToleranceResult({
    required this.bucketPercents,
    required this.bucketRawLoads,
    required this.toleranceScore,
    required this.daysUntilBaseline,
    required this.overallDaysUntilBaseline,
  });
}

extension ToleranceCalculatorFull on ToleranceCalculator {
  /// Computes:
  /// - per-bucket % tolerance
  /// - raw loads
  /// - toleranceScore (max bucket)
  /// - daysUntilBaseline per bucket
  /// - overall daysUntilBaseline (max)
  static ToleranceResult computeToleranceFull({
    required List<UseLogEntry> useLogs,
    required Map<String, ToleranceModel> toleranceModels,
    bool debug = false,
  }) {
    final now = DateTime.now();

    /// 1️⃣ Compute raw loads using original function
    final rawLoads = <String, double>{};
    final logsBySubstance = <String, List<UseLogEntry>>{};

    for (final log in useLogs) {
      logsBySubstance.putIfAbsent(log.substanceSlug, () => []).add(log);
    }

    for (final entry in logsBySubstance.entries) {
      final slug = entry.key;
      final model = toleranceModels[slug];
      if (model == null) continue;

      final bucketLoads = ToleranceCalculator._computeRawLoadsForSubstance(
        slug: slug,
        logs: entry.value,
        model: model,
        now: now,
        debug: debug,
      );

      bucketLoads.forEach((bucket, value) {
        rawLoads[bucket] = (rawLoads[bucket] ?? 0.0) + value;
      });
    }

    // Ensure all buckets exist
    for (final bucket in kToleranceBuckets) {
      rawLoads.putIfAbsent(bucket, () => 0.0);
    }

    /// 2️⃣ Convert loads → percentages
    final bucketPercents = {
      for (final entry in rawLoads.entries)
        entry.key: ToleranceCalculator.loadToPercent(entry.value),
    };

    /// 3️⃣ Compute toleranceScore
    /// This is simply the **max bucket percentage**
    final toleranceScore = bucketPercents.values.fold<double>(
      0.0,
      (a, b) => math.max(a, b),
    );

    /// 4️⃣ Estimate daysUntilBaseline for each bucket
    final daysUntilBaseline = <String, double>{};

    for (final bucket in rawLoads.keys) {
      final load = rawLoads[bucket] ?? 0.0;

      // If no load → already recovered
      if (load <= 0.0001) {
        daysUntilBaseline[bucket] = 0.0;
        continue;
      }

      // Find dominant substance parameters that affect this bucket
      double? effectiveDecayDays;

      for (final entry in logsBySubstance.entries) {
        final slug = entry.key;
        final model = toleranceModels[slug];
        if (model == null) continue;

        if (!model.neuroBuckets.containsKey(bucket)) continue;

        // Use the **slowest** decayDays (biggest value)
        effectiveDecayDays = math.max(
          effectiveDecayDays ?? 0.0,
          model.toleranceDecayDays,
        );
      }

      if (effectiveDecayDays == null || effectiveDecayDays <= 0) {
        daysUntilBaseline[bucket] = 0.0;
        continue;
      }

      // Solve: load * exp(-t/decayDays) < 1% (arbitrary baseline)
      final threshold = 0.01; // raw load < 0.01
      final t = -effectiveDecayDays * math.log(threshold / load);

      daysUntilBaseline[bucket] = t.isFinite ? t : 0.0;
    }

    /// 5️⃣ Overall = slowest bucket recovery
    final overallDays = daysUntilBaseline.values.fold<double>(
      0.0,
      (a, b) => math.max(a, b),
    );

    return ToleranceResult(
      bucketPercents: bucketPercents,
      bucketRawLoads: rawLoads,
      toleranceScore: toleranceScore,
      daysUntilBaseline: daysUntilBaseline,
      overallDaysUntilBaseline: overallDays,
    );
  }
}
