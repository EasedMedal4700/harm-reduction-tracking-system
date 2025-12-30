// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Riverpod providers for feature flag state.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/feature_flag_service.dart';
import '../../../core/services/user_service.dart';

final featureFlagServiceProvider = ChangeNotifierProvider<FeatureFlagService>((
  ref,
) {
  return featureFlagService;
});

final isAdminProvider = FutureProvider<bool>((ref) async {
  return UserService.isAdmin();
});
