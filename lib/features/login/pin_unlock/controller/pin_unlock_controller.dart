// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Owns PIN unlock flow, auth checks, encryption, and navigation.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../providers/navigation_provider.dart';
import '../../../../services/navigation_service.dart';
import '../../../../providers/core_providers.dart';
import '../../../../services/encryption_service_v2.dart';
import '../../../../services/debug_config.dart';

import '../state/pin_unlock_state.dart';

final pinUnlockControllerProvider =
    StateNotifierProvider<PinUnlockController, PinUnlockState>(
      (ref) => PinUnlockController(ref),
    );

class PinUnlockController extends StateNotifier<PinUnlockState> {
  PinUnlockController(this._ref) : super(const PinUnlockState());

  final Ref _ref;
  EncryptionServiceV2 get _encryption => _ref.read(encryptionServiceProvider);
  NavigationService get _nav => _ref.read(navigationProvider);

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

    await _ref.read(appLockControllerProvider.notifier).recordUnlock();
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

    await _ref.read(appLockControllerProvider.notifier).recordUnlock();
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

    await _ref.read(appLockControllerProvider.notifier).recordUnlock();
    _nav.replace('/home_page');
  }
}
