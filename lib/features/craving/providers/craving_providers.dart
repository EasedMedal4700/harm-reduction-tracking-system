import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../services/craving_service.dart';

final cravingServiceProvider = Provider<CravingService>((ref) {
  return CravingService(
    encryption: ref.watch(encryptionServiceProvider),
    supabase: ref.watch(supabaseClientProvider),
  );
});
