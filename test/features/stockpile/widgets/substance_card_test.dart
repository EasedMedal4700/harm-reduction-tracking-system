import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/stockpile/widgets/substance_card.dart';
import 'package:mobile_drug_use_app/features/catalog/models/drug_catalog_entry.dart';
import 'package:mobile_drug_use_app/features/stockpile/models/stockpile_item.dart';
import '../../../helpers/test_app_wrapper.dart';

DrugCatalogEntry _entry({required List<String> categories}) {
  return DrugCatalogEntry(
    name: 'Methylphenidate',
    categories: categories,
    totalUses: 2,
    avgDose: 5,
    lastUsed: DateTime(2025, 1, 1),
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

DrugCatalogEntry _entryVariant({
  required List<String> categories,
  bool favorite = false,
  bool archived = false,
  DateTime? lastUsed,
}) {
  return DrugCatalogEntry(
    name: 'Test',
    categories: categories,
    totalUses: 0,
    avgDose: 0,
    lastUsed: lastUsed,
    weekdayUsage: const WeekdayUsage(
      counts: [0, 0, 0, 0, 0, 0, 0],
      mostActive: 0,
      leastActive: 0,
    ),
    favorite: favorite,
    archived: archived,
    notes: '',
    quantity: 0,
  );
}

void main() {
  testWidgets('SubstanceCard selects a primary category and supports actions', (
    tester,
  ) async {
    var favored = 0;
    var archived = 0;
    var managed = 0;

    final entry = _entry(categories: const ['Tentative', 'Stimulant']);

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: SubstanceCard(
          entry: entry,
          stockpile: null,
          onTap: () {},
          onFavorite: () => favored++,
          onArchive: () => archived++,
          onManageStockpile: () => managed++,
          onDayTap: (_, __, ___, ____, _____) {},
        ),
      ),
    );

    expect(find.text('Stimulant'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(favored, 1);

    await tester.tap(find.text('Add to Stockpile'));
    await tester.pump();
    expect(managed, 1);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archive'));
    await tester.pump();
    expect(archived, 1);
  });

  testWidgets('SubstanceCard renders stockpile section when present', (
    tester,
  ) async {
    var managed = 0;

    final stockpile = StockpileItem(
      substanceId: 'Methylphenidate',
      totalAddedMg: 100,
      currentAmountMg: 25,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 2),
    );

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: SubstanceCard(
          entry: _entry(categories: const ['Inactive']),
          stockpile: stockpile,
          onTap: () {},
          onFavorite: () {},
          onArchive: () {},
          onManageStockpile: () => managed++,
          onDayTap: (_, __, ___, ____, _____) {},
        ),
      ),
    );

    expect(find.text('Stockpile'), findsOneWidget);
    expect(find.textContaining('mg'), findsWidgets);

    await tester.tap(find.text('Stockpile'));
    await tester.pump();
    expect(managed, 1);
  });

  testWidgets(
    'SubstanceCard handles empty categories, archived menu label, and Never lastUsed',
    (tester) async {
      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SubstanceCard(
            entry: _entryVariant(
              categories: const [],
              favorite: true,
              archived: true,
              lastUsed: null,
            ),
            stockpile: null,
            onTap: () {},
            onFavorite: () {},
            onArchive: () {},
            onManageStockpile: () {},
            onDayTap: (_, __, ___, ____, _____) {},
          ),
        ),
      );

      expect(find.text('Unknown'), findsOneWidget);
      expect(find.text('Never'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      expect(find.text('Unarchive'), findsOneWidget);
    },
  );

  testWidgets('SubstanceCard renders low-stockpile state', (tester) async {
    final stockpile = StockpileItem(
      substanceId: 'Test',
      totalAddedMg: 100,
      currentAmountMg: 5,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 2),
    );

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: SubstanceCard(
          entry: _entryVariant(categories: const ['NonexistentCategory']),
          stockpile: stockpile,
          onTap: () {},
          onFavorite: () {},
          onArchive: () {},
          onManageStockpile: () {},
          onDayTap: (_, __, ___, ____, _____) {},
        ),
      ),
    );

    // Default icon fallback path and stockpile mg display
    expect(find.byIcon(Icons.science), findsOneWidget);
    expect(find.textContaining('mg'), findsWidgets);
  });

  testWidgets('SubstanceCard covers dark-theme icon color branch', (
    tester,
  ) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        themeMode: ThemeMode.dark,
        child: SubstanceCard(
          entry: _entryVariant(categories: const ['Stimulant']),
          stockpile: null,
          onTap: () {},
          onFavorite: () {},
          onArchive: () {},
          onManageStockpile: () {},
          onDayTap: (_, __, ___, ____, _____) {},
        ),
      ),
    );

    expect(find.byType(SubstanceCard), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
