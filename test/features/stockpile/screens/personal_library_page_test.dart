import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_drug_use_app/features/stockpile/stockpile_page.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/features/stockpile/services/personal_library_service.dart';
import 'package:mobile_drug_use_app/features/catalog/models/drug_catalog_entry.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/stockpile_item.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/stockpile_repository.dart';
import 'package:mobile_drug_use_app/features/stockpile/repo/substance_repository.dart';
import '../../../helpers/test_app_wrapper.dart';
import 'package:mobile_drug_use_app/features/catalog/widgets/add_stockpile_sheet.dart';

class _DummyPersonalLibraryApi implements PersonalLibraryApi {
  @override
  Future<List<Map<String, dynamic>>> fetchDrugProfiles() async => const [];

  @override
  Future<List<Map<String, dynamic>>> fetchDrugUseRows({
    required String userId,
  }) async => const [];
}

class _FakePersonalLibraryService extends PersonalLibraryService {
  _FakePersonalLibraryService(this._catalog)
    : super(api: _DummyPersonalLibraryApi(), userIdGetter: () => 'u1');

  final List<DrugCatalogEntry> _catalog;

  @override
  Future<List<DrugCatalogEntry>> fetchCatalog() async => _catalog;
}

class _CountingPersonalLibraryService extends _FakePersonalLibraryService {
  _CountingPersonalLibraryService(super.catalog);

  int refreshCalls = 0;
  int favoriteCalls = 0;
  int archiveCalls = 0;

  @override
  Future<List<DrugCatalogEntry>> fetchCatalog() async {
    refreshCalls++;
    return super.fetchCatalog();
  }

  @override
  Future<bool> toggleFavorite(DrugCatalogEntry entry) async {
    favoriteCalls++;
    return !entry.favorite;
  }

  @override
  Future<bool> toggleArchive(DrugCatalogEntry entry) async {
    archiveCalls++;
    return !entry.archived;
  }
}

class _CompletingPersonalLibraryService extends PersonalLibraryService {
  _CompletingPersonalLibraryService(this.completer)
    : super(api: _DummyPersonalLibraryApi(), userIdGetter: () => 'u1');

  final Completer<List<DrugCatalogEntry>> completer;

  @override
  Future<List<DrugCatalogEntry>> fetchCatalog() => completer.future;
}

class _FlakyPersonalLibraryService extends PersonalLibraryService {
  _FlakyPersonalLibraryService({required this.firstError})
    : super(api: _DummyPersonalLibraryApi(), userIdGetter: () => 'u1');

  final Object firstError;
  int calls = 0;

  @override
  Future<List<DrugCatalogEntry>> fetchCatalog() async {
    calls++;
    if (calls == 1) throw firstError;
    return const [];
  }
}

class _FakeStockpileRepository extends StockpileRepository {
  int calls = 0;

  @override
  Future<StockpileItem?> getStockpile(String substanceId) async {
    calls++;
    return null;
  }
}

class _FakeSubstanceRepository extends SubstanceRepository {
  @override
  Future<Map<String, dynamic>?> getSubstanceDetails(
    String substanceName,
  ) async {
    return const <String, dynamic>{};
  }
}

