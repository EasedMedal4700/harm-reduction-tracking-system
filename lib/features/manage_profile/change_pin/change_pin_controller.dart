// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Owns Change PIN orchestration, validation, encryption, and navigation intent.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/core/services/encryption_service_v2.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';
import 'package:mobile_drug_use_app/core/providers/encryption_providers.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'change_pin_state.dart';

/// Riverpod provider for the Change PIN controller.
///
/// All dependencies are injected:
/// - encryption
/// - navigation
/// - auth access
final changePinControllerProvider =
    StateNotifierProvider<ChangePinController, ChangePinState>(
      (ref) => ChangePinController(
        encryptionService: ref.read(encryptionServiceProvider),
        navigationService: ref.read(navigationProvider),
      ),
    );

/// Controller responsible for:
/// - Validating PIN input
/// - Performing encryption key re-wrapping
/// - Handling success / error states
/// - Emitting navigation intent
class ChangePinController extends StateNotifier<ChangePinState> {
  ChangePinController({
    required EncryptionServiceV2 encryptionService,
    required NavigationService navigationService,
  }) : _encryptionService = encryptionService,
       _navigationService = navigationService,
       super(const ChangePinState());
  final EncryptionServiceV2 _encryptionService;
  final NavigationService _navigationService;

  /// Public entry point from the UI.
  ///
  /// Widgets must call THIS method only.
  /// Widgets may not validate, encrypt, or navigate.
  Future<void> submit({
    required String oldPin,
    required String newPin,
    required String confirmPin,
  }) async {
    // Reset previous error
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      _validatePins(oldPin: oldPin, newPin: newPin, confirmPin: confirmPin);
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('Not authenticated');
      }
      final success = await _encryptionService.changePin(
        user.id,
        oldPin,
        newPin,
      );
      if (!success) {
        throw Exception('Current PIN is incorrect');
      }
      // Success state
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      // User-facing error
      state = state.copyWith(isLoading: false, errorMessage: _humanizeError(e));
    }
  }

  /// Called when user presses "Done" on success screen.
  ///
  /// Navigation is centralized and abstracted.
  void close() {
    _navigationService.pop();
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------
  void _validatePins({
    required String oldPin,
    required String newPin,
    required String confirmPin,
  }) {
    if (oldPin.length != 6) {
      throw Exception('Current PIN must be exactly 6 digits');
    }
    if (newPin.length != 6) {
      throw Exception('New PIN must be exactly 6 digits');
    }
    if (newPin != confirmPin) {
      throw Exception('New PINs do not match');
    }
    if (oldPin == newPin) {
      throw Exception('New PIN must be different from current PIN');
    }
  }

  String _humanizeError(Object error) {
    return error.toString().replaceAll('Exception: ', '');
  }
}
