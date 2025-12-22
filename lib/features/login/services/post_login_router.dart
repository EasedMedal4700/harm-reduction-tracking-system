// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Central post-login routing incl. encryption & PIN.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/encryption_migration_service.dart';
import '../../../services/encryption_service_v2.dart';
import '../../../providers/core_providers.dart';

final postLoginRouterProvider = Provider<PostLoginRouter>(
  (ref) => PostLoginRouter(ref),
);

class PostLoginRouter {
  PostLoginRouter(this._ref);
  final Ref _ref;

  Future<void> routeAfterLogin({required bool debug}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      goToLogin();
      return;
    }

    final migrationService = EncryptionMigrationService();
    if (await migrationService.needsMigration(user.id)) {
      goToEncryptionMigration();
      return;
    }

    final encryptionService = EncryptionServiceV2();
    if (!await encryptionService.hasEncryptionSetup(user.id)) {
      goToPinSetup();
      return;
    }

    if (!debug &&
        await _ref
            .read(appLockControllerProvider.notifier)
            .shouldRequirePinNow()) {
      goToPinUnlock();
      return;
    }

    goToHome();
  }

  // ---------------------------------------------------------------------------
  // Routes (temporary, GoRouter-ready)
  // ---------------------------------------------------------------------------

  void goToHome() =>
      _ref.read(navigationProvider).replace('/home_page');

  void goToLogin() =>
      _ref.read(navigationProvider).replace('/login_page');

  void goToPinSetup() =>
      _ref.read(navigationProvider).replace('/pin-setup');

  void goToPinUnlock() =>
      _ref.read(navigationProvider).replace('/pin-unlock');

  void goToEncryptionMigration() =>
      _ref.read(navigationProvider).replace('/encryption-migration');

  void goToOnboarding() =>
      _ref.read(navigationProvider).replace('/onboarding');
}
