import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/logging/app_log.dart';
import 'encryption_service_v2.dart';

/// Centralized security manager that handles PIN timeout logic with:
/// - lastUnlockTime: when user actually entered PIN
/// - lastInteractionTime: any meaningful user interaction
/// - Debouncing to prevent rapid lock/unlock cycles
/// - Guards to prevent concurrent lock/unlock operations
class SecurityManager {
  static final SecurityManager _instance = SecurityManager._internal();
  factory SecurityManager() => _instance;
  SecurityManager._internal();
  // Storage keys
  static const String _keyLastUnlockTime = 'security_last_unlock_time';
  static const String _keyLastInteractionTime =
      'security_last_interaction_time';
  static const String _keyBackgroundStartTime =
      'security_background_start_time';
  static const String _keyForegroundTimeout =
      'security_foreground_timeout_minutes';
  static const String _keyBackgroundTimeout =
      'security_background_timeout_minutes';
  // Default timeouts (in minutes)
  static const int defaultForegroundTimeout = 5;
  static const int defaultBackgroundTimeout = 60;
  // Debounce settings
  static const Duration _debounceInterval = Duration(milliseconds: 500);
  static const Duration _minBackgroundDuration = Duration(seconds: 1);
  // State
  SharedPreferences? _prefs;
  bool _isLockingOrUnlocking = false;
  DateTime? _lastLifecycleEvent;
  bool _isInBackground = false;
  Timer? _backgroundLockTimer;
  final EncryptionServiceV2 _encryptionService = EncryptionServiceV2();
  // Callbacks for navigation
  VoidCallback? onPinRequired;
  VoidCallback? onUnlocked;

