// MIGRATION:
// State: LEGACY
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Legacy utility.
import 'dart:math';
import '../../../models/tolerance_model.dart';

/// Tolerance calculation utilities
///
/// LEGACY SYSTEM: This calculator uses the OLD exponential decay + logistic curve formula.
/// It's used for system-wide tolerance aggregation across all substances.
///
/// For per-substance bucket-specific tolerance, see BucketToleranceCalculator (NEW system).
class ToleranceCalculator {
  /// Logistic curve parameter for load -> percent conversion
  /// RECALIBRATED: Reduced from 100.0 to 18.0 to prevent explosive tolerance buildup
  /// This ensures 8 uses of 5mg Dexedrine over 4 days produces ~30-35% tolerance
  /// Formula: percent = 100 × (1 - e^(-load / K))
  /// Lower K = higher sensitivity (more tolerance per dose)
  /// Higher K = lower sensitivity (less tolerance per dose)
  static const double kLogisticK = 18.0; // Was 100.0, then 12.5, now 18.0
  /// Classify system state based on tolerance percentage
  ///
  /// Returns:
  /// - Recovered: 0-20%
  /// - Light Stress: 20-40%
  /// - Moderate Strain: 40-60%
  /// - High Strain: 60-80%
  /// - Depleted: 80-100%
  static ToleranceSystemState classifySystemState(double percent) {
    if (percent < 20) return ToleranceSystemState.recovered;
    if (percent < 40) return ToleranceSystemState.lightStress;
    if (percent < 60) return ToleranceSystemState.moderateStrain;
    if (percent < 80) return ToleranceSystemState.highStrain;
    return ToleranceSystemState.depleted;
  }

  /// Compute raw bucket load using exponential decay
  ///
  /// Formula: load += doseUnits * weight * exp(-hoursSince / halfLifeHours)
  static double computeRawBucketLoad({
    required List<UseLogEntry> useLogs,
    required Map<String, ToleranceModel> toleranceModels,
    required String bucket,
    required DateTime now,
  }) {
    double load = 0.0;
    for (final log in useLogs) {
      final model = toleranceModels[log.substanceSlug];
      if (model == null) continue;
      final neuroBucket = model.neuroBuckets[bucket];
      if (neuroBucket == null) continue;
      final hoursSince = now.difference(log.timestamp).inMinutes / 60.0;
      if (hoursSince < 0) continue;
      final weight = neuroBucket.weight;
      final halfLife = model.halfLifeHours;
      if (halfLife <= 0) continue;
      final decayFactor = exp(-hoursSince / halfLife);
      load += log.doseUnits * weight * decayFactor;
    }
    return load;
  }

  /// Convert raw load to tolerance percentage using logistic curve
  ///
  /// Formula: percent = 100 * (1 - exp(-load / K))
  /// where K = 100
  static double loadToPercent(double load) {
    if (load <= 0) return 0.0;
    final percent = 100.0 * (1.0 - exp(-load / kLogisticK));
    return percent.clamp(0.0, 100.0);
  }

