// MIGRATION:
// State: MIXED (legacy ChangeNotifier, Riverpod wiring)
// Navigation: N/A
// Models: LEGACY
// Theme: N/A
// Common: N/A
// Notes: Riverpod wrapper for legacy ReflectionProvider.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../reflection_provider.dart';

final reflectionControllerProvider =
    ChangeNotifierProvider.autoDispose<ReflectionProvider>((ref) {
      return ReflectionProvider();
    });
