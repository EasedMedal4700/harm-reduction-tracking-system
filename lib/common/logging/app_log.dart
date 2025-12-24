import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class AppLog {
  static bool get _debugEnabled => !kReleaseMode;

  static void d(String message) {
    if (_debugEnabled) {
      dev.log(message, name: 'DEBUG');
    }
  }

  static void i(String message) {
    dev.log(message, name: 'INFO');
  }

  static void w(String message) {
    dev.log(message, name: 'WARN');
  }

  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    dev.log(
      message,
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
