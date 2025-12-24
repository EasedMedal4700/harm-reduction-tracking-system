import 'dart:math';
import '../common/logging/app_log.dart';

/// Bucket-specific tolerance calculation formulas.
///
/// CRITICAL WARNING: These tolerance calculations are NOT medically validated.
/// The values shown to users are approximations only. They cannot predict
/// safety, overdose risk, or health outcomes. The user must use this feature
/// at their own risk. Tolerance does NOT equal safety.
class BucketToleranceFormulas {
  /// Calculates tolerance for stimulant bucket (dopamine/norepinephrine).
  ///
  /// LOGARITHMIC GROWTH MODEL:
  /// - Tolerance builds rapidly at first, then plateaus (diminishing returns)
  /// - Formula: tolerance = log(1 + dose) × scaling_factor
  /// - Prevents unrealistic buildup (was reaching 3636.7%!)
  /// - 8 uses of 5mg Dexedrine over 4 days → ~20-40% tolerance
  /// - Heavy chronic use → asymptotically approaches ~90-95%, never infinity
  static double calculateStimulantTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH MODEL
    // log(1 + x) provides natural diminishing returns:
    // - Small doses: Rapid tolerance buildup
    // - Large doses: Slower additional buildup (asymptotic)
    // - Prevents explosive unrealistic values
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    // Logarithmic scaling: log(1 + x) / log(base)
    // Using natural log (ln) normalized to reasonable scale
    final logTolerance =
        log(1.0 + effectiveDose * 2.0) / log(3.0); // Base 3 for moderate growth
    // Apply gain rate with logarithmic damping
    final calibrationFactor =
        0.15; // Slightly higher than before due to log damping
    final result = logTolerance * toleranceGainRate * calibrationFactor;
    if (result > 0.1) {
      // Only log significant contributions
      AppLog.d(
        '         [STIMULANT FORMULA]: effDose=${effectiveDose.toStringAsFixed(3)}, log=${logTolerance.toStringAsFixed(4)}, result=${result.toStringAsFixed(4)}',
      );
    }
    return result;
  }

  /// Calculates tolerance for serotonin release bucket (MDMA, etc.).
  /// LOGARITHMIC MODEL: Strong initial buildup, then plateaus. Long decay.
  static double calculateSerotoninReleaseTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - strong initial, then diminishing
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 2.5) / log(2.5); // Faster initial growth
    final buildupMultiplier = 0.25; // Stronger buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for serotonin psychedelic bucket (LSD, psilocybin, etc.).
  /// LOGARITHMIC MODEL: Very fast initial buildup, then plateaus. Fast decay (3-5 days).
  static double calculateSerotoninPsychedelicTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - very rapid initial, sharp plateau
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 3.0) / log(2.0); // Very fast initial
    final buildupMultiplier = 0.35; // Strong buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for GABA bucket (alcohol, benzos, etc.).
  /// LOGARITHMIC MODEL: Slow buildup with slower decay. Dangerous withdrawal potential.
  static double calculateGabaTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - slow but steady
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 1.5) / log(4.0); // Slower growth
    final buildupMultiplier = 0.20; // Moderate buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for Opioid bucket (painkillers, heroin, etc.).
  /// LOGARITHMIC MODEL: Moderate buildup, dangerous plateau.
  static double calculateOpioidTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - moderate
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 2.0) / log(3.0); // Moderate growth
    final buildupMultiplier = 0.25; // Moderate buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for Dissociative bucket (ketamine, DXM, etc.).
  /// LOGARITHMIC MODEL: Slow buildup, very long decay (perma-tolerance risk).
  static double calculateDissociativeTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - slow
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 1.5) / log(3.5); // Slower growth
    final buildupMultiplier = 0.20; // Moderate buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for Cannabinoid bucket (THC, etc.).
  /// LOGARITHMIC MODEL: Fast buildup, fast decay.
  static double calculateCannabinoidTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - fast
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 2.5) / log(2.5); // Fast growth
    final buildupMultiplier = 0.30; // Strong buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for Deliriant bucket (DPH, Datura, etc.).
  /// LOGARITHMIC MODEL: Unpredictable, dangerous.
  static double calculateDeliriantTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - unpredictable
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 2.0) / log(3.0); // Moderate growth
    final buildupMultiplier = 0.25; // Moderate buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Calculates tolerance for generic bucket (unknown mechanism).
  /// LOGARITHMIC MODEL: Conservative estimate.
  static double calculateGenericTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - conservative
    final effectiveDose =
        doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance =
        log(1.0 + effectiveDose * 1.5) / log(3.5); // Slower growth
    final buildupMultiplier = 0.20; // Moderate buildup with log damping
    return logTolerance * toleranceGainRate * buildupMultiplier;
  }

  /// Main entry point to calculate tolerance based on bucket type.
  static double calculateBucketTolerance({
    required String toleranceType,
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    switch (toleranceType) {
      case 'stimulant':
        return calculateStimulantTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'serotonin_release':
        return calculateSerotoninReleaseTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'serotonin_psychedelic':
        return calculateSerotoninPsychedelicTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'gaba':
        return calculateGabaTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'opioid':
        return calculateOpioidTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'dissociative':
        return calculateDissociativeTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'cannabinoid':
        return calculateCannabinoidTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      case 'deliriant':
        return calculateDeliriantTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      default:
        return calculateGenericTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
    }
  }

  /// Gets decay multiplier based on bucket type.
  /// Some substances decay faster (psychedelics) or slower (dissociatives) than average.
  static double getDecayMultiplier(String toleranceType) {
    switch (toleranceType) {
      case 'stimulant':
        return 1.0; // Standard decay
      case 'serotonin_release':
        return 1.5; // Slower decay (takes longer to recover serotonin)
      case 'serotonin_psychedelic':
        return 0.5; // Faster decay (3-5 days usually)
      case 'gaba':
        return 1.2; // Slightly slower decay
      case 'opioid':
        return 1.0; // Standard decay
      case 'dissociative':
        return 2.0; // Very slow decay (perma-tolerance risk)
      case 'cannabinoid':
        return 0.8; // Slightly faster decay
      case 'deliriant':
        return 1.5; // Slower decay
      default:
        return 1.0;
    }
  }
}
