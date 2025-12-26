// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: COMPLETE
// Notes: Logging utility.
import 'app_log.dart';

/// Thin logger facade used across the app.
///
/// Prefer this over calling `AppLog` directly so call sites use a consistent API
/// (`logger.info`, `logger.error`, etc.).
class Logger {
  const Logger();

  void debug(String message) => AppLog.d(message);
  void info(String message) => AppLog.i(message);
  void warning(String message) => AppLog.w(message);
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      AppLog.e(message, error: error, stackTrace: stackTrace);
}

const logger = Logger();
