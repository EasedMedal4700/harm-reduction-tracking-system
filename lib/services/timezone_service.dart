class TimezoneService {
  /// Returns the user's timezone offset in hours from UTC (e.g., +5.5 for IST).
  double getTimezoneOffset() {
    return DateTime.now().timeZoneOffset.inMinutes / 60.0;
  }

  /// Returns the offset as a string (e.g., "+05:30").
  String getTimezoneOffsetString() {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60).abs();
    final sign = offset.isNegative ? '-' : '+';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}