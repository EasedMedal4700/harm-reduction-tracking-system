// MIGRATION:
// Navigation: GOROUTER
// Notes: GoRouter-ready route(s) for stockpile feature.

import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/features/stockpile/stockpile_page.dart';

class StockpileRoutes {
  static const String libraryPath = '/library';

  static List<GoRoute> routes() {
    return [
      GoRoute(
        path: libraryPath,
        builder: (context, state) => const PersonalLibraryPage(),
      ),
    ];
  }
}
