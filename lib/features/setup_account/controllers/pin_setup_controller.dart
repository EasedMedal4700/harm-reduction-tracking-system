import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:mobile_drug_use_app/features/setup_account/models/pin_setup_state.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';

part 'pin_setup_controller.g.dart';

const int kPinLength = 6;

@riverpod
class PinSetupController extends _$PinSetupController {
  @override
  PinSetupState build() => const PinSetupState();

  void togglePin1Obscure() {
    state = state.copyWith(pin1Obscure: !state.pin1Obscure);
  }

  void togglePin2Obscure() {
    state = state.copyWith(pin2Obscure: !state.pin2Obscure);
  }

  void clearError() {
    if (state.errorMessage == null) return;
    state = state.copyWith(errorMessage: null);
  }

  Future<void> setupEncryption({
    required String pin1,
    required String pin2,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      if (pin1.length != kPinLength) {
        throw Exception('PIN must be exactly $kPinLength digits');
      }
      if (pin1 != pin2) {
        throw Exception('PINs do not match');
      }

      final client = ref.read(supabaseClientProvider);
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final encryption = ref.read(encryptionServiceProvider);
      final recoveryKey = await encryption.setupNewSecrets(user.id, pin1);

      state = state.copyWith(
        isLoading: false,
        showRecoveryKey: true,
        recoveryKey: recoveryKey,
      );
    } catch (e, st) {
      logger.warning('PinSetupController.setupEncryption failed: $e');
      logger.error(
        'PinSetupController.setupEncryption stack',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<bool> enableBiometrics(String pin) async {
    try {
      final encryption = ref.read(encryptionServiceProvider);
      await encryption.enableBiometrics(pin);
      return true;
    } catch (e, st) {
      logger.error(
        'PinSetupController.enableBiometrics failed',
        error: e,
        stackTrace: st,
      );
      return false;
    }
  }

  Future<void> recordUnlock() async {
    await ref.read(appLockControllerProvider.notifier).recordUnlock();
  }
}
