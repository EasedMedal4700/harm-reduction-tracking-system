// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod controller for Home screen orchestration.
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/logging/logger.dart';
import '../../../core/providers/navigation_provider.dart';
import '../../../core/routes/app_router.dart' show AppRoutePaths;
import '../../../core/services/encryption_service_v2.dart';
import '../../../core/services/user_service.dart';
import '../models/home_state.dart';

part 'home_providers.g.dart';

@Riverpod()
class HomeController extends _$HomeController {
  late final EncryptionServiceV2 _encryptionService;
  late final UserService _userService;

  @override
  HomeState build() {
    _encryptionService = EncryptionServiceV2();
    _userService = UserService();
    return const HomeState();
  }

  Future<void> initialize() async {
    await _checkEncryptionStatus();
    await _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final profile = await _userService.loadUserProfile();
      state = state.copyWith(userName: profile.displayName, isLoading: false);
    } catch (e, st) {
      logger.warning('[HomeController] loadUserProfile failed: $e');
      logger.debug('[HomeController] loadUserProfile stack: $st');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _checkEncryptionStatus() async {
    try {
      final userId = UserService.getCurrentUserId();
      final hasEncryption = await _encryptionService.hasEncryptionSetup(userId);
      if (hasEncryption && !_encryptionService.isReady) {
        ref.read(navigationProvider).replace(AppRoutePaths.pinUnlock);
      }
    } catch (e, st) {
      logger.warning('[HomeController] checkEncryptionStatus failed: $e');
      logger.debug('[HomeController] checkEncryptionStatus stack: $st');
    }
  }

  void openProfile() {
    ref.read(navigationProvider).push(AppRoutePaths.profile);
  }

  void openAdminPanel() {
    ref.read(navigationProvider).push(AppRoutePaths.adminPanel);
  }

  void openDailyCheckin() {
    ref.read(navigationProvider).push(AppRoutePaths.dailyCheckin);
  }

  void openLogEntry() {
    ref.read(navigationProvider).push(AppRoutePaths.logEntry);
  }

  void openAnalytics() {
    ref.read(navigationProvider).push(AppRoutePaths.analytics);
  }

  void openCatalog() {
    ref.read(navigationProvider).push(AppRoutePaths.catalog);
  }

  void openCravings() {
    ref.read(navigationProvider).push(AppRoutePaths.cravings);
  }

  void openBloodLevels() {
    ref.read(navigationProvider).push(AppRoutePaths.bloodLevels);
  }

  void openReflection() {
    ref.read(navigationProvider).push(AppRoutePaths.reflection);
  }

  void openActivity() {
    ref.read(navigationProvider).push(AppRoutePaths.activity);
  }

  void openLibrary() {
    ref.read(navigationProvider).push(AppRoutePaths.library);
  }

  void openToleranceDashboard() {
    ref.read(navigationProvider).push(AppRoutePaths.toleranceDashboard);
  }
}
