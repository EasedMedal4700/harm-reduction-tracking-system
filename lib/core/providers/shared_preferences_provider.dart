// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Core provider.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});
