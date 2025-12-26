// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Navigation provider.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/navigation_service.dart';

final navigationProvider = Provider<NavigationService>(
  (ref) => NavigationService(),
);