DrugCatalogEntry _entry() {
  return DrugCatalogEntry(
    name: 'Methylphenidate',
    categories: const ['Stimulant'],
    totalUses: 2,
    avgDose: 5,
    lastUsed: DateTime(2025, 1, 1),
    // 0=Sun, 1=Mon
    weekdayUsage: const WeekdayUsage(
      counts: [0, 1, 0, 0, 0, 0, 0],
      mostActive: 1,
      leastActive: 0,
    ),
    favorite: false,
    archived: false,
    notes: '',
    quantity: 0,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets(
    'PersonalLibraryPage loads, opens sheets, and can add stockpile',
    (tester) async {
      final repo = _FakeStockpileRepository();

      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(
          home: const PersonalLibraryPage(),
          overrides: [
            personalLibraryServiceProvider.overrideWithValue(
              _FakePersonalLibraryService([_entry()]),
            ),
            stockpileRepositoryProvider.overrideWithValue(repo),
            substanceRepositoryProvider.overrideWithValue(
              _FakeSubstanceRepository(),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Methylphenidate'), findsOneWidget);
      expect(
        repo.calls,
        greaterThan(0),
        reason: 'stockpileItemProvider should query repo',
      );

      // Open day usage sheet (Mon)
      await tester.tap(find.text('Mon'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Usage History'), findsOneWidget);

      // Close usage sheet
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Open add stockpile sheet
      await tester.tap(find.text('Add to Stockpile'));
      await tester.pumpAndSettle();
      expect(find.text('Add to Stockpile'), findsWidgets);

      await tester.enterText(find.byType(TextField).first, '10');
      await tester.tap(find.text('Add to Stockpile').last);
      await tester.pumpAndSettle();

      // SnackBar is shown on success
      expect(find.byType(SnackBar), findsOneWidget);
    },
  );

  testWidgets('PersonalLibraryPage shows loader while catalog is loading', (
    tester,
  ) async {
    final completer = Completer<List<DrugCatalogEntry>>();

    await tester.pumpWidget(
      wrapWithAppThemeAndProvidersApp(
        home: const PersonalLibraryPage(),
        overrides: [
          personalLibraryServiceProvider.overrideWithValue(
            _CompletingPersonalLibraryService(completer),
          ),
        ],
      ),
    );

    // Loading state before completer finishes
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    completer.complete(const []);
    await tester.pumpAndSettle();
    expect(find.text('No active substances in your library'), findsOneWidget);
  });

  testWidgets('PersonalLibraryPage shows error and retry refreshes', (
    tester,
  ) async {
    final flaky = _FlakyPersonalLibraryService(firstError: StateError('boom'));

    await tester.pumpWidget(
      wrapWithAppThemeAndProvidersApp(
        home: const PersonalLibraryPage(),
        overrides: [personalLibraryServiceProvider.overrideWithValue(flaky)],
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('Failed to load catalog:'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(flaky.calls, greaterThanOrEqualTo(2));
    expect(find.text('No active substances in your library'), findsOneWidget);
  });

  testWidgets(
    'PersonalLibraryPage supports refresh, archived toggle, search, clear, favorite and archive actions',
    (tester) async {
      final service = _CountingPersonalLibraryService([_entry()]);

      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(
          home: const PersonalLibraryPage(),
          overrides: [
            personalLibraryServiceProvider.overrideWithValue(service),
            stockpileRepositoryProvider.overrideWithValue(
              _FakeStockpileRepository(),
            ),
            substanceRepositoryProvider.overrideWithValue(
              _FakeSubstanceRepository(),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Refresh
      await tester.tap(find.byTooltip('Refresh'));
      await tester.pumpAndSettle();
      expect(service.refreshCalls, greaterThanOrEqualTo(2));

      // Search + clear
      await tester.enterText(find.byType(TextField).first, 'meth');
      await tester.pump();
      expect(find.byIcon(Icons.clear), findsOneWidget);
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Toggle archived (even if list contains none)
      await tester.tap(find.byTooltip('Show Archived'));
      await tester.pumpAndSettle();

      // Favorite
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();
      expect(service.favoriteCalls, 1);

      // Archive via menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Archive'));
      await tester.pumpAndSettle();
      expect(service.archiveCalls, 1);
    },
  );

  testWidgets(
    'PersonalLibraryPage invalidates stockpile provider when add-sheet returns true and allows tapping card',
    (tester) async {
      final repo = _FakeStockpileRepository();

      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(
          home: const PersonalLibraryPage(),
          overrides: [
            personalLibraryServiceProvider.overrideWithValue(
              _FakePersonalLibraryService([_entry()]),
            ),
            stockpileRepositoryProvider.overrideWithValue(repo),
            substanceRepositoryProvider.overrideWithValue(
              _FakeSubstanceRepository(),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      final before = repo.calls;

      // Tap card (covers onTap callback)
      await tester.tap(find.text('Methylphenidate'));
      await tester.pump();

      // Open add stockpile sheet and force it to return true
      await tester.tap(find.text('Add to Stockpile'));
      await tester.pumpAndSettle();
      expect(find.byType(AddStockpileSheet), findsOneWidget);

      Navigator.of(tester.element(find.byType(AddStockpileSheet))).pop(true);
      await tester.pumpAndSettle();

      expect(repo.calls, greaterThan(before));
    },
  );
}