  /// Compute tolerance percentages for all buckets
  ///
  /// CRITICAL: Computes tolerance for ALL buckets found in tolerance models,
  /// not just a hardcoded list. This ensures we capture all 7+ bucket types.
  ///
  /// Returns `Map<String, double>` like:
  /// {
  ///   "gaba": 72.4,
  ///   "stimulant": 33.8,
  ///   "serotonin_release": 49.1,
  ///   "serotonin_psychedelic": 12.5,
  ///   "opioid": 11.8,
  ///   "nmda": 22.0,
  ///   "cannabinoid": 5.3
  /// }
  static Map<String, double> computeAllBucketTolerances({
    required List<UseLogEntry> useLogs,
    required Map<String, ToleranceModel> toleranceModels,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final result = <String, double>{};
    // Collect ALL unique bucket types from all tolerance models
    final allBuckets = <String>{};
    for (final model in toleranceModels.values) {
      allBuckets.addAll(model.neuroBuckets.keys);
    }
    // Compute tolerance for each bucket found
    for (final bucket in allBuckets) {
      final load = computeRawBucketLoad(
        useLogs: useLogs,
        toleranceModels: toleranceModels,
        bucket: bucket,
        now: currentTime,
      );
      result[bucket] = loadToPercent(load);
    }
    return result;
  }

  /// Compute system states for all buckets
  static Map<String, ToleranceSystemState> computeAllBucketStates({
    required Map<String, double> tolerances,
  }) {
    final result = <String, ToleranceSystemState>{};
    for (final entry in tolerances.entries) {
      result[entry.key] = classifySystemState(entry.value);
    }
    return result;
  }

  /// Calculate effective plasma level at a given time
  /// Uses exponential decay: C(t) = C0 * e^(-kt)
  /// where k = ln(2) / half_life
  static double effectivePlasmaLevel({
    required DateTime useTime,
    required DateTime currentTime,
    required double halfLifeHours,
    required double initialDose,
  }) {
    final hoursSinceUse = currentTime.difference(useTime).inMinutes / 60.0;
    if (hoursSinceUse < 0) return 0.0;
    if (halfLifeHours <= 0) return 0.0;
    final decayConstant = log(2) / halfLifeHours;
    final plasmaLevel = initialDose * exp(-decayConstant * hoursSinceUse);
    return plasmaLevel;
  }

  /// Calculate tolerance score (0-100) based on cumulative use events
  /// Higher overlap of plasma levels = higher tolerance
  static double toleranceScore({
    required List<UseEvent> useEvents,
    required double halfLifeHours,
    required DateTime currentTime,
  }) {
    if (useEvents.isEmpty) return 0.0;
    double cumulativePlasma = 0.0;
    for (final event in useEvents) {
      final plasma = effectivePlasmaLevel(
        useTime: event.timestamp,
        currentTime: currentTime,
        halfLifeHours: halfLifeHours,
        initialDose: event.dose,
      );
      cumulativePlasma += plasma;
    }
    // Normalize to 0-100 scale with logarithmic scaling
    // This prevents extreme values while maintaining sensitivity
    final normalizedScore = (log(cumulativePlasma + 1) / log(100)) * 100;
    return normalizedScore.clamp(0.0, 100.0);
  }

  /// Calculate tolerance decay (0-1) based on days since last use
  /// Returns multiplier: 1.0 = full tolerance, 0.0 = baseline
  static double decayFunction({
    required double daysSinceLastUse,
    required double toleranceDecayDays,
  }) {
    if (daysSinceLastUse <= 0) return 1.0;
    if (toleranceDecayDays <= 0) return 0.0;
    // Exponential decay: e^(-t/τ) where τ is decay time constant
    final decayRate = 1.0 / toleranceDecayDays;
    final decayMultiplier = exp(-decayRate * daysSinceLastUse);
    return decayMultiplier.clamp(0.0, 1.0);
  }

  /// Calculate neuro bucket contribution to overall tolerance
  static double neuroBucketContribution({
    required double bucketWeight,
    required double toleranceScore,
  }) {
    return (bucketWeight * toleranceScore).clamp(0.0, 100.0);
  }

  /// Calculate days until baseline (tolerance < 5%)
  static double daysUntilBaseline({
    required double currentTolerance,
    required double toleranceDecayDays,
  }) {
    if (currentTolerance <= 5.0) return 0.0;
    // Solve: current * e^(-t/τ) = 5
    // t = -τ * ln(5/current)
    final timeToBaseline = -toleranceDecayDays * log(5.0 / currentTolerance);
    return timeToBaseline.clamp(0.0, 365.0); // Cap at 1 year
  }

  /// Generate tolerance curve data points for graphing
  static List<TolerancePoint> generateToleranceCurve({
    required List<UseEvent> useEvents,
    required double halfLifeHours,
    required double toleranceDecayDays,
    required DateTime startTime,
    required DateTime endTime,
    int dataPoints = 50,
  }) {
    if (useEvents.isEmpty) return [];
    final points = <TolerancePoint>[];
    final duration = endTime.difference(startTime);
    final interval = duration ~/ dataPoints;
    for (int i = 0; i <= dataPoints; i++) {
      final time = startTime.add(interval * i);
      final score = toleranceScore(
        useEvents: useEvents,
        halfLifeHours: halfLifeHours,
        currentTime: time,
      );
      // Apply decay if past last use
      final lastUse = useEvents
          .map((e) => e.timestamp)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      final daysSinceLast = time.difference(lastUse).inHours / 24.0;
      final decayedScore =
          score *
          decayFunction(
            daysSinceLastUse: daysSinceLast,
            toleranceDecayDays: toleranceDecayDays,
          );
      points.add(TolerancePoint(time: time, score: decayedScore));
    }
    return points;
  }

  /// Generate decay projection curve from current time
  static List<TolerancePoint> generateDecayProjection({
    required double currentTolerance,
    required double toleranceDecayDays,
    required DateTime startTime,
    int durationDays = 14,
    int dataPoints = 50,
  }) {
    final points = <TolerancePoint>[];
    final hoursPerPoint = (durationDays * 24) / dataPoints;
    for (int i = 0; i <= dataPoints; i++) {
      final time = startTime.add(Duration(hours: (hoursPerPoint * i).round()));
      final daysSinceStart = i * hoursPerPoint / 24.0;
      final score =
          currentTolerance *
          decayFunction(
            daysSinceLastUse: daysSinceStart,
            toleranceDecayDays: toleranceDecayDays,
          );
      points.add(TolerancePoint(time: time, score: score));
    }
    return points;
  }
}
