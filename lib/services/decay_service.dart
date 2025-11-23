import 'dart:math';
import '../models/curve_point.dart';
import '../services/blood_levels_service.dart';
import '../utils/drug_profile_utils.dart';

/// Service for calculating pharmacokinetic decay curves
class DecayService {
  /// Calculate remaining drug amount using exponential decay
  ///
  /// Formula: remaining(t) = dose * exp(-ln(2) * t / halfLife)
  ///
  /// [doseMg] - Initial dose in milligrams
  /// [hoursSinceDose] - Time elapsed since dose was taken
  /// [halfLife] - Drug half-life in hours
  double decayRemaining(double doseMg, double hoursSinceDose, double halfLife) {
    if (doseMg <= 0 || hoursSinceDose < 0 || halfLife <= 0) {
      return 0.0;
    }

    // Using exponential decay: remaining = dose * 2^(-t/halfLife)
    final remaining = doseMg * pow(0.5, hoursSinceDose / halfLife);
    return remaining.clamp(0.0, doseMg);
  }

  /// Generate decay curve points for a single dose over a time window
  ///
  /// [dose] - Dose entry from blood levels service
  /// [halfLife] - Drug half-life in hours
  /// [referenceTime] - The "now" point (usually current time or selected time)
  /// [hoursBack] - How many hours to look back
  /// [hoursForward] - How many hours to look forward
  /// [stepHours] - Time interval between points (default: 2 hours)
  List<CurvePoint> generateDecayCurveForDose({
    required DoseEntry dose,
    required double halfLife,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
    double stepHours = 2.0,
  }) {
    final points = <CurvePoint>[];

    // Generate points from past to future
    for (
      double hour = -hoursBack.toDouble();
      hour <= hoursForward.toDouble();
      hour += stepHours
    ) {
      final timePoint = referenceTime.add(
        Duration(minutes: (hour * 60).round()),
      );

      // Calculate hours elapsed from this dose's start time
      final hoursElapsed =
          timePoint.difference(dose.startTime).inMinutes / 60.0;

      // Only calculate decay if dose was taken before this time point
      double remaining = 0.0;
      if (hoursElapsed >= 0) {
        remaining = decayRemaining(dose.dose, hoursElapsed, halfLife);
      }

      points.add(CurvePoint(hours: hour, remainingMg: remaining));
    }

    return points;
  }

  /// Generate combined decay curve for all doses of a drug
  ///
  /// This sums the decay from multiple doses taken at different times
  List<CurvePoint> generateCombinedCurve({
    required List<DoseEntry> doses,
    required double halfLife,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
    double stepHours = 2.0,
  }) {
    if (doses.isEmpty) return [];

    // Generate curves for each individual dose
    final allCurves = doses
        .map(
          (dose) => generateDecayCurveForDose(
            dose: dose,
            halfLife: halfLife,
            referenceTime: referenceTime,
            hoursBack: hoursBack,
            hoursForward: hoursForward,
            stepHours: stepHours,
          ),
        )
        .toList();

    // Sum all curves at each time point
    final combinedPoints = <CurvePoint>[];
    final numPoints = allCurves.first.length;

    for (int i = 0; i < numPoints; i++) {
      double totalRemaining = 0.0;
      final hour = allCurves.first[i].hours;

      for (final curve in allCurves) {
        totalRemaining += curve[i].remainingMg;
      }

      combinedPoints.add(CurvePoint(hours: hour, remainingMg: totalRemaining));
    }

    return combinedPoints;
  }

  /// Normalize dose in mg to intensity percentage (0-100%)
  /// Uses dosage thresholds where "strong" dose = 100%
  ///
  /// [doseMg] - Dose amount in milligrams
  /// [drugName] - Drug name for threshold lookup
  /// [drugProfile] - Optional drug profile with formatted_dose data
  double normalizeToIntensity(
    double doseMg,
    String drugName, {
    Map<String, dynamic>? drugProfile,
  }) {
    if (doseMg <= 0) return 0.0;

    // Try to get thresholds from drug profile first
    List<double>? thresholds;
    if (drugProfile != null) {
      thresholds = DrugProfileUtils.getDosageThresholds(drugProfile);
    }

    // Fall back to known thresholds
    thresholds ??= DrugProfileUtils.getFallbackThresholds(drugName);

    if (thresholds == null || thresholds[3] == 0) {
      // No threshold data available, cap at 200%
      return doseMg.clamp(0.0, 200.0);
    }

    final heavyThreshold = thresholds[4]; // "heavy" is the 100% baseline
    if (heavyThreshold <= 0) return doseMg.clamp(0.0, 200.0);

    final normalized = (doseMg / heavyThreshold) * 100.0;

    // Allow values above 100% for heavy doses, but cap at 200%
    return normalized.clamp(0.0, 200.0);
  }

  /// Generate normalized intensity curve for multiple doses
  /// Returns CurvePoints with intensity percentage (0-100%) instead of mg
  List<CurvePoint> generateNormalizedCurve({
    required List<DoseEntry> doses,
    required double halfLife,
    required DateTime referenceTime,
    required int hoursBack,
    required int hoursForward,
    required String drugName,
    Map<String, dynamic>? drugProfile,
    double stepHours = 2.0,
  }) {
    // First generate the combined curve in mg
    final mgCurve = generateCombinedCurve(
      doses: doses,
      halfLife: halfLife,
      referenceTime: referenceTime,
      hoursBack: hoursBack,
      hoursForward: hoursForward,
      stepHours: stepHours,
    );

    // Then normalize each point to intensity percentage
    return mgCurve.map((point) {
      final intensity = normalizeToIntensity(
        point.remainingMg,
        drugName,
        drugProfile: drugProfile,
      );
      return CurvePoint(hours: point.hours, remainingMg: intensity);
    }).toList();
  }
}
