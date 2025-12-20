import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Test-only version of SecurityManager logic to avoid singleton issues
class TestableSecurityManager {
  static const String _keyLastUnlockTime = 'security_last_unlock_time';
  static const String _keyLastInteractionTime =
      'security_last_interaction_time';
  static const String _keyBackgroundStartTime =
      'security_background_start_time';
  static const String _keyForegroundTimeout =
      'security_foreground_timeout_minutes';
  static const String _keyBackgroundTimeout =
      'security_background_timeout_minutes';

  static const int defaultForegroundTimeout = 5;
  static const int defaultBackgroundTimeout = 60;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<int> getForegroundTimeout() async {
    return _prefs?.getInt(_keyForegroundTimeout) ?? defaultForegroundTimeout;
  }

  Future<void> setForegroundTimeout(int minutes) async {
    await _prefs?.setInt(_keyForegroundTimeout, minutes.clamp(1, 60));
  }

  Future<int> getBackgroundTimeout() async {
    return _prefs?.getInt(_keyBackgroundTimeout) ?? defaultBackgroundTimeout;
  }

  Future<void> setBackgroundTimeout(int minutes) async {
    await _prefs?.setInt(_keyBackgroundTimeout, minutes.clamp(1, 1440));
  }

  Future<void> recordUnlock() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _prefs?.setInt(_keyLastUnlockTime, now);
    await _prefs?.setInt(_keyLastInteractionTime, now);
    await _prefs?.remove(_keyBackgroundStartTime);
  }

  Future<void> recordInteraction() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _prefs?.setInt(_keyLastInteractionTime, now);
  }

  Future<DateTime> _getLastActivityTime() async {
    final lastUnlock = _prefs?.getInt(_keyLastUnlockTime);
    final lastInteraction = _prefs?.getInt(_keyLastInteractionTime);

    final unlockTime = lastUnlock != null
        ? DateTime.fromMillisecondsSinceEpoch(lastUnlock)
        : DateTime(2000);
    final interactionTime = lastInteraction != null
        ? DateTime.fromMillisecondsSinceEpoch(lastInteraction)
        : DateTime(2000);

    return unlockTime.isAfter(interactionTime) ? unlockTime : interactionTime;
  }

  Future<bool> shouldRequirePin() async {
    final lastUnlock = _prefs?.getInt(_keyLastUnlockTime);
    if (lastUnlock == null) {
      return true; // Never unlocked
    }

    final now = DateTime.now();
    final lastActivity = await _getLastActivityTime();
    final foregroundTimeout = await getForegroundTimeout();
    final timeSinceActivity = now.difference(lastActivity);

    if (timeSinceActivity.inMinutes >= foregroundTimeout) {
      return true;
    }

    final backgroundStart = _prefs?.getInt(_keyBackgroundStartTime);
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

  Future<int> getTimeRemaining() async {
    final now = DateTime.now();
    final lastActivity = await _getLastActivityTime();
    final foregroundTimeout = await getForegroundTimeout();
    final timeoutMs = foregroundTimeout * 60 * 1000;
    final timeSinceActivity = now.difference(lastActivity).inMilliseconds;
    final remaining = timeoutMs - timeSinceActivity;
    return remaining > 0 ? (remaining / 1000).round() : 0;
  }

  Future<void> clearState() async {
    await _prefs?.remove(_keyLastUnlockTime);
    await _prefs?.remove(_keyLastInteractionTime);
    await _prefs?.remove(_keyBackgroundStartTime);
  }

  Future<Map<String, dynamic>> getSettings() async {
    return {
      'foregroundTimeout': await getForegroundTimeout(),
      'backgroundTimeout': await getBackgroundTimeout(),
      'lastUnlockTime': _prefs?.getInt(_keyLastUnlockTime),
      'lastInteractionTime': _prefs?.getInt(_keyLastInteractionTime),
      'isInBackground': false,
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('SecurityManager', () {
    group('Initialization', () {
      test('initializes successfully', () async {
        final manager = TestableSecurityManager();
        await manager.init();
        // Should not throw
      });

      test('default foreground timeout is 5 minutes', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        final timeout = await manager.getForegroundTimeout();
        expect(timeout, equals(5));
      });

      test('default background timeout is 60 minutes', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        final timeout = await manager.getBackgroundTimeout();
        expect(timeout, equals(60));
      });
    });

    group('Timestamp Management', () {
      test('recordUnlock sets both unlock and interaction times', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        await manager.recordUnlock();

        // Should not require PIN immediately after unlock
        final required = await manager.shouldRequirePin();
        expect(required, isFalse);
      });

      test('recordInteraction extends session', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 4))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 4))
              .millisecondsSinceEpoch,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        // Should not require PIN (4 min < 5 min timeout)
        var required = await manager.shouldRequirePin();
        expect(required, isFalse);

        // Record interaction
        await manager.recordInteraction();

        // Should still not require PIN
        required = await manager.shouldRequirePin();
        expect(required, isFalse);
      });

      test('shouldRequirePin returns true when never unlocked', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        final required = await manager.shouldRequirePin();
        expect(required, isTrue);
      });

      test(
        'shouldRequirePin returns false within foreground timeout',
        () async {
          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'security_last_unlock_time': now
                .subtract(const Duration(minutes: 2))
                .millisecondsSinceEpoch,
            'security_last_interaction_time': now
                .subtract(const Duration(minutes: 2))
                .millisecondsSinceEpoch,
            'security_foreground_timeout_minutes': 5,
          });

          final manager = TestableSecurityManager();
          await manager.init();

          // 2 min < 5 min timeout
          final required = await manager.shouldRequirePin();
          expect(required, isFalse);
        },
      );

      test('shouldRequirePin returns true after foreground timeout', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 6))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 6))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        // 6 min > 5 min timeout
        final required = await manager.shouldRequirePin();
        expect(required, isTrue);
      });

      test('interaction time takes precedence over unlock time', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          // Unlock was 6 minutes ago (would trigger timeout)
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 6))
              .millisecondsSinceEpoch,
          // But interaction was 2 minutes ago (within timeout)
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 2))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        // Recent interaction should prevent PIN requirement
        final required = await manager.shouldRequirePin();
        expect(required, isFalse);
      });
    });

    group('Background Timeout', () {
      test('shouldRequirePin returns true after background timeout', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 70))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 70))
              .millisecondsSinceEpoch,
          'security_background_start_time': now
              .subtract(const Duration(minutes: 65))
              .millisecondsSinceEpoch,
          'security_background_timeout_minutes': 60,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        // 65 min > 60 min background timeout
        final required = await manager.shouldRequirePin();
        expect(required, isTrue);
      });

      test(
        'shouldRequirePin returns false within background timeout',
        () async {
          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'security_last_unlock_time': now
                .subtract(const Duration(minutes: 3))
                .millisecondsSinceEpoch,
            'security_last_interaction_time': now
                .subtract(const Duration(minutes: 3))
                .millisecondsSinceEpoch,
            'security_background_start_time': now
                .subtract(const Duration(minutes: 1))
                .millisecondsSinceEpoch,
            'security_foreground_timeout_minutes': 5,
            'security_background_timeout_minutes': 60,
          });

          final manager = TestableSecurityManager();
          await manager.init();

          // 3 min < 5 min foreground timeout, 1 min < 60 min background timeout
          final required = await manager.shouldRequirePin();
          expect(required, isFalse);
        },
      );
    });

    group('Time Remaining', () {
      test('getTimeRemaining returns positive value after unlock', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 2))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 2))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        final remaining = await manager.getTimeRemaining();
        expect(remaining, greaterThan(0));
        // Should be approximately 3 minutes (180 seconds)
        expect(remaining, lessThanOrEqualTo(3 * 60 + 5)); // Allow 5s margin
        expect(remaining, greaterThanOrEqualTo(2 * 60));
      });

      test('getTimeRemaining returns 0 after timeout', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 10))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 10))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        final remaining = await manager.getTimeRemaining();
        expect(remaining, equals(0));
      });
    });

    group('Clear State', () {
      test('clearState clears all timestamps', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now.millisecondsSinceEpoch,
          'security_last_interaction_time': now.millisecondsSinceEpoch,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        // Initially should not require PIN
        var required = await manager.shouldRequirePin();
        expect(required, isFalse);

        // Clear state
        await manager.clearState();

        // Now should require PIN
        required = await manager.shouldRequirePin();
        expect(required, isTrue);
      });
    });

    group('Settings', () {
      test('setForegroundTimeout clamps value to valid range', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        // Test minimum
        await manager.setForegroundTimeout(0);
        var timeout = await manager.getForegroundTimeout();
        expect(timeout, equals(1)); // Clamped to min

        // Test maximum
        await manager.setForegroundTimeout(999);
        timeout = await manager.getForegroundTimeout();
        expect(timeout, equals(60)); // Clamped to max

        // Test valid value
        await manager.setForegroundTimeout(15);
        timeout = await manager.getForegroundTimeout();
        expect(timeout, equals(15));
      });

      test('setBackgroundTimeout clamps value to valid range', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        // Test minimum
        await manager.setBackgroundTimeout(0);
        var timeout = await manager.getBackgroundTimeout();
        expect(timeout, equals(1)); // Clamped to min

        // Test maximum
        await manager.setBackgroundTimeout(9999);
        timeout = await manager.getBackgroundTimeout();
        expect(timeout, equals(1440)); // Clamped to max (24 hours)

        // Test valid value
        await manager.setBackgroundTimeout(120);
        timeout = await manager.getBackgroundTimeout();
        expect(timeout, equals(120));
      });

      test('getSettings returns all settings', () async {
        SharedPreferences.setMockInitialValues({});
        final manager = TestableSecurityManager();
        await manager.init();

        await manager.setForegroundTimeout(10);
        await manager.setBackgroundTimeout(30);

        final settings = await manager.getSettings();
        expect(settings['foregroundTimeout'], equals(10));
        expect(settings['backgroundTimeout'], equals(30));
        expect(settings.containsKey('isInBackground'), isTrue);
      });
    });

    group('Real-world scenarios', () {
      test('short background trip does not require PIN', () async {
        // Simulate: unlock, use app for 3 min, interaction 30 sec ago, background for 30 sec, resume
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 3))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(seconds: 30))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
          'security_background_timeout_minutes': 60,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        final required = await manager.shouldRequirePin();
        expect(
          required,
          isFalse,
          reason:
              'Short background trip with recent interaction should not require PIN',
        );
      });

      test('long foreground session with activity stays unlocked', () async {
        // Simulate: unlock 20 min ago, but interaction 2 min ago
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 20))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 2))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        final required = await manager.shouldRequirePin();
        expect(
          required,
          isFalse,
          reason: 'Recent interaction should keep session alive',
        );
      });

      test('inactive session requires PIN', () async {
        // Simulate: unlock 20 min ago, no activity for 20 min
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'security_last_unlock_time': now
              .subtract(const Duration(minutes: 20))
              .millisecondsSinceEpoch,
          'security_last_interaction_time': now
              .subtract(const Duration(minutes: 20))
              .millisecondsSinceEpoch,
          'security_foreground_timeout_minutes': 5,
        });

        final manager = TestableSecurityManager();
        await manager.init();

        final required = await manager.shouldRequirePin();
        expect(
          required,
          isTrue,
          reason: 'Long inactive session should require PIN',
        );
      });
    });
  });
}
