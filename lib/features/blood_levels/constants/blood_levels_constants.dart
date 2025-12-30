// MIGRATION:
// State: MODERN (UI-only)
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: LEGACY
// Common: LEGACY
// Notes: Feature-level constants (non-UI).
class BloodLevelsConstants {
  BloodLevelsConstants._();

  static const int timeMachinePastDays = 365;
  static const int timeMachineFutureDays = 30;

  static const int defaultChartHoursBack = 24;
  static const int defaultChartHoursForward = 24;
  static const bool defaultAdaptiveScale = true;
  static const bool defaultShowTimeline = true;

  /// Hard guard for the timeline controls input.
  static const int maxTimelineHours = 168;

  // Charts / graphs
  static const int chartAxisLabelHoursStep = 6;
  static const double chartMinY = 0;
  static const double chartMaxY = 120;

  static const double chartGridHorizontalInterval = 20;
  static const double chartAxisLeftReservedSize = 45;
  static const double chartAxisBottomReservedSize = 32;

  // Timeline chart config
  static const double timelineBottomReservedSize = 24;
  static const double timelineBottomIntervalHours = 24;
  static const double timelineLeftReservedSize = 40;
  static const double timelineNowLineOpacity = 0.5;
  static const double timelineGridLineOpacity = 0.25;
  static const int timelineNowDashOn = 5;
  static const int timelineNowDashOff = 5;
  static const double timelineAdaptiveScaleMultiplier = 1.3;
  static const double timelineAdaptiveScaleMinY = 20;
  static const double timelineAdaptiveScaleMaxY = 200;
  static const double timelineFixedScaleMinY = 100;
}
