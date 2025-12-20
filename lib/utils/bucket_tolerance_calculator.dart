import 'dart:math';
import '../models/tolerance_bucket.dart';
import 'bucket_tolerance_formulas.dart';

/// Use event for tolerance calculations.
class UseEvent {
  final DateTime timestamp;
  final double doseMg;
  final String substance;

  const UseEvent({
    required this.timestamp,
    required this.doseMg,
    required this.substance,
  });
}

/// Result of bucket tolerance calculation.
class BucketToleranceResult {
  final String bucketType;
  final double tolerance;
  final double activeLevel;
  final bool isActive;

  const BucketToleranceResult({
    required this.bucketType,
    required this.tolerance,
    required this.activeLevel,
    required this.isActive,
  });
}

/// Main bucket-based tolerance calculator.
///
/// CRITICAL SAFETY WARNING:
/// These tolerance calculations are NOT medically validated.
/// The values shown are approximations only and cannot predict safety,
/// overdose risk, or health outcomes. Tolerance does NOT equal safety.
/// Real-world risks vary widely based on individual physiology, drug purity,
/// drug interactions, and countless other factors. Use at your own risk.
class BucketToleranceCalculator {
  /// Calculates active level using exponential decay.
  ///
  /// Formula: active_level = e^(-time_since_use_hours / half_life_hours)
  static double calculateActiveLevel({
    required DateTime useTime,
    required DateTime currentTime,
    required double halfLifeHours,
  }) {
    final timeSinceUseHours = currentTime.difference(useTime).inMinutes / 60.0;
    if (timeSinceUseHours < 0) return 0.0;

    final activeLevel = exp(-timeSinceUseHours / halfLifeHours);
    return activeLevel;
  }

  /// Normalizes dose based on standard unit.
  ///
  /// Formula: dose_normalized = dose_mg / standard_unit_mg
  static double normalizeDose({
    required double doseMg,
    required double standardUnitMg,
  }) {
    if (standardUnitMg <= 0) return doseMg;
    return doseMg / standardUnitMg;
  }

  /// Calculates tolerance for a single bucket from use events.
  ///
  /// NEW ALGORITHM (Fixed for accurate tolerance calculation):
  /// 1. For EACH use event, calculate its base tolerance contribution at the moment of use
  /// 2. Apply exponential decay to each contribution individually based on time since that use
  /// 3. If active_level > threshold, PAUSE decay (don't add more tolerance, just pause decay)
  /// 4. Sum all decayed contributions to get total current tolerance
  ///
  /// This ensures:
  /// - Tolerance is added ONCE per use event (not repeatedly on every recalculation)
  /// - Each event decays independently based on its own timestamp
  /// - Active substances pause decay but don't add duplicate tolerance
  /// - Light use (8×5mg over 4 days) produces 20-40% tolerance, not 1000%
  static BucketToleranceResult calculateBucketToleranceFromEvents({
    required ToleranceBucket bucket,
    required List<UseEvent> useEvents,
    required double halfLifeHours,
    required double activeThreshold,
    required double toleranceGainRate,
    required double toleranceDecayDays,
    required double standardUnitMg,
    required DateTime currentTime,
  }) {
    print('  🔍 DETAILED CALCULATION FOR BUCKET: ${bucket.type}');
    print(
      '     halfLife: ${halfLifeHours}h, gainRate: $toleranceGainRate, decayDays: $toleranceDecayDays',
    );
    print(
      '     standardUnit: ${standardUnitMg}mg, weight: ${bucket.weight}, potency: ${bucket.potencyMultiplier}',
    );

    double totalTolerance = 0.0;
    double currentActiveLevel = 0.0;

    // Sort events by time (oldest first)
    final sortedEvents = List<UseEvent>.from(useEvents)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    print('     Processing ${sortedEvents.length} events:');
    for (final event in sortedEvents) {
      // Calculate active level for this specific use event
      final activeLevel = calculateActiveLevel(
        useTime: event.timestamp,
        currentTime: currentTime,
        halfLifeHours: halfLifeHours,
      );

      // Track the maximum active level across all uses
      currentActiveLevel = max(currentActiveLevel, activeLevel);

      // Calculate hours since this specific use
      final hoursSinceUse =
          currentTime.difference(event.timestamp).inMinutes / 60.0;

      // Normalize the dose to standard units
      final doseNormalized = normalizeDose(
        doseMg: event.doseMg,
        standardUnitMg: standardUnitMg,
      );

      // Calculate BASE tolerance contribution for this use (ONCE, at time of use)
      // Formula: base_contribution = (dose / standard_unit) × weight × potency × gain_rate
      final baseContribution = BucketToleranceFormulas.calculateBucketTolerance(
        toleranceType: bucket.toleranceType,
        doseNormalized: doseNormalized,
        weight: bucket.weight,
        potencyMultiplier: bucket.potencyMultiplier,
        durationMultiplier: bucket.durationMultiplier,
        toleranceGainRate: toleranceGainRate,
      );

      print(
        '       └─ doseNorm: ${doseNormalized.toStringAsFixed(3)}, baseContribution: ${baseContribution.toStringAsFixed(4)}',
      );

      // Apply exponential decay to THIS event's contribution
      // Formula: tolerance_now = base_contribution × e^(-hours_since_use / (decay_days × 24))
      //
      // CRITICAL: active_level does NOT add more tolerance. It ONLY pauses decay.
      // If active_level > threshold, skip decay (set decay factor to 1.0)
      double decayFactor = 1.0;

      if (activeLevel <= activeThreshold) {
        // Substance is no longer active from this use, apply decay
        final decayMultiplier = BucketToleranceFormulas.getDecayMultiplier(
          bucket.toleranceType,
        );
        final adjustedDecayDays = toleranceDecayDays * decayMultiplier;
        final decayHours = adjustedDecayDays * 24.0;

        // Exponential decay: e^(-time / decay_constant)
        decayFactor = exp(-hoursSinceUse / decayHours);
      }
      // else: active_level > threshold, so decay is PAUSED (decayFactor = 1.0, no decay)

      // Calculate current tolerance from this event (with decay applied)
      final eventToleranceNow = baseContribution * decayFactor;

      print(
        '       └─ decayFactor: ${decayFactor.toStringAsFixed(4)}, eventTolNow: ${eventToleranceNow.toStringAsFixed(4)}, total: ${(totalTolerance + eventToleranceNow).toStringAsFixed(4)}',
      );

      // Add this event's decayed contribution to total tolerance
      totalTolerance += eventToleranceNow;
    }

    print(
      '     ✅ FINAL TOLERANCE: ${totalTolerance.toStringAsFixed(4)} (${(totalTolerance * 100).toStringAsFixed(1)}%)',
    );
    if (totalTolerance > 2.0) {
      print('     ⚠️⚠️⚠️ ERROR: Tolerance > 200%! Check formula parameters!');
    }

    return BucketToleranceResult(
      bucketType: bucket.type,
      tolerance: totalTolerance,
      activeLevel: currentActiveLevel,
      isActive: currentActiveLevel > activeThreshold,
    );
  }

