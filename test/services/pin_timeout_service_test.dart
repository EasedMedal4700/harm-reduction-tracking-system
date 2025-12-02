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
    });
  });
}
