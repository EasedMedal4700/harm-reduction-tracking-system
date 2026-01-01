// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
// Represents a single point on the metabolism decay curve
import 'package:freezed_annotation/freezed_annotation.dart';

part 'curve_point.freezed.dart';

@freezed
abstract class CurvePoint with _$CurvePoint {
  const factory CurvePoint({
    /// Time offset in hours relative to "now" (negative = past, positive = future)
    required double hours,

    /// Amount of drug remaining in mg
    required double remainingMg,
  }) = _CurvePoint;

  const CurvePoint._();

  /// Calculate percentage based on original dose
  double percentOf(double originalDose) {
    if (originalDose <= 0) return 0.0;
    return (remainingMg / originalDose) * 100;
  }
}
