import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';

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
  static const String _keyBackgroundTimeMs = 'pin_background_time';
  static const String _keyForegroundTimeoutMinutes =
      'pin_foreground_timeout_minutes';

  static const int _minGraceMinutes = 5;

  @override
  AppLockState build() {
    final prefs = ref.watch(sharedPreferencesProvider);

    final lastUnlockMs = prefs.getInt(_keyLastUnlockTimeMs);
    final backgroundMs = prefs.getInt(_keyBackgroundTimeMs);

    final lastUnlockAt = lastUnlockMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlockMs)
        : null;
    final backgroundStartedAt = backgroundMs != null
        ? DateTime.fromMillisecondsSinceEpoch(backgroundMs)
        : null;

    final gracePeriod = _readGracePeriod(prefs);
    final requiresPin = _computeRequiresPin(
      now: DateTime.now(),
      lastUnlockAt: lastUnlockAt,
      gracePeriod: gracePeriod,
    );

    return AppLockState(
      requiresPin: requiresPin,
      lastUnlockAt: lastUnlockAt,
      backgroundStartedAt: backgroundStartedAt,
      gracePeriod: gracePeriod,
    );
  }

  Duration _readGracePeriod(SharedPreferences prefs) {
    final minutes = prefs.getInt(_keyForegroundTimeoutMinutes) ?? _minGraceMinutes;
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

    state = state.copyWith(
      backgroundStartedAt: when,
      gracePeriod: _readGracePeriod(prefs),
    );
  }

  Future<void> onForegroundResume({DateTime? now}) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final when = now ?? DateTime.now();

    final lastUnlockMs = prefs.getInt(_keyLastUnlockTimeMs);
    final lastUnlockAt = lastUnlockMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlockMs)
        : null;

    final gracePeriod = _readGracePeriod(prefs);
    final requiresPin = _computeRequiresPin(
      now: when,
      lastUnlockAt: lastUnlockAt,
      gracePeriod: gracePeriod,
    );

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
    await prefs.remove(_keyBackgroundTimeMs);

    state = state.copyWith(
      requiresPin: true,
      lastUnlockAt: null,
      backgroundStartedAt: null,
      gracePeriod: _readGracePeriod(prefs),
    );
  }

  Future<bool> shouldRequirePinNow() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final lastUnlockMs = prefs.getInt(_keyLastUnlockTimeMs);
    final lastUnlockAt = lastUnlockMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlockMs)
        : null;
    final gracePeriod = _readGracePeriod(prefs);

    return _computeRequiresPin(
      now: DateTime.now(),
      lastUnlockAt: lastUnlockAt,
      gracePeriod: gracePeriod,
    );
  }
}
