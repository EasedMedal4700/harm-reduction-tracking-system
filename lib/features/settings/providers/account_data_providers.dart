import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../services/account_data_service.dart';

final accountDataServiceProvider = Provider<AccountDataService>((ref) {
  return AccountDataService(
    supabase: ref.watch(supabaseClientProvider),
    authService: ref.watch(authServiceProvider),
  );
});
