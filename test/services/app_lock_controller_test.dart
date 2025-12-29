import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';

void main() {
  late ProviderContainer container;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AppLockController', () {
    test('initial state requires pin by default if no history', () {
      final state = container.read(appLockControllerProvider);
      expect(state.requiresPin, true);
      expect(state.lastUnlockAt, isNull);
      expect(state.backgroundStartedAt, isNull);
    });

    test('recordUnlock updates state and storage', () async {
      final controller = container.read(appLockControllerProvider.notifier);
      final now = DateTime.now();

      await controller.recordUnlock(at: now);

      final state = container.read(appLockControllerProvider);
      expect(state.requiresPin, false);
      expect(state.lastUnlockAt, now);

      // Verify storage
      expect(prefs.getInt('pin_last_unlock_time'), now.millisecondsSinceEpoch);
    });

    test('onBackgroundStart updates state and storage', () async {
      final controller = container.read(appLockControllerProvider.notifier);
      final now = DateTime.now();

      await controller.onBackgroundStart(at: now);

      final state = container.read(appLockControllerProvider);
      expect(state.backgroundStartedAt, now);

      // Verify storage
      expect(prefs.getInt('pin_background_time'), now.millisecondsSinceEpoch);
    });

    test('onForegroundResume requires pin if grace period exceeded', () async {
      final controller = container.read(appLockControllerProvider.notifier);

      // Unlock 10 minutes ago
      final lastUnlock = DateTime.now().subtract(const Duration(minutes: 10));
      await controller.recordUnlock(at: lastUnlock);

      // Default grace period is 5 mins (or min 5 mins)
      // So 10 mins ago should require pin

      await controller.onForegroundResume();

      final state = container.read(appLockControllerProvider);
      expect(state.requiresPin, true);
    });

    test(
      'onForegroundResume does NOT require pin if within grace period',
      () async {
        final controller = container.read(appLockControllerProvider.notifier);

        // Unlock 2 minutes ago
        final lastUnlock = DateTime.now().subtract(const Duration(minutes: 2));
        await controller.recordUnlock(at: lastUnlock);

        await controller.onForegroundResume();

        final state = container.read(appLockControllerProvider);
        expect(state.requiresPin, false);
      },
    );

    test('clear resets state', () async {
      final controller = container.read(appLockControllerProvider.notifier);
      await controller.recordUnlock();

      await controller.clear();

      final state = container.read(appLockControllerProvider);
      expect(state.requiresPin, true);
      expect(state.lastUnlockAt, isNull);

      expect(prefs.containsKey('pin_last_unlock_time'), false);
    });

    test('shouldRequirePinNow returns correct value', () async {
      final controller = container.read(appLockControllerProvider.notifier);

      // Initially true
      expect(await controller.shouldRequirePinNow(), true);

      // Unlock recently
      await controller.recordUnlock();
      expect(await controller.shouldRequirePinNow(), false);

      // Simulate time passing (by manually modifying prefs)
      final oldTime = DateTime.now().subtract(const Duration(minutes: 10));
      await prefs.setInt(
        'pin_last_unlock_time',
        oldTime.millisecondsSinceEpoch,
      );

      expect(await controller.shouldRequirePinNow(), true);
    });

    test('respects custom grace period', () async {
      // Set grace period to 15 mins
      await prefs.setInt('pin_foreground_timeout_minutes', 15);

      // Re-create container to pick up new prefs value in build()
      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final controller = container.read(appLockControllerProvider.notifier);

      // Unlock 10 minutes ago
      final lastUnlock = DateTime.now().subtract(const Duration(minutes: 10));
      await controller.recordUnlock(at: lastUnlock);

      // Should NOT require pin because 10 < 15
      await controller.onForegroundResume();

      final state = container.read(appLockControllerProvider);
      expect(state.requiresPin, false);
    });

    test('enforces minimum grace period', () async {
      // Set grace period to 1 min (below min of 5)
      await prefs.setInt('pin_foreground_timeout_minutes', 1);

      // Re-create container
      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      final controller = container.read(appLockControllerProvider.notifier);

      // Unlock 3 minutes ago
      final lastUnlock = DateTime.now().subtract(const Duration(minutes: 3));
      await controller.recordUnlock(at: lastUnlock);

      // Should NOT require pin because 3 < 5 (min)
      await controller.onForegroundResume();

      final state = container.read(appLockControllerProvider);
      expect(state.requiresPin, false);
    });
  });
}
