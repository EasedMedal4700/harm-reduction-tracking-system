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
  
  /// Whether auto-login is enabled (from .env DEBUG_AUTO_LOGIN)
  bool get isAutoLoginEnabled {
    final value = dotenv.env['DEBUG_AUTO_LOGIN']?.toLowerCase();
    final enabled = value == 'true' || value == '1';
    if (enabled) {
      developer.log('⚠️ DEBUG AUTO-LOGIN IS ENABLED - DO NOT USE IN PRODUCTION!', 
        name: 'DebugConfig');
    }
    return enabled;
  }
  
  /// Debug email for auto-login
  String? get debugEmail => dotenv.env['DEBUG_EMAIL'];
  
  /// Debug password for auto-login
  String? get debugPassword => dotenv.env['DEBUG_PASSWORD'];
  
  /// Debug PIN for auto-unlock
  String? get debugPin => dotenv.env['DEBUG_PIN'];
  
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
      developer.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'DebugConfig');
      developer.log('⚠️  DEBUG MODE ENABLED', name: 'DebugConfig');
      developer.log('⚠️  Auto-login: $debugEmail', name: 'DebugConfig');
      developer.log('⚠️  Auto-PIN unlock enabled', name: 'DebugConfig');
      developer.log('⚠️  SET DEBUG_AUTO_LOGIN=false FOR PRODUCTION!', name: 'DebugConfig');
      developer.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━', name: 'DebugConfig');
    }
  }
}
