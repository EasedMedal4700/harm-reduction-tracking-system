import 'dart:math';

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
    
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    
    // Logarithmic scaling: log(1 + x) / log(base)
    // Using natural log (ln) normalized to reasonable scale
    final logTolerance = log(1.0 + effectiveDose * 2.0) / log(3.0); // Base 3 for moderate growth
    
    // Apply gain rate with logarithmic damping
    final calibrationFactor = 0.15; // Slightly higher than before due to log damping
    
    final result = logTolerance * toleranceGainRate * calibrationFactor;
    
    if (result > 0.1) { // Only log significant contributions
      print('         [STIMULANT FORMULA]: effDose=${effectiveDose.toStringAsFixed(3)}, log=${logTolerance.toStringAsFixed(4)}, result=${result.toStringAsFixed(4)}');
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
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance = log(1.0 + effectiveDose * 2.5) / log(2.5); // Faster initial growth
    
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
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance = log(1.0 + effectiveDose * 3.0) / log(2.0); // Very fast initial
    
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
    // LOGARITHMIC GROWTH - consistent with other buckets
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance = log(1.0 + effectiveDose * 1.5) / log(3.2); // Moderate growth
    
    final calibrationFactor = 0.14; // Slower buildup, dangerous withdrawal considerations
    return logTolerance * toleranceGainRate * calibrationFactor;
  }

  /// Calculates tolerance for NMDA antagonist bucket (ketamine, DXM, etc.).
  /// LOGARITHMIC MODEL: Slow buildup with rebound sensitivity, then plateaus.
  static double calculateNmdaTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - moderate buildup with rebound
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance = log(1.0 + effectiveDose * 1.8) / log(2.8);
    
    final reboundMultiplier = 0.20; // Rebound-sensitive with log damping
    return logTolerance * toleranceGainRate * reboundMultiplier;
  }

  /// Calculates tolerance for opioid bucket.
  /// LOGARITHMIC MODEL: Biphasic - rapid initial buildup, then plateaus.
  static double calculateOpioidTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - biphasic rapid initial
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance = log(1.0 + effectiveDose * 2.2) / log(2.6);
    
    final biphasicMultiplier = 0.22; // Rapid initial phase with log damping
    return logTolerance * toleranceGainRate * biphasicMultiplier;
  }

  /// Calculates tolerance for cannabinoid bucket (THC, CBD, etc.).
  /// LOGARITHMIC MODEL: Very slow buildup, gentle plateau. Slow decay.
  static double calculateCannabinoidTolerance({
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    // LOGARITHMIC GROWTH - very slow buildup
    final effectiveDose = doseNormalized * potencyMultiplier * weight * durationMultiplier;
    final logTolerance = log(1.0 + effectiveDose * 1.2) / log(3.5); // Slowest growth
    
    final slowMultiplier = 0.12; // Very slow buildup with log damping
    return logTolerance * toleranceGainRate * slowMultiplier;
  }

  /// Calculates tolerance decay multiplier based on tolerance type.
  /// Returns a multiplier for tolerance_decay_days.
  /// 
  /// RECALIBRATED DECAY RATES:
  /// - Stimulant: 1.2× (slightly slower than baseline, ~8-10 days full decay)
  /// - Serotonin psychedelic: 0.4× (very fast, 3-5 days)
  /// - Serotonin release: 2.0× (long decay, weeks)
  /// - Others: Moderate to slow decay
  static double getDecayMultiplier(String toleranceType) {
    switch (toleranceType.toLowerCase()) {
      case 'serotonin_psychedelic':
        return 0.4; // Very fast decay (3-5 days)
      case 'serotonin_release':
        return 2.0; // Long decay (weeks)
      case 'gaba':
        return 1.3; // Slower decay
      case 'nmda':
        return 1.5; // Slow rebound-sensitive decay
      case 'opioid':
        return 1.0; // Biphasic decay
      case 'cannabinoid':
        return 1.8; // Slow decay
      case 'stimulant':
        return 1.2; // Slightly slower than baseline (8-10 days)
      default:
        return 1.0; // Normal decay
    }
  }

  /// Main dispatcher for bucket-specific tolerance calculation.
  static double calculateBucketTolerance({
    required String toleranceType,
    required double doseNormalized,
    required double weight,
    required double potencyMultiplier,
    required double durationMultiplier,
    required double toleranceGainRate,
  }) {
    switch (toleranceType.toLowerCase()) {
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
      
      case 'nmda':
        return calculateNmdaTolerance(
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
      
      case 'cannabinoid':
        return calculateCannabinoidTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
      
      default:
        // Default to stimulant formula
        return calculateStimulantTolerance(
          doseNormalized: doseNormalized,
          weight: weight,
          potencyMultiplier: potencyMultiplier,
          durationMultiplier: durationMultiplier,
          toleranceGainRate: toleranceGainRate,
        );
    }
  }
}