  /// Calculates total tolerance for a substance by aggregating all buckets.
  static Map<String, BucketToleranceResult> calculateSubstanceTolerance({
    required BucketToleranceModel model,
    required List<UseEvent> useEvents,
    required double standardUnitMg,
    required DateTime currentTime,
  }) {
    final results = <String, BucketToleranceResult>{};

    for (final bucket in model.neuroBuckets.values) {
      final result = calculateBucketToleranceFromEvents(
        bucket: bucket,
        useEvents: useEvents,
        halfLifeHours: model.halfLifeHours,
        activeThreshold: model.activeThreshold,
        toleranceGainRate: model.toleranceGainRate,
        toleranceDecayDays: model.toleranceDecayDays,
        standardUnitMg: standardUnitMg,
        currentTime: currentTime,
      );

      results[bucket.type] = result;
    }

    return results;
  }

  /// Calculates overall tolerance score for a substance (weighted average).
  static double calculateOverallSubstanceTolerance({
    required Map<String, BucketToleranceResult> bucketResults,
  }) {
    if (bucketResults.isEmpty) return 0.0;

    double weightedSum = 0.0;
    double totalWeight = 0.0;

    for (final result in bucketResults.values) {
      weightedSum += result.tolerance;
      totalWeight += 1.0; // Equal weighting for now
    }

    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }

  /// Calculates system-wide tolerance across multiple substances with cross-tolerance.
  ///
  /// Cross-tolerance: If a bucket_type appears in multiple substances,
  /// tolerance combines (summed for now).
  static Map<String, double> calculateSystemTolerance({
    required Map<String, Map<String, BucketToleranceResult>>
    allSubstanceResults,
  }) {
    final systemTolerance = <String, double>{};

    // Aggregate tolerance by bucket type across all substances
    for (final substanceResults in allSubstanceResults.values) {
      for (final entry in substanceResults.entries) {
        final bucketType = entry.key;
        final result = entry.value;

        systemTolerance[bucketType] =
            (systemTolerance[bucketType] ?? 0.0) + result.tolerance;
      }
    }

    return systemTolerance;
  }

  /// Calculates overall system tolerance score (weighted average across all buckets).
  static double calculateOverallSystemTolerance({
    required Map<String, double> systemBucketTolerances,
  }) {
    if (systemBucketTolerances.isEmpty) return 0.0;

    double sum = 0.0;
    int count = 0;

    for (final tolerance in systemBucketTolerances.values) {
      sum += tolerance;
      count++;
    }

    return count > 0 ? sum / count : 0.0;
  }

  /// Estimates days until baseline tolerance for a bucket.
  static double estimateDaysUntilBaseline({
    required double currentTolerance,
    required double toleranceDecayDays,
    required String toleranceType,
    double baselineThreshold = 0.01,
  }) {
    if (currentTolerance <= baselineThreshold) return 0.0;

    final decayMultiplier = BucketToleranceFormulas.getDecayMultiplier(
      toleranceType,
    );
    final adjustedDecayDays = toleranceDecayDays * decayMultiplier;

    // Using exponential decay: tolerance = initial * e^(-days / decay_days)
    // Solve for days when tolerance = baseline_threshold
    final days = -adjustedDecayDays * log(baselineThreshold / currentTolerance);

    return days.isFinite && days > 0 ? days : 0.0;
  }
}
