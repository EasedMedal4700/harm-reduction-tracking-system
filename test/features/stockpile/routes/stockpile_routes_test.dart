import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/features/stockpile/routes/stockpile_routes.dart';
import 'package:mobile_drug_use_app/features/stockpile/stockpile_page.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/personal_library_service.dart';
import 'package:mobile_drug_use_app/features/catalog/models/drug_catalog_entry.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';

class _DummyPersonalLibraryApi implements PersonalLibraryApi {
  @override
  Future<List<Map<String, dynamic>>> fetchDrugProfiles() async => const [];

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String userId,
  }) async => const [];
}

class _FakePersonalLibraryService extends PersonalLibraryService {
  _FakePersonalLibraryService()
    : super(api: _DummyPersonalLibraryApi(), userIdGetter: () => 'u1');

  @override
  Future<List<DrugCatalogEntry>> fetchCatalog() async => const [];
}

void main() {
  test('StockpileRoutes exposes library route', () {
    final routes = StockpileRoutes.routes();
    expect(routes, hasLength(1));
    expect(routes.single.path, StockpileRoutes.libraryPath);
  });

  testWidgets('StockpileRoutes builder builds PersonalLibraryPage', (
    tester,
  ) async {
    final router = GoRouter(
      routes: StockpileRoutes.routes(),
      initialLocation: StockpileRoutes.libraryPath,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          personalLibraryServiceProvider.overrideWithValue(
            _FakePersonalLibraryService(),
          ),
        ],
        child: AppThemeProvider(
          theme: AppTheme.light(),
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(PersonalLibraryPage), findsOneWidget);
  });
}
