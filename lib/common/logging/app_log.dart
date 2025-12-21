// lib/common/logging/app_log.dart
import 'dart:developer' as dev;

/// Centralized application logging
/// Usage:
/// log.d('[BUILD] Widget rebuilt');
/// log.i('[UI] Button pressed');
/// log.w('[DATA] Unexpected empty result');
/// log.e('[STATE] Impossible state reached');

class log {
  static void d(String message) {
    dev.log(message, name: 'DEBUG');
  }

  static void i(String message) {
    dev.log(message, name: 'INFO');
  }

  static void w(String message) {
    dev.log(message, name: 'WARN');
  }

  static void e(String message) {
    dev.log(message, name: 'ERROR');
  }
}
