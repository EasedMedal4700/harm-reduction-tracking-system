// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Data model.
/// Represents a single point on the metabolism decay curve
class CurvePoint {
  /// Time offset in hours relative to "now" (negative = past, positive = future)
  final double hours;

  /// Amount of drug remaining in mg
  final double remainingMg;
  const CurvePoint({required this.hours, required this.remainingMg});

  /// Calculate percentage based on original dose
  double percentOf(double originalDose) {
    if (originalDose <= 0) return 0.0;
    return (remainingMg / originalDose) * 100;
  }

  @override
  String toString() => 'CurvePoint(hours: $hours, mg: $remainingMg)';
}
