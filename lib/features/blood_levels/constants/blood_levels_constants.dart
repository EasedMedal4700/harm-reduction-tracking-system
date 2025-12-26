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
}
