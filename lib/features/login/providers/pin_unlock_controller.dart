// // MIGRATION:
// // State: MODERN
// // Navigation: CENTRALIZED
// // Models: FREEZED
// // Theme: N/A
// // Common: N/A
// // Notes: Handles PIN unlock, biometrics, debug auto-unlock, and auth checks.

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../services/post_login_router.dart';
// import '../../services/encryption_service_v2.dart';
// import '../../services/debug_config.dart';
// import '../../providers/core_providers.dart';
// import 'pin_unlock_state.dart';

// final pinUnlockControllerProvider =
//     StateNotifierProvider<PinUnlockController, PinUnlockState>(
//   (ref) => PinUnlockController(
//     ref,
//     encryptionService: ref.read(encryptionServiceProvider),
//     postLoginRouter: ref.read(postLoginRouterProvider),
//   ),
// );

// class PinUnlockController extends StateNotifier<PinUnlockState> {
//   PinUnlockController(
//     this.ref, {
//     required EncryptionServiceV2 encryptionService,
//     required PostLoginRouter postLoginRouter,
//   })  : _encryptionService = encryptionService,
//         _postLoginRouter = postLoginRouter,
//         super(const PinUnlockState());

//   final Ref ref;
//   final EncryptionServiceV2 _encryptionService;
//   final PostLoginRouter _postLoginRouter;

//   /// Called once when screen is shown
//   Future<void> initialize() async {
//     try {
//       final user = Supabase.instance.client.auth.currentUser;
//       if (user == null) {
//         _postLoginRouter.toLogin();
//         return;
//       }

//       final biometrics = await _encryptionService.isBiometricsEnabled();

//       state = state.copyWith(
//         isCheckingAuth: false,
//         biometricsAvailable: biometrics,
//       );

//       await _tryDebugAutoUnlock(user.id);
//     } catch (e) {
//       _postLoginRouter.toLogin();
//     }
//   }

//   Future<void> unlockWithPin(String pin) async {
//     if (pin.length != 6) {
//       state = state.copyWith(errorMessage: 'PIN must be exactly 6 digits');
//       return;
//     }

//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final user = Supabase.instance.client.auth.currentUser;
//       if (user == null) {
//         _postLoginRouter.toLogin();
//         return;
//       }

//       final success = await _encryptionService.unlockWithPin(user.id, pin);

//       if (!success) {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: 'Incorrect PIN. Please try again.',
//         );
//         return;
//       }

//       await ref.read(appLockControllerProvider.notifier).recordUnlock();
//       _postLoginRouter.toHome();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Unlock failed. Please try again.',
//       );
//     }
//   }

//   Future<void> unlockWithBiometrics() async {
//     state = state.copyWith(isLoading: true, errorMessage: null);

//     try {
//       final user = Supabase.instance.client.auth.currentUser;
//       if (user == null) {
//         _postLoginRouter.toLogin();
//         return;
//       }

//       final success =
//           await _encryptionService.unlockWithBiometrics(user.id);

//       if (!success) {
//         state = state.copyWith(
//           isLoading: false,
//           errorMessage: 'Biometric authentication failed.',
//         );
//         return;
//       }

//       await ref.read(appLockControllerProvider.notifier).recordUnlock();
//       _postLoginRouter.toHome();
//     } catch (_) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: 'Biometric unlock failed.',
//       );
//     }
//   }

//   Future<void> _tryDebugAutoUnlock(String userId) async {
//     if (!DebugConfig.instance.isAutoLoginEnabled) return;

//     final pin = DebugConfig.instance.debugPin;
//     if (pin == null || pin.isEmpty) return;

//     final success = await _encryptionService.unlockWithPin(userId, pin);
//     if (success) {
//       await ref.read(appLockControllerProvider.notifier).recordUnlock();
//       _postLoginRouter.toHome();
//     }
//   }
// }
