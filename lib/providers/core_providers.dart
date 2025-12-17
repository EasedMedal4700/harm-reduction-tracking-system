import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/app_lock_controller.dart';
import '../services/auth_service.dart';
import '../services/encryption_service_v2.dart';
import 'shared_preferences_provider.dart';

export 'shared_preferences_provider.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final encryptionServiceProvider = Provider<EncryptionServiceV2>((ref) {
  return EncryptionServiceV2();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    client: ref.watch(supabaseClientProvider),
    encryption: ref.watch(encryptionServiceProvider),
  );
});

final appLockControllerProvider =
    NotifierProvider<AppLockController, AppLockState>(AppLockController.new);
