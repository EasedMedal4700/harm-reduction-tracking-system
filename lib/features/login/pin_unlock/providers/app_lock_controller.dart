// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Service.
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/core/providers/shared_preferences_provider.dart';

@immutable
class AppLockState {
  const AppLockState({
    required this.requiresPin,
    required this.lastUnlockAt,
    required this.backgroundStartedAt,
    required this.gracePeriod,
  });
  final bool requiresPin;
  final DateTime? lastUnlockAt;
  final DateTime? backgroundStartedAt;
  final Duration gracePeriod;
  AppLockState copyWith({
    bool? requiresPin,
    DateTime? lastUnlockAt,
    DateTime? backgroundStartedAt,
    Duration? gracePeriod,
  }) {
    return AppLockState(
      requiresPin: requiresPin ?? this.requiresPin,
      lastUnlockAt: lastUnlockAt ?? this.lastUnlockAt,
      backgroundStartedAt: backgroundStartedAt ?? this.backgroundStartedAt,
      gracePeriod: gracePeriod ?? this.gracePeriod,
    );
  }
}

class AppLockController extends Notifier<AppLockState> {
  // Reuse existing keys from PinTimeoutService for compatibility.
  static const String _keyLastUnlockTimeMs = 'pin_last_unlock_time';
  // New key: last user activity time (extends session while actively using app).
  static const String _keyLastInteractionTimeMs = 'pin_last_interaction_time';
  static const String _keyBackgroundTimeMs = 'pin_background_time';
  static const String _keyForegroundTimeoutMinutes =
      'pin_foreground_timeout_minutes';
  static const int _minGraceMinutes = 5;
  @override
  AppLockState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final lastUnlockMs = prefs.getInt(_keyLastUnlockTimeMs);
    final lastInteractionMs = prefs.getInt(_keyLastInteractionTimeMs);
    final backgroundMs = prefs.getInt(_keyBackgroundTimeMs);
    final lastUnlockAt = lastUnlockMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlockMs)
        : null;
    final lastInteractionAt = lastInteractionMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastInteractionMs)
        : null;
    final backgroundStartedAt = backgroundMs != null
        ? DateTime.fromMillisecondsSinceEpoch(backgroundMs)
        : null;
    final gracePeriod = _readGracePeriod(prefs);
    final lastActivityAt = _lastActivity(lastUnlockAt, lastInteractionAt);
    final requiresPin = _computeRequiresPin(
      now: DateTime.now(),
      lastUnlockAt: lastActivityAt,
      gracePeriod: gracePeriod,
    );
    return AppLockState(
      requiresPin: requiresPin,
      lastUnlockAt: lastUnlockAt,
      backgroundStartedAt: backgroundStartedAt,
      gracePeriod: gracePeriod,
    );
  }

  DateTime? _lastActivity(DateTime? lastUnlockAt, DateTime? lastInteractionAt) {
    if (lastUnlockAt == null) return lastInteractionAt;
    if (lastInteractionAt == null) return lastUnlockAt;
    return lastUnlockAt.isAfter(lastInteractionAt)
        ? lastUnlockAt
        : lastInteractionAt;
  }

  Duration _readGracePeriod(SharedPreferences prefs) {
    final minutes =
        prefs.getInt(_keyForegroundTimeoutMinutes) ?? _minGraceMinutes;
    final clamped = minutes < _minGraceMinutes ? _minGraceMinutes : minutes;
    return Duration(minutes: clamped);
  }

  bool _computeRequiresPin({
    required DateTime now,
    required DateTime? lastUnlockAt,
    required Duration gracePeriod,
  }) {
    if (lastUnlockAt == null) return true;
    return now.difference(lastUnlockAt) >= gracePeriod;
  }

  Future<void> recordUnlock({DateTime? at}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final when = at ?? DateTime.now();
    await prefs.setInt(_keyLastUnlockTimeMs, when.millisecondsSinceEpoch);
    await prefs.setInt(_keyLastInteractionTimeMs, when.millisecondsSinceEpoch);
    await prefs.remove(_keyBackgroundTimeMs);
    state = state.copyWith(
      requiresPin: false,
      lastUnlockAt: when,
      backgroundStartedAt: null,
      gracePeriod: _readGracePeriod(prefs),
    );
  }

  Future<void> onBackgroundStart({DateTime? at}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final when = at ?? DateTime.now();
    await prefs.setInt(_keyBackgroundTimeMs, when.millisecondsSinceEpoch);
    // Consider the moment the app backgrounds as the last meaningful activity.
    // This prevents requiring a PIN after long active sessions when the user
    // briefly switches apps and returns.
    await prefs.setInt(_keyLastInteractionTimeMs, when.millisecondsSinceEpoch);
    state = state.copyWith(
      backgroundStartedAt: when,
      gracePeriod: _readGracePeriod(prefs),
    );
  }

  Future<void> onForegroundResume({DateTime? now}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final when = now ?? DateTime.now();
    final lastUnlockMs = prefs.getInt(_keyLastUnlockTimeMs);
    final lastInteractionMs = prefs.getInt(_keyLastInteractionTimeMs);
    final lastUnlockAt = lastUnlockMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlockMs)
        : null;
    final lastInteractionAt = lastInteractionMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastInteractionMs)
        : null;
    final gracePeriod = _readGracePeriod(prefs);
    final lastActivityAt = _lastActivity(lastUnlockAt, lastInteractionAt);
    final requiresPin = _computeRequiresPin(
      now: when,
      lastUnlockAt: lastActivityAt,
      gracePeriod: gracePeriod,
    );

    if (!requiresPin) {
      // Extend session on successful resume.
      await prefs.setInt(_keyLastInteractionTimeMs, when.millisecondsSinceEpoch);
    }

    await prefs.remove(_keyBackgroundTimeMs);
    state = state.copyWith(
      requiresPin: requiresPin,
      lastUnlockAt: lastUnlockAt,
      backgroundStartedAt: null,
      gracePeriod: gracePeriod,
    );
  }

  Future<void> clear() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_keyLastUnlockTimeMs);
    await prefs.remove(_keyLastInteractionTimeMs);
    await prefs.remove(_keyBackgroundTimeMs);
    state = AppLockState(
      requiresPin: true,
      lastUnlockAt: null,
      backgroundStartedAt: null,
      gracePeriod: _readGracePeriod(prefs),
    );
  }

  Future<bool> shouldRequirePinNow() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final lastUnlockMs = prefs.getInt(_keyLastUnlockTimeMs);
    final lastInteractionMs = prefs.getInt(_keyLastInteractionTimeMs);
    final lastUnlockAt = lastUnlockMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlockMs)
        : null;
    final lastInteractionAt = lastInteractionMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastInteractionMs)
        : null;
    final gracePeriod = _readGracePeriod(prefs);
    final lastActivityAt = _lastActivity(lastUnlockAt, lastInteractionAt);
    return _computeRequiresPin(
      now: DateTime.now(),
      lastUnlockAt: lastActivityAt,
      gracePeriod: gracePeriod,
    );
  }
}
