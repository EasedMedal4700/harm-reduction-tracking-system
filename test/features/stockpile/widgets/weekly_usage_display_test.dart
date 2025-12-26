import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/stockpile/widgets/weekly_usage_display.dart';
import 'package:mobile_drug_use_app/models/drug_catalog_entry.dart';
import '../../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets('WeeklyUsageDisplay calls onDayTap for days with count > 0', (
    tester,
  ) async {
    const entry = DrugCatalogEntry(
      name: 'Test',
      categories: ['Stimulant'],
      totalUses: 1,
      avgDose: 0,
      lastUsed: null,
      // indexing uses weekday % 7 => 0=Sun, 1=Mon...
      weekdayUsage: WeekdayUsage(
        counts: [0, 2, 0, 0, 0, 0, 0],
        mostActive: 1,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );

    var tapped = 0;
    String? name;
    int? idx;

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: WeeklyUsageDisplay(
          entry: entry,
          categoryColor: Colors.blue,
          onDayTap: (substanceName, weekdayIndex, dayName, isDark, accent) {
            tapped++;
            name = substanceName;
            idx = weekdayIndex;
          },
        ),
      ),
    );

    // Should render Sun..Sat labels
    expect(find.text('Sun'), findsOneWidget);
    expect(find.text('Mon'), findsOneWidget);

    await tester.tap(find.text('Mon'));
    await tester.pump();

    expect(tapped, 1);
    expect(name, 'Test');
    expect(idx, 1);
  });

  testWidgets(
    'WeeklyUsageDisplay does not call onDayTap for days with count == 0',
    (tester) async {
      const entry = DrugCatalogEntry(
        name: 'Test',
        categories: ['Stimulant'],
        totalUses: 1,
        avgDose: 0,
        lastUsed: null,
        weekdayUsage: WeekdayUsage(
          counts: [0, 2, 0, 0, 0, 0, 0],
          mostActive: 1,
          leastActive: 0,
        ),
        favorite: false,
        archived: false,
        notes: '',
        quantity: 0,
      );

      var tapped = 0;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: WeeklyUsageDisplay(
            entry: entry,
            categoryColor: Colors.blue,
            onDayTap: (_, __, ___, ____, _____) {
              tapped++;
            },
          ),
        ),
      );

      await tester.tap(find.text('Sun'));
      await tester.pump();

      expect(tapped, 0);
    },
  );

  testWidgets('WeeklyUsageDisplay covers dark-theme count text branch', (
    tester,
  ) async {
    const entry = DrugCatalogEntry(
      name: 'Test',
      categories: ['Stimulant'],
      totalUses: 1,
      avgDose: 0,
      lastUsed: null,
      weekdayUsage: WeekdayUsage(
        counts: [0, 2, 0, 0, 0, 0, 0],
        mostActive: 1,
        leastActive: 0,
      ),
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        themeMode: ThemeMode.dark,
        child: WeeklyUsageDisplay(
          entry: entry,
          categoryColor: Colors.blue,
          onDayTap: (_, __, ___, ____, _____) {},
        ),
      ),
    );

    expect(find.text('2'), findsOneWidget);
  });
}
