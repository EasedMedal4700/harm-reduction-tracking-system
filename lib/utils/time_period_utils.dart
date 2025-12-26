// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Utility.
import '../constants/enums/time_period.dart';

/// Utility class for time period related operations
class TimePeriodUtils {
  /// Converts a TimePeriod enum value to a human-readable text
  static String getPeriodText(TimePeriod period) {
    switch (period) {
      case TimePeriod.all:
        return 'All Time';
      case TimePeriod.last7Days:
        return 'Last 7 Days';
      case TimePeriod.last7Weeks:
        return 'Last 7 Weeks';
      case TimePeriod.last7Months:
        return 'Last 7 Months';
    }
  }
}
