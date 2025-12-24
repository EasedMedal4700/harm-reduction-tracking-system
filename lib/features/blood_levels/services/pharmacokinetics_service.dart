import 'dart:math' as math;

/// Dose tier classification for visual representation
enum DoseTier { threshold, light, common, strong, heavy }

/// Represents a parsed dose range with min and max values in mg
class DoseRange {
  final double min;
  final double max;
  const DoseRange(this.min, this.max);
  double get midpoint => (min + max) / 2;
}

/// Pharmacokinetics calculation service for blood level modeling
class PharmacokineticsService {
  /// Parse dose range string (e.g., "10-20mg", "40+mg", "12-15mg")
  static DoseRange? parseDoseRange(String? rangeStr) {
    if (rangeStr == null || rangeStr.isEmpty) return null;
    // Remove "mg" suffix and whitespace
    final cleaned = rangeStr.toLowerCase().replaceAll('mg', '').trim();
    // Handle "40+" format
    if (cleaned.contains('+')) {
      final value = double.tryParse(cleaned.replaceAll('+', ''));
      if (value != null) {
        return DoseRange(value, value * 1.5); // Estimate upper bound
      }
    }
    // Handle "10-20" format
    if (cleaned.contains('-')) {
      final parts = cleaned.split('-');
      if (parts.length == 2) {
        final min = double.tryParse(parts[0].trim());
        final max = double.tryParse(parts[1].trim());
        if (min != null && max != null) {
          return DoseRange(min, max);
        }
      }
    }
    // Handle single number
    final value = double.tryParse(cleaned);
    if (value != null) {
      return DoseRange(value, value);
    }
    return null;
  }

  /// Extract all dose tiers for a given ROA from dose data
  static Map<DoseTier, DoseRange> extractDoseTiers(
    Map<String, dynamic>? doseData,
    String roa,
  ) {
    final tiers = <DoseTier, DoseRange>{};
    if (doseData == null || !doseData.containsKey(roa)) {
      return tiers;
    }
    final roaData = doseData[roa] as Map<String, dynamic>?;
    if (roaData == null) return tiers;
    // Parse each tier
    final threshold = parseDoseRange(roaData['Threshold']);
    final light = parseDoseRange(roaData['Light']);
    final common = parseDoseRange(roaData['Common']);
    final strong = parseDoseRange(roaData['Strong']);
    final heavy = parseDoseRange(roaData['Heavy']);
    if (threshold != null) tiers[DoseTier.threshold] = threshold;
    if (light != null) tiers[DoseTier.light] = light;
    if (common != null) tiers[DoseTier.common] = common;
    if (strong != null) tiers[DoseTier.strong] = strong;
    if (heavy != null) tiers[DoseTier.heavy] = heavy;
    return tiers;
  }

  /// Determine the "Heavy threshold" (100% scale point) for multiple ROAs
  /// Returns the MINIMUM heavy threshold across all ROAs (most potent route)
  static double determineUnifiedHeavyThreshold(
    Map<String, dynamic>? doseData,
    List<String> roas,
  ) {
    double minHeavyThreshold = double.infinity;
    for (final roa in roas) {
      final tiers = extractDoseTiers(doseData, roa);
      final heavy = tiers[DoseTier.heavy];
      if (heavy != null && heavy.min < minHeavyThreshold) {
        minHeavyThreshold = heavy.min;
      }
    }
    // Fallback if no heavy range found
    return minHeavyThreshold == double.infinity ? 100.0 : minHeavyThreshold;
  }

  /// Convert dose from one ROA to unified scale based on heavy thresholds
  static double convertDoseToUnifiedScale({
    required double doseMg,
    required String currentRoa,
    required Map<String, dynamic>? doseData,
    required double unifiedHeavyThreshold,
  }) {
    if (doseData == null) return doseMg;
    final tiers = extractDoseTiers(doseData, currentRoa);
    final heavy = tiers[DoseTier.heavy];
    if (heavy == null) return doseMg;
    // Calculate conversion factor
    final conversionFactor = unifiedHeavyThreshold / heavy.min;
    return doseMg * conversionFactor;
  }

  /// Calculate percentage based on unified heavy threshold
  static double calculatePercentage({
    required double unifiedDoseMg,
    required double unifiedHeavyThreshold,
  }) {
    if (unifiedHeavyThreshold == 0) return 0;
    return (unifiedDoseMg / unifiedHeavyThreshold) * 100.0;
  }

