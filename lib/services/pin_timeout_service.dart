import 'package:shared_preferences/shared_preferences.dart';
import '../common/logging/app_log.dart';

/// Service to manage PIN timeout settings and state.
///
/// Controls when the user needs to re-enter their PIN based on:
/// - Time since last unlock (foreground timeout)
/// - Time app has been in background (background timeout)
/// - Maximum session duration (auto-lock after X minutes of use)
///
/// NOTE: This service delegates to SecurityManager for core logic.
/// Use SecurityManager directly for lifecycle handling.
class PinTimeoutService {
  static const String _keyLastUnlockTime = 'pin_last_unlock_time';
  static const String _keyBackgroundTime = 'pin_background_time';
  static const String _keyForegroundTimeout = 'pin_foreground_timeout_minutes';
  static const String _keyBackgroundTimeout = 'pin_background_timeout_minutes';
  static const String _keyMaxSessionDuration = 'pin_max_session_minutes';
  static const String _keySessionStartTime = 'pin_session_start_time';

  // Default values (in minutes)
  static const int defaultForegroundTimeout =
      5; // Re-enter PIN after 5 min inactive
  static const int defaultBackgroundTimeout =
      60; // Re-enter PIN after 60 min in background
  static const int defaultMaxSessionDuration =
      480; // Auto-lock after 8 hours (0 = disabled)

  // Min/max values for settings
  static const int minTimeout = 1;
  static const int maxForegroundTimeout = 60;
  static const int maxBackgroundTimeout = 1440; // 24 hours
  static const int maxSessionDuration = 1440; // 24 hours

  SharedPreferences? _prefs;

  /// Initialize the service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensure prefs are loaded
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ============================================
  // Timeout Settings (persisted)
  // ============================================

