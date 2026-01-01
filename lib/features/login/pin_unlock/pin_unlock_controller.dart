// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Owns PIN unlock flow, auth checks, encryption, and navigation.
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service_v2.dart';
import 'package:mobile_drug_use_app/features/debug/services/debug_config.dart';
import 'pin_unlock_state.dart';

part 'pin_unlock_controller.g.dart';

@riverpod
class PinUnlockController extends _$PinUnlockController {
  EncryptionServiceV2 get _encryption => ref.read(encryptionServiceProvider);
  NavigationService get _nav => ref.read(navigationProvider);

  @override
  PinUnlockState build() {
    return const PinUnlockState();
  }

  // ---------------------------
  // Lifecycle
  // ---------------------------
  Future<void> onInit() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _nav.replace('/login_page');
      return;
    }
    final biometrics = await _encryption.isBiometricsEnabled();
    state = state.copyWith(
      isCheckingAuth: false,
      biometricsAvailable: biometrics,
    );
    await _tryDebugAutoUnlock(user.id);
  }

  // ---------------------------
  // Actions
  // ---------------------------
  Future<void> submitPin(String pin) async {
    if (pin.length != 6) {
      state = state.copyWith(errorMessage: 'PIN must be 6 digits');
      return;
    }
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _nav.replace('/login_page');
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    final success = await _encryption.unlockWithPin(user.id, pin);
    if (!success) {
      state = state.copyWith(isLoading: false, errorMessage: 'Incorrect PIN');
      return;
    }
    await ref.read(appLockControllerProvider.notifier).recordUnlock();
    _nav.replace('/home_page');
  }

  Future<void> unlockWithBiometrics() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      _nav.replace('/login_page');
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    final success = await _encryption.unlockWithBiometrics(user.id);
    if (!success) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Biometric authentication failed',
      );
      return;
    }
    await ref.read(appLockControllerProvider.notifier).recordUnlock();
    _nav.replace('/home_page');
  }

  void togglePinVisibility() {
    state = state.copyWith(pinObscured: !state.pinObscured);
  }

  void openRecoveryKey() {
    _nav.push('/recovery-key');
  }

  // ---------------------------
  // Debug
  // ---------------------------
  Future<void> _tryDebugAutoUnlock(String userId) async {
    if (!DebugConfig.instance.isAutoLoginEnabled) return;
    final pin = DebugConfig.instance.debugPin;
    if (pin == null || pin.isEmpty) return;
    state = state.copyWith(isLoading: true);
    final success = await _encryption.unlockWithPin(userId, pin);
    if (!success) {
      state = state.copyWith(isLoading: false);
      return;
    }
    await ref.read(appLockControllerProvider.notifier).recordUnlock();
    _nav.replace('/home_page');
  }
}
