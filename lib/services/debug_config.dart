import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

/// Debug configuration for auto-login during development
///
/// IMPORTANT: Set DEBUG_AUTO_LOGIN=false in .env before releasing to production!
class DebugConfig {
  static DebugConfig? _instance;

  static DebugConfig get instance {
    _instance ??= DebugConfig._();
    return _instance!;
  }

  DebugConfig._();

  /// Helper to safely get env value, returns null if dotenv not initialized
  String? _getEnv(String key) {
    try {
      return dotenv.env[key];
    } catch (e) {
      // dotenv not initialized (e.g., in tests)
      return null;
    }
  }

  /// Whether debug mode is enabled (from .env DEBUG_MODE)
  /// This controls visibility of debug features in the UI
  bool get isDebugMode {
    final value = _getEnv('DEBUG_MODE')?.toLowerCase();
    return value == 'true' || value == '1';
  }

  /// Whether auto-login is enabled (from .env DEBUG_AUTO_LOGIN)
  bool get isAutoLoginEnabled {
    final value = _getEnv('DEBUG_AUTO_LOGIN')?.toLowerCase();
    final enabled = value == 'true' || value == '1';
    if (enabled) {
      developer.log(
        '⚠️ DEBUG AUTO-LOGIN IS ENABLED - DO NOT USE IN PRODUCTION!',
        name: 'DebugConfig',
      );
    }
    return enabled;
  }

  /// Debug email for auto-login
  String? get debugEmail => _getEnv('DEBUG_EMAIL');

  /// Debug password for auto-login
  String? get debugPassword => _getEnv('DEBUG_PASSWORD');

  /// Debug PIN for auto-unlock
  String? get debugPin => _getEnv('DEBUG_PIN');

  /// Check if all debug credentials are configured
  bool get hasValidCredentials {
    return debugEmail != null &&
        debugEmail!.isNotEmpty &&
        debugPassword != null &&
        debugPassword!.isNotEmpty &&
        debugPin != null &&
        debugPin!.isNotEmpty;
  }

  /// Log debug config status (call once at startup)
  void logStatus() {
    if (isAutoLoginEnabled) {
      developer.log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        name: 'DebugConfig',
      );
      developer.log('⚠️  DEBUG MODE ENABLED', name: 'DebugConfig');
      developer.log('⚠️  Auto-login: $debugEmail', name: 'DebugConfig');
      developer.log('⚠️  Auto-PIN unlock enabled', name: 'DebugConfig');
      developer.log(
        '⚠️  SET DEBUG_AUTO_LOGIN=false FOR PRODUCTION!',
        name: 'DebugConfig',
      );
      developer.log(
        '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
        name: 'DebugConfig',
      );
    }
  }
}