  /// Get foreground timeout in minutes (time since last activity before requiring PIN)
  Future<int> getForegroundTimeout() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyForegroundTimeout) ?? defaultForegroundTimeout;
  }

  /// Set foreground timeout in minutes
  Future<void> setForegroundTimeout(int minutes) async {
    final prefs = await _preferences;
    final clamped = minutes.clamp(minTimeout, maxForegroundTimeout);
    await prefs.setInt(_keyForegroundTimeout, clamped);
  }

  /// Get background timeout in minutes (time in background before requiring PIN)
  Future<int> getBackgroundTimeout() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyBackgroundTimeout) ?? defaultBackgroundTimeout;
  }

  /// Set background timeout in minutes
  Future<void> setBackgroundTimeout(int minutes) async {
    final prefs = await _preferences;
    final clamped = minutes.clamp(minTimeout, maxBackgroundTimeout);
    await prefs.setInt(_keyBackgroundTimeout, clamped);
  }

  /// Get max session duration in minutes (0 = disabled)
  Future<int> getMaxSessionDuration() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyMaxSessionDuration) ?? defaultMaxSessionDuration;
  }

  /// Set max session duration in minutes (0 = disabled)
  Future<void> setMaxSessionDuration(int minutes) async {
    final prefs = await _preferences;
    final clamped = minutes.clamp(0, maxSessionDuration);
    await prefs.setInt(_keyMaxSessionDuration, clamped);
  }

  // ============================================
  // Unlock State Management
  // ============================================

  /// Record that the user just unlocked with their PIN
  Future<void> recordUnlock() async {
    final prefs = await _preferences;
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyLastUnlockTime, now);
    await prefs.setInt(_keySessionStartTime, now);
    await prefs.remove(_keyBackgroundTime); // Clear background time
    AppLog.i('🔓 PIN unlock recorded at ${DateTime.now()}');
  }

  /// Record when app goes to background
  Future<void> recordBackgroundStart() async {
    final prefs = await _preferences;
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyBackgroundTime, now);
    AppLog.i('📱 App went to background at ${DateTime.now()}');
  }

  /// Record when app comes to foreground (update last activity)
  Future<void> recordForegroundResume() async {
    final prefs = await _preferences;
    await prefs.remove(_keyBackgroundTime);
    AppLog.i('📱 App resumed to foreground at ${DateTime.now()}');
  }

  /// Check if PIN is required based on timeouts
  /// Returns true if user needs to enter PIN
  Future<bool> isPinRequired() async {
    final prefs = await _preferences;

    final lastUnlock = prefs.getInt(_keyLastUnlockTime);
    if (lastUnlock == null) {
      AppLog.i('🔐 PIN required: Never unlocked');
      return true; // Never unlocked
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final lastUnlockTime = DateTime.fromMillisecondsSinceEpoch(lastUnlock);

    // Check max session duration
    final sessionStart = prefs.getInt(_keySessionStartTime);
    final maxSession = await getMaxSessionDuration();
    if (maxSession > 0 && sessionStart != null) {
      final sessionDuration = now - sessionStart;
      final maxSessionMs = maxSession * 60 * 1000;
      if (sessionDuration > maxSessionMs) {
        AppLog.i(
          '🔐 PIN required: Max session duration exceeded (${maxSession}min)',
        );
        return true;
      }
    }

    // Check background timeout
    final backgroundStart = prefs.getInt(_keyBackgroundTime);
    if (backgroundStart != null) {
      final backgroundDuration = now - backgroundStart;
      final backgroundTimeout = await getBackgroundTimeout();
      final backgroundTimeoutMs = backgroundTimeout * 60 * 1000;
      if (backgroundDuration > backgroundTimeoutMs) {
        AppLog.i(
          '🔐 PIN required: Background timeout exceeded (${backgroundTimeout}min)',
        );
        return true;
      }
    }

    // Check foreground timeout (time since last unlock/activity)
    final timeSinceUnlock = now - lastUnlock;
    final foregroundTimeout = await getForegroundTimeout();
    final foregroundTimeoutMs = foregroundTimeout * 60 * 1000;
    if (timeSinceUnlock > foregroundTimeoutMs) {
      AppLog.i(
        '🔐 PIN required: Foreground timeout exceeded (${foregroundTimeout}min)',
      );
      return true;
    }

    final remaining = ((foregroundTimeoutMs - timeSinceUnlock) / 1000 / 60)
        .round();
    AppLog.d(
      '✅ PIN not required. Last unlock: $lastUnlockTime, ${remaining}min remaining',
    );
    return false;
  }

  /// Clear all unlock state (call on logout)
  Future<void> clearState() async {
    final prefs = await _preferences;
    await prefs.remove(_keyLastUnlockTime);
    await prefs.remove(_keyBackgroundTime);
    await prefs.remove(_keySessionStartTime);
    AppLog.i('🔐 PIN timeout state cleared');
  }

  /// Get time remaining until PIN is required (in seconds)
  /// Returns 0 if PIN is already required
  Future<int> getTimeRemaining() async {
    final prefs = await _preferences;

    final lastUnlock = prefs.getInt(_keyLastUnlockTime);
    if (lastUnlock == null) return 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    final foregroundTimeout = await getForegroundTimeout();
    final foregroundTimeoutMs = foregroundTimeout * 60 * 1000;

    final timeSinceUnlock = now - lastUnlock;
    final remaining = foregroundTimeoutMs - timeSinceUnlock;

    return remaining > 0 ? (remaining / 1000).round() : 0;
  }

  /// Get all current settings as a map
  Future<Map<String, int>> getSettings() async {
    return {
      'foregroundTimeout': await getForegroundTimeout(),
      'backgroundTimeout': await getBackgroundTimeout(),
      'maxSessionDuration': await getMaxSessionDuration(),
    };
  }

  /// Update all settings at once
  Future<void> updateSettings({
    int? foregroundTimeout,
    int? backgroundTimeout,
    int? maxSessionDuration,
  }) async {
    if (foregroundTimeout != null) {
      await setForegroundTimeout(foregroundTimeout);
    }
    if (backgroundTimeout != null) {
      await setBackgroundTimeout(backgroundTimeout);
    }
    if (maxSessionDuration != null) {
      await setMaxSessionDuration(maxSessionDuration);
    }
  }
}

/// Global singleton instance
final pinTimeoutService = PinTimeoutService();
