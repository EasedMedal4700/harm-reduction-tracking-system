// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Constants.
class GraphConstants {
  // Private constructor to prevent instantiation
  const GraphConstants._();

  /// Time interval between points in decay graphs (default: 2 hours)
  static const double defaultStepHours = 2.0;

  /// Width of bars in charts
  static const double defaultBarWidth = 3.0;
  static const double thinBarWidth = 2.5;

  /// Smoothness of curves in charts
  static const double defaultCurveSmoothness = 0.3;
}
