import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/services/pin_timeout_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('PinTimeoutService', () {
    group('Settings', () {
      test('default foreground timeout is 5 minutes', () async {
        final service = PinTimeoutService();
        await service.init();

        final timeout = await service.getForegroundTimeout();
        expect(timeout, equals(5));
      });

      test('default background timeout is 60 minutes', () async {
        final service = PinTimeoutService();
        await service.init();

        final timeout = await service.getBackgroundTimeout();
        expect(timeout, equals(60));
      });

      test('default max session duration is 480 minutes (8 hours)', () async {
        final service = PinTimeoutService();
        await service.init();

        final duration = await service.getMaxSessionDuration();
        expect(duration, equals(480));
      });

      test('setForegroundTimeout persists value', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.setForegroundTimeout(10);
        final timeout = await service.getForegroundTimeout();
        expect(timeout, equals(10));
      });

      test('setForegroundTimeout clamps to max', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.setForegroundTimeout(999);
        final timeout = await service.getForegroundTimeout();
        expect(timeout, equals(60)); // maxForegroundTimeout
      });

      test('setForegroundTimeout clamps to min', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.setForegroundTimeout(0);
        final timeout = await service.getForegroundTimeout();
        expect(timeout, equals(1)); // minTimeout
      });

      test('setBackgroundTimeout persists value', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.setBackgroundTimeout(120);
        final timeout = await service.getBackgroundTimeout();
        expect(timeout, equals(120));
      });

      test('setMaxSessionDuration allows 0 (disabled)', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.setMaxSessionDuration(0);
        final duration = await service.getMaxSessionDuration();
        expect(duration, equals(0));
      });

      test('getSettings returns all settings', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.setForegroundTimeout(10);
        await service.setBackgroundTimeout(30);
        await service.setMaxSessionDuration(120);

        final settings = await service.getSettings();
        expect(settings['foregroundTimeout'], equals(10));
        expect(settings['backgroundTimeout'], equals(30));
        expect(settings['maxSessionDuration'], equals(120));
      });

      test('updateSettings updates multiple values', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.updateSettings(
          foregroundTimeout: 15,
          backgroundTimeout: 45,
          maxSessionDuration: 240,
        );

        expect(await service.getForegroundTimeout(), equals(15));
        expect(await service.getBackgroundTimeout(), equals(45));
        expect(await service.getMaxSessionDuration(), equals(240));
      });
    });

    group('Unlock State', () {
      test('isPinRequired returns true when never unlocked', () async {
        final service = PinTimeoutService();
        await service.init();

        final required = await service.isPinRequired();
        expect(required, isTrue);
      });

      test('isPinRequired returns false immediately after unlock', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.recordUnlock();
        final required = await service.isPinRequired();
        expect(required, isFalse);
      });

      test('clearState makes isPinRequired return true', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.recordUnlock();
        expect(await service.isPinRequired(), isFalse);

        await service.clearState();
        expect(await service.isPinRequired(), isTrue);
      });

      test('getTimeRemaining returns positive value after unlock', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.recordUnlock();
        final remaining = await service.getTimeRemaining();
        expect(remaining, greaterThan(0));
      });

      test('getTimeRemaining returns 0 when never unlocked', () async {
        final service = PinTimeoutService();
        await service.init();

        final remaining = await service.getTimeRemaining();
        expect(remaining, equals(0));
      });
    });

    group('Background Handling', () {
      test('recordBackgroundStart sets background time', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.recordUnlock();
        await service.recordBackgroundStart();

        // Should still be valid immediately
        final required = await service.isPinRequired();
        expect(required, isFalse);
      });

      test('recordForegroundResume clears background time', () async {
        final service = PinTimeoutService();
        await service.init();

        await service.recordUnlock();
        await service.recordBackgroundStart();
        await service.recordForegroundResume();

        final required = await service.isPinRequired();
        expect(required, isFalse);
      });
    });

    group('Timeout Expiry', () {
      test('isPinRequired returns true after foreground timeout', () async {
        // Set a very short timeout for testing
        SharedPreferences.setMockInitialValues({
          'pin_foreground_timeout_minutes': 0, // Will be clamped to 1
          'pin_last_unlock_time': DateTime.now()
              .subtract(const Duration(minutes: 10))
              .millisecondsSinceEpoch,
          'pin_session_start_time': DateTime.now()
              .subtract(const Duration(minutes: 10))
              .millisecondsSinceEpoch,
        });

        final service = PinTimeoutService();
        await service.init();

        // Even with 1 min timeout, 10 min old unlock should require PIN
        final required = await service.isPinRequired();
        expect(required, isTrue);
      });

      test('isPinRequired returns false within foreground timeout', () async {
        // Simulate unlock 2 minutes ago with default 5-minute timeout
        SharedPreferences.setMockInitialValues({
          'pin_foreground_timeout_minutes': 5,
          'pin_last_unlock_time': DateTime.now()
              .subtract(const Duration(minutes: 2))
              .millisecondsSinceEpoch,
          'pin_session_start_time': DateTime.now()
              .subtract(const Duration(minutes: 2))
              .millisecondsSinceEpoch,
        });

        final service = PinTimeoutService();
        await service.init();

        // 2 min < 5 min timeout, should NOT require PIN
        final required = await service.isPinRequired();
        expect(required, isFalse);
      });

      test(
        'isPinRequired returns true after foreground timeout at 5 minutes',
        () async {
          // Simulate unlock 6 minutes ago with default 5-minute timeout
          SharedPreferences.setMockInitialValues({
            'pin_foreground_timeout_minutes': 5,
            'pin_last_unlock_time': DateTime.now()
                .subtract(const Duration(minutes: 6))
                .millisecondsSinceEpoch,
            'pin_session_start_time': DateTime.now()
                .subtract(const Duration(minutes: 6))
                .millisecondsSinceEpoch,
          });

          final service = PinTimeoutService();
          await service.init();

          // 6 min > 5 min timeout, should require PIN
          final required = await service.isPinRequired();
          expect(required, isTrue);
        },
      );

      test(
        'isPinRequired returns true when foreground timeout exceeded even with background',
        () async {
          // Simulate: unlocked 5 min 1 sec ago, went to background 2 min ago
          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'pin_foreground_timeout_minutes': 5,
            'pin_background_timeout_minutes': 60,
            'pin_last_unlock_time': now
                .subtract(const Duration(minutes: 5, seconds: 1))
                .millisecondsSinceEpoch,
            'pin_session_start_time': now
                .subtract(const Duration(minutes: 5, seconds: 1))
                .millisecondsSinceEpoch,
            'pin_background_time': now
                .subtract(const Duration(minutes: 2))
                .millisecondsSinceEpoch,
          });

          final service = PinTimeoutService();
          await service.init();

          // Background time is only 2 min, which is < 60 min background timeout
          // But foreground time (5min 1sec) exceeds timeout, so should require PIN
          final required = await service.isPinRequired();
          expect(
            required,
            isTrue,
            reason:
                'Foreground timeout exceeded (5min 1sec > 5min), PIN should be required',
          );
        },
      );

      test(
        'short background trip should not require PIN before foreground timeout',
        () async {
          // Key test case: User unlocks, uses app for 3 min, goes to background
          // for 1 min, comes back. Total time from unlock is 4 min < 5 min timeout.
          // After recordForegroundResume, the lastUnlockTime gets updated.

          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'pin_foreground_timeout_minutes': 5,
            'pin_background_timeout_minutes': 60,
            // Unlock was 4 minutes ago
            'pin_last_unlock_time': now
                .subtract(const Duration(minutes: 4))
                .millisecondsSinceEpoch,
            'pin_session_start_time': now
                .subtract(const Duration(minutes: 4))
                .millisecondsSinceEpoch,
            // Went to background 1 minute ago (so 1 min in background)
            'pin_background_time': now
                .subtract(const Duration(minutes: 1))
                .millisecondsSinceEpoch,
          });

          final service = PinTimeoutService();
          await service.init();

          // 4 min since unlock < 5 min foreground timeout
          // 1 min in background < 60 min background timeout
          final required = await service.isPinRequired();
          expect(
            required,
            isFalse,
            reason:
                'Should not require PIN: 4min < 5min foreground timeout, 1min < 60min background timeout',
          );
        },
      );

      test(
        'isPinRequired returns true after background timeout (over 60 min)',
        () async {
          // Simulate: went to background 65 minutes ago
          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'pin_foreground_timeout_minutes': 5,
            'pin_background_timeout_minutes': 60,
            // Unlock was long ago
            'pin_last_unlock_time': now
                .subtract(const Duration(minutes: 70))
                .millisecondsSinceEpoch,
            'pin_session_start_time': now
                .subtract(const Duration(minutes: 70))
                .millisecondsSinceEpoch,
            // Went to background 65 minutes ago
            'pin_background_time': now
                .subtract(const Duration(minutes: 65))
                .millisecondsSinceEpoch,
          });

          final service = PinTimeoutService();
          await service.init();

          // 65 min > 60 min background timeout, should require PIN
          final required = await service.isPinRequired();
          expect(
            required,
            isTrue,
            reason: 'Should require PIN: 65min > 60min background timeout',
          );
        },
      );

      test(
        'isPinRequired returns false when background time is under 60 min',
        () async {
          // Simulate: went to background 30 minutes ago (well under 60 min limit)
          // But foreground time is old - background should be checked first
          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'pin_foreground_timeout_minutes': 5,
            'pin_background_timeout_minutes': 60,
            // Unlock was 35 minutes ago
            'pin_last_unlock_time': now
                .subtract(const Duration(minutes: 35))
                .millisecondsSinceEpoch,
            'pin_session_start_time': now
                .subtract(const Duration(minutes: 35))
                .millisecondsSinceEpoch,
            // Went to background 30 minutes ago
            'pin_background_time': now
                .subtract(const Duration(minutes: 30))
                .millisecondsSinceEpoch,
          });

          final service = PinTimeoutService();
          await service.init();

          // Background time (30 min) < 60 min timeout, should NOT trigger background timeout
          // BUT foreground time (35 min) > 5 min timeout, so foreground check should trigger
          final required = await service.isPinRequired();
          expect(
            required,
            isTrue,
            reason: 'Foreground timeout should still apply: 35min > 5min',
          );
        },
      );

      test(
        'recordForegroundResume extends session for subsequent checks',
        () async {
          final now = DateTime.now();
          SharedPreferences.setMockInitialValues({
            'pin_foreground_timeout_minutes': 5,
            'pin_background_timeout_minutes': 60,
            // Original unlock was 4 minutes ago
            'pin_last_unlock_time': now
                .subtract(const Duration(minutes: 4))
                .millisecondsSinceEpoch,
            'pin_session_start_time': now
                .subtract(const Duration(minutes: 4))
                .millisecondsSinceEpoch,
          });

          final service = PinTimeoutService();
          await service.init();

          // First check - should not require PIN (4 min < 5 min)
          var required = await service.isPinRequired();
          expect(required, isFalse);

          // Simulate coming back from background - this updates lastUnlockTime to now
          await service.recordForegroundResume();

          // Now even though original unlock was 4+ min ago,
          // the session was extended by recordForegroundResume
          required = await service.isPinRequired();
          expect(
            required,
            isFalse,
            reason: 'recordForegroundResume should have extended the session',
          );
        },
      );

      test('max session duration triggers PIN requirement', () async {
        final now = DateTime.now();
        SharedPreferences.setMockInitialValues({
          'pin_foreground_timeout_minutes': 5,
          'pin_background_timeout_minutes': 60,
          'pin_max_session_minutes': 60, // 1 hour max session
          // Unlock was recently
          'pin_last_unlock_time': now
              .subtract(const Duration(minutes: 1))
              .millisecondsSinceEpoch,
          // But session started 65 minutes ago (exceeds max)
          'pin_session_start_time': now
              .subtract(const Duration(minutes: 65))
              .millisecondsSinceEpoch,
        });

        final service = PinTimeoutService();
        await service.init();

        // Even though last activity was recent, max session exceeded
        final required = await service.isPinRequired();
        expect(
          required,
          isTrue,
          reason: 'Max session duration (65min > 60min) should require PIN',
        );
      });
    });
  });
}
