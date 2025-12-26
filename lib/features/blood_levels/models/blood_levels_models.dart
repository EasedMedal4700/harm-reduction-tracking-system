// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Feature model.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_levels_models.freezed.dart';

@freezed
class DoseEntry with _$DoseEntry {
  const factory DoseEntry({
    required double dose,
    required DateTime startTime,
    required double remaining,
    required double hoursElapsed,
    @Default(0.0) double percentRemaining,
  }) = _DoseEntry;
}

@freezed
class DrugLevel with _$DrugLevel {
  const DrugLevel._();

  const factory DrugLevel({
    required String drugName,
    required double totalDose,
    required double totalRemaining,
    required double lastDose,
    required DateTime lastUse,
    required double halfLife,
    required List<DoseEntry> doses,
    @Default(8.0) double activeWindow,
    @Default(6.0) double maxDuration,
    @Default(<String>[]) List<String> categories,
    Map<String, dynamic>? formattedDose,
  }) = _DrugLevel;

  /// Overall percentage remaining across all doses combined.
  double get percentage =>
      totalDose > 0 ? (totalRemaining / totalDose) * 100 : 0.0;

  /// Status at a given reference time (supports "time machine").
  String statusAt(DateTime referenceTime) {
    final hoursSinceLastUse =
        referenceTime.difference(lastUse).inMinutes / 60.0;
    final inAftereffects = hoursSinceLastUse > maxDuration;

    if (percentage > 40) return 'HIGH';
    if (percentage >= 10) return 'ACTIVE';
    if (inAftereffects && hoursSinceLastUse <= activeWindow) return 'TRACE';
    return 'LOW';
  }
}