  /// Initialize the security manager
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    AppLog.i('🔒 SecurityManager initialized');
  }

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ============================================
  // Timeout Settings
  // ============================================
  Future<int> getForegroundTimeout() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyForegroundTimeout) ?? defaultForegroundTimeout;
  }

  Future<void> setForegroundTimeout(int minutes) async {
    final prefs = await _preferences;
    await prefs.setInt(_keyForegroundTimeout, minutes.clamp(1, 60));
  }

  Future<int> getBackgroundTimeout() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyBackgroundTimeout) ?? defaultBackgroundTimeout;
  }

  Future<void> setBackgroundTimeout(int minutes) async {
    final prefs = await _preferences;
    await prefs.setInt(_keyBackgroundTimeout, minutes.clamp(1, 1440));
  }

  // ============================================
  // Timestamp Management
  // ============================================
  /// Record that user just unlocked with PIN
  Future<void> recordUnlock() async {
    final prefs = await _preferences;
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyLastUnlockTime, now);
    await prefs.setInt(_keyLastInteractionTime, now);
    await prefs.remove(_keyBackgroundStartTime);
    _isInBackground = false;
    AppLog.i('🔓 [SecurityManager] Unlock recorded at ${DateTime.now()}');
  }

  /// Record user interaction (extend session)
  Future<void> recordInteraction() async {
    final prefs = await _preferences;
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(_keyLastInteractionTime, now);
    // Don't log every interaction to reduce spam
  }

  /// Get the most recent activity time (max of unlock and interaction)
  Future<DateTime> _getLastActivityTime() async {
    final prefs = await _preferences;
    final lastUnlock = prefs.getInt(_keyLastUnlockTime);
    final lastInteraction = prefs.getInt(_keyLastInteractionTime);
    final unlockTime = lastUnlock != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlock)
        : DateTime(2000);
    final interactionTime = lastInteraction != null
        ? DateTime.fromMillisecondsSinceEpoch(lastInteraction)
        : DateTime(2000);
    return unlockTime.isAfter(interactionTime) ? unlockTime : interactionTime;
  }

  /// Check if PIN is required based on both unlock and interaction times
  Future<bool> shouldRequirePin() async {
    final prefs = await _preferences;
    // Check if ever unlocked
    final lastUnlock = prefs.getInt(_keyLastUnlockTime);
    if (lastUnlock == null) {
      return true; // Never unlocked
    }
    final now = DateTime.now();
    final lastActivity = await _getLastActivityTime();
    final foregroundTimeout = await getForegroundTimeout();
    final timeSinceActivity = now.difference(lastActivity);
    // Check foreground timeout (based on last activity)
    if (timeSinceActivity.inMinutes >= foregroundTimeout) {
      return true;
    }
    // Check background timeout if applicable
    final backgroundStart = prefs.getInt(_keyBackgroundStartTime);
    if (backgroundStart != null) {
      final backgroundDuration = now.millisecondsSinceEpoch - backgroundStart;
      final backgroundTimeout = await getBackgroundTimeout();
      final backgroundTimeoutMs = backgroundTimeout * 60 * 1000;
      if (backgroundDuration > backgroundTimeoutMs) {
        return true;
      }
    }
    return false;
  }

  /// Get time remaining until PIN is required (in seconds)
  Future<int> getTimeRemaining() async {
    final now = DateTime.now();
    final lastActivity = await _getLastActivityTime();
    final foregroundTimeout = await getForegroundTimeout();
    final timeoutMs = foregroundTimeout * 60 * 1000;
    final timeSinceActivity = now.difference(lastActivity).inMilliseconds;
    final remaining = timeoutMs - timeSinceActivity;
    return remaining > 0 ? (remaining / 1000).round() : 0;
  }

  // ============================================
  // Lifecycle Event Handling (with debounce)
  // ============================================
  /// Handle app going to background
  Future<void> handleBackgroundStart() async {
    // Debounce: ignore if we just processed a lifecycle event
    final now = DateTime.now();
    if (_lastLifecycleEvent != null &&
        now.difference(_lastLifecycleEvent!) < _debounceInterval) {
      return;
    }
    _lastLifecycleEvent = now;
    // Already in background? Skip
    if (_isInBackground) return;
    _isInBackground = true;
    // Record background start time
    final prefs = await _preferences;
    await prefs.setInt(_keyBackgroundStartTime, now.millisecondsSinceEpoch);
    AppLog.i('📱 [SecurityManager] Background started at $now');
    // Cancel any existing timer
    _backgroundLockTimer?.cancel();
    // Schedule potential lock after minimum background duration
    _backgroundLockTimer = Timer(_minBackgroundDuration, () async {
      if (_isInBackground) {
        // App is still in background after delay, we can consider locking
        // But we don't actually lock until foreground resume check
        AppLog.i(
          '📱 [SecurityManager] App confirmed in background for ${_minBackgroundDuration.inSeconds}s',
        );
      }
    });
    // Lock encryption service (but don't navigate yet)
    _encryptionService.lock();
  }

  /// Handle app coming to foreground
  Future<void> handleForegroundResume() async {
    // Debounce: ignore if we just processed a lifecycle event
    final now = DateTime.now();
    if (_lastLifecycleEvent != null &&
        now.difference(_lastLifecycleEvent!) < _debounceInterval) {
      return;
    }
    _lastLifecycleEvent = now;
    // Cancel background timer
    _backgroundLockTimer?.cancel();
    _backgroundLockTimer = null;
    // Already in foreground? Skip
    if (!_isInBackground) return;
    _isInBackground = false;
    // Guard against concurrent operations
    if (_isLockingOrUnlocking) {
      AppLog.w(
        '🔒 [SecurityManager] Skip foreground handling - operation in progress',
      );
      return;
    }
    _isLockingOrUnlocking = true;
    try {
      // Check if user is authenticated
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        AppLog.i('🔒 [SecurityManager] No user, skipping PIN check');
        return;
      }
      // Check if user has encryption setup
      final hasEncryption = await _encryptionService.hasEncryptionSetup(
        user.id,
      );
      if (!hasEncryption) {
        AppLog.i(
          '🔒 [SecurityManager] No encryption setup, skipping PIN check',
        );
        return;
      }
      // Check if PIN is required
      final pinRequired = await shouldRequirePin();
      if (pinRequired) {
        AppLog.i('🔐 [SecurityManager] PIN required - navigating to unlock');
        onPinRequired?.call();
      } else {
        // Update interaction time and clear background time
        final prefs = await _preferences;
        await prefs.remove(_keyBackgroundStartTime);
        await recordInteraction();
        AppLog.i('✅ [SecurityManager] PIN not required, session extended');
        onUnlocked?.call();
      }
    } catch (e) {
      AppLog.e('⚠️ [SecurityManager] Error handling foreground: $e');
      // On error, require PIN for safety
      onPinRequired?.call();
    } finally {
      _isLockingOrUnlocking = false;
    }
  }

  /// Clear all state (call on logout)
  Future<void> clearState() async {
    final prefs = await _preferences;
    await prefs.remove(_keyLastUnlockTime);
    await prefs.remove(_keyLastInteractionTime);
    await prefs.remove(_keyBackgroundStartTime);
    _isInBackground = false;
    _backgroundLockTimer?.cancel();
    _backgroundLockTimer = null;
    _encryptionService.lock();
    AppLog.i('🔐 [SecurityManager] State cleared');
  }

  /// Check if currently in a lock/unlock operation
  bool get isProcessing => _isLockingOrUnlocking;

  /// Get current settings as a map
  Future<Map<String, dynamic>> getSettings() async {
    final prefs = await _preferences;
    return {
      'foregroundTimeout': await getForegroundTimeout(),
      'backgroundTimeout': await getBackgroundTimeout(),
      'lastUnlockTime': prefs.getInt(_keyLastUnlockTime),
      'lastInteractionTime': prefs.getInt(_keyLastInteractionTime),
      'isInBackground': _isInBackground,
    };
  }
}

/// Global singleton instance
final securityManager = SecurityManager();
