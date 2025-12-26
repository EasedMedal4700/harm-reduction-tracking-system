import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mobile_drug_use_app/common/logging/logger.dart';
import 'package:mobile_drug_use_app/features/setup_account/models/recovery_key_state.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';

part 'recovery_key_controller.g.dart';

const int kRecoveryKeyLength = 24;
const int kPinLength = 6;

@riverpod
class RecoveryKeyController extends _$RecoveryKeyController {
  @override
  RecoveryKeyState build() => const RecoveryKeyState();

  void toggleKeyObscure() =>
      state = state.copyWith(keyObscure: !state.keyObscure);
  void togglePinObscure() =>
      state = state.copyWith(pinObscure: !state.pinObscure);
  void toggleConfirmPinObscure() =>
      state = state.copyWith(confirmPinObscure: !state.confirmPinObscure);

  void backToRecoveryKeyEntry() {
    state = state.copyWith(
      recoveryKeyValidated: false,
      validatedRecoveryKey: null,
      errorMessage: null,
    );
  }

  Future<bool> validateRecoveryKey(String recoveryKeyRaw) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final recoveryKey = recoveryKeyRaw.trim();
      if (recoveryKey.isEmpty) {
        throw Exception('Please enter your recovery key');
      }
      if (recoveryKey.length != kRecoveryKeyLength) {
        throw Exception('Recovery key must be $kRecoveryKeyLength characters');
      }

      final client = ref.read(supabaseClientProvider);
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final encryption = ref.read(encryptionServiceProvider);
      final success = await encryption.unlockWithRecoveryKey(
        user.id,
        recoveryKey,
      );
      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid recovery key. Please check and try again.',
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        recoveryKeyValidated: true,
        validatedRecoveryKey: recoveryKey,
      );
      return true;
    } catch (e, st) {
      logger.error(
        'RecoveryKeyController.validateRecoveryKey failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> resetPin({
    required String newPinRaw,
    required String confirmPinRaw,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final validatedRecoveryKey = state.validatedRecoveryKey;
      if (validatedRecoveryKey == null || validatedRecoveryKey.isEmpty) {
        throw Exception('Recovery key not validated');
      }

      final newPin = newPinRaw.trim();
      final confirmPin = confirmPinRaw.trim();

      if (newPin.isEmpty) {
        throw Exception('Please enter a new PIN');
      }
      if (newPin.length != kPinLength) {
        throw Exception('PIN must be exactly $kPinLength digits');
      }
      if (!RegExp(r'^\d{6}$').hasMatch(newPin)) {
        throw Exception('PIN must contain only numbers');
      }
      if (newPin != confirmPin) {
        throw Exception('PINs do not match');
      }

      final client = ref.read(supabaseClientProvider);
      final user = client.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      final encryption = ref.read(encryptionServiceProvider);
      final success = await encryption.resetPinWithRecoveryKey(
        user.id,
        validatedRecoveryKey,
        newPin,
      );

      if (!success) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to reset PIN. Please try again.',
        );
        return false;
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e, st) {
      logger.error(
        'RecoveryKeyController.resetPin failed',
        error: e,
        stackTrace: st,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}
