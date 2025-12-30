// MIGRATION:
// State: MIXED (legacy ChangeNotifier, Riverpod wiring)
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Riverpod wrapper for legacy SettingsProvider.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_provider.dart';

final settingsControllerProvider = ChangeNotifierProvider<SettingsProvider>((
  ref,
) {
  return SettingsProvider();
});
