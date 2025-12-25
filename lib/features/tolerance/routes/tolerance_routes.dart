// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Tolerance routes

import 'package:go_router/go_router.dart';
import '../pages/tolerance_dashboard_page.dart';

final toleranceRoutes = [
  GoRoute(
    path: '/tolerance',
    builder: (context, state) => const ToleranceDashboardPage(),
  ),
];