  /// Calculate current remaining dose based on half-life decay
  static double calculateRemainingDose({
    required double initialDoseMg,
    required double halfLifeHours,
    required Duration timeSinceIngestion,
  }) {
    if (halfLifeHours <= 0) return 0;
    final hoursElapsed = timeSinceIngestion.inMinutes / 60.0;
    final halfLives = hoursElapsed / halfLifeHours;
    return initialDoseMg * math.pow(0.5, halfLives);
  }

  /// Classify current dose into a tier
  static DoseTier? classifyDose({
    required double doseMg,
    required Map<DoseTier, DoseRange> tiers,
  }) {
    // Check from highest to lowest
    final heavy = tiers[DoseTier.heavy];
    if (heavy != null && doseMg >= heavy.min) return DoseTier.heavy;
    final strong = tiers[DoseTier.strong];
    if (strong != null && doseMg >= strong.min) return DoseTier.strong;
    final common = tiers[DoseTier.common];
    if (common != null && doseMg >= common.min) return DoseTier.common;
    final light = tiers[DoseTier.light];
    if (light != null && doseMg >= light.min) return DoseTier.light;
    final threshold = tiers[DoseTier.threshold];
    if (threshold != null && doseMg >= threshold.min) return DoseTier.threshold;
    return null; // Below threshold
  }

  /// Calculate time until dose drops to next tier
  static Duration? calculateTimeToNextTier({
    required double currentDoseMg,
    required double targetDoseMg,
    required double halfLifeHours,
  }) {
    if (currentDoseMg <= targetDoseMg || halfLifeHours <= 0) {
      return null;
    }
    // Solve: targetDose = currentDose * 0.5^(t/halfLife)
    // t = halfLife * log(targetDose/currentDose) / log(0.5)
    final ratio = targetDoseMg / currentDoseMg;
    final halfLivesNeeded = math.log(ratio) / math.log(0.5);
    final hoursNeeded = halfLivesNeeded * halfLifeHours;
    return Duration(minutes: (hoursNeeded * 60).round());
  }

  /// Generate PK curve points for graphing
  static List<PKPoint> calculatePKCurve({
    required double initialDoseMg,
    required double halfLifeHours,
    required DateTime ingestionTime,
    required DateTime startTime,
    required DateTime endTime,
    required double unifiedHeavyThreshold,
    int pointCount = 100,
  }) {
    final points = <PKPoint>[];
    final totalDuration = endTime.difference(startTime);
    final intervalMs = totalDuration.inMilliseconds / pointCount;
    for (int i = 0; i <= pointCount; i++) {
      final currentTime = startTime.add(
        Duration(milliseconds: (intervalMs * i).round()),
      );
      // Only calculate if time is after ingestion
      if (currentTime.isBefore(ingestionTime)) {
        points.add(PKPoint(currentTime, 0, 0));
        continue;
      }
      final timeSinceIngestion = currentTime.difference(ingestionTime);
      final remainingDose = calculateRemainingDose(
        initialDoseMg: initialDoseMg,
        halfLifeHours: halfLifeHours,
        timeSinceIngestion: timeSinceIngestion,
      );
      final percentage = calculatePercentage(
        unifiedDoseMg: remainingDose,
        unifiedHeavyThreshold: unifiedHeavyThreshold,
      );
      points.add(PKPoint(currentTime, remainingDose, percentage));
    }
    return points;
  }

  /// Get user-friendly tier name
  static String getTierName(DoseTier tier) {
    switch (tier) {
      case DoseTier.threshold:
        return 'Threshold';
      case DoseTier.light:
        return 'Light';
      case DoseTier.common:
        return 'Common';
      case DoseTier.strong:
        return 'Strong';
      case DoseTier.heavy:
        return 'Heavy';
    }
  }

  /// Get tier color for visualization
  static int getTierColorValue(DoseTier tier) {
    switch (tier) {
      case DoseTier.threshold:
        return 0xFF3B82F6; // Blue
      case DoseTier.light:
        return 0xFF10B981; // Green
      case DoseTier.common:
        return 0xFFFBBF24; // Yellow
      case DoseTier.strong:
        return 0xFFF59E0B; // Orange
      case DoseTier.heavy:
        return 0xFFEF4444; // Red
    }
  }
}

/// Represents a point on the PK curve
class PKPoint {
  final DateTime time;
  final double doseMg;
  final double percentage;
  PKPoint(this.time, this.doseMg, this.percentage);
}
