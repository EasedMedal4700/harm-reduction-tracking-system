import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/inputs/filter_widget.dart';
import 'package:mobile_drug_use_app/constants/enums/time_period.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';

Widget _wrapWithTheme(Widget child) {
  final appTheme = AppTheme.light();
  return AppThemeProvider(
    theme: appTheme,
    child: MaterialApp(
      theme: appTheme.themeData,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FilterWidget renders and invokes key callbacks', (tester) async {
    TimePeriod? selectedPeriod = TimePeriod.last7Days;
    int selectedTypeIndex = 0;
    var selectedCategories = <String>[];
    var selectedSubstances = <String>[];
    var selectedPlaces = <String>[];
    var selectedRoutes = <String>[];
    var selectedFeelings = <String>[];
    double minCraving = 2;
    double maxCraving = 8;
    var sawMinChange = false;
    var sawMaxChange = false;

    await tester.pumpWidget(
      _wrapWithTheme(
        FilterWidget(
          uniqueCategories: const ['A', 'B'],
          uniqueSubstances: const ['S1', 'S2'],
          selectedCategories: selectedCategories,
          onCategoryChanged: (v) => selectedCategories = v,
          selectedSubstances: selectedSubstances,
          onSubstanceChanged: (v) => selectedSubstances = v,
          selectedTypeIndex: selectedTypeIndex,
          onTypeChanged: (i) => selectedTypeIndex = i,
          uniquePlaces: const ['Home'],
          selectedPlaces: selectedPlaces,
          onPlaceChanged: (v) => selectedPlaces = v,
          uniqueRoutes: const ['Oral'],
          selectedRoutes: selectedRoutes,
          onRouteChanged: (v) => selectedRoutes = v,
          uniqueFeelings: const ['Happy'],
          selectedFeelings: selectedFeelings,
          onFeelingChanged: (v) => selectedFeelings = v,
          minCraving: minCraving,
          maxCraving: maxCraving,
          onMinCravingChanged: (v) {
            minCraving = v;
            sawMinChange = true;
          },
          onMaxCravingChanged: (v) {
            maxCraving = v;
            sawMaxChange = true;
          },
          selectedPeriod: selectedPeriod,
          onPeriodChanged: (p) => selectedPeriod = p,
        ),
      ),
    );

    expect(find.text('Time Period'), findsOneWidget);
    await tester.tap(find.text('30 Days'));
    await tester.pump();
    expect(selectedPeriod, TimePeriod.last7Weeks);

    await tester.tap(find.text('Medical'));
    await tester.pump();
    expect(selectedTypeIndex, 1);

    // Toggle a filter chip.
    await tester.tap(find.text('A'));
    await tester.pump();
    expect(selectedCategories, contains('A'));

    // Drag the slider to trigger onChanged.
    final sliderFinder = find.byType(RangeSlider);
    await tester.ensureVisible(sliderFinder);
    await tester.drag(sliderFinder, const Offset(100, 0));
    await tester.pump();
    expect(sawMinChange, isTrue);
    expect(sawMaxChange, isTrue);
  });

  testWidgets('FilterButtons supports multi-select and Select All', (
    tester,
  ) async {
    var selected = <String>[];

    await tester.pumpWidget(
      _wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return FilterButtons(
              label: 'Category',
              options: const ['A', 'B', 'C'],
              selectedValues: selected,
              onChanged: (v) => setState(() => selected = v),
              allOptions: const ['A', 'B', 'C'],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Select All'));
    await tester.pump();
    expect(selected, ['A', 'B', 'C']);

    await tester.tap(find.text('B'));
    await tester.pump();
    expect(selected, isNot(contains('B')));
  });

  testWidgets('FilterButtons supports single-select and All->null', (
    tester,
  ) async {
    String? selected;

    await tester.pumpWidget(
      _wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return FilterButtons(
              label: 'Route',
              options: const ['All', 'Oral', 'IV'],
              selectedValue: selected,
              onSingleChanged: (v) => setState(() => selected = v),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Oral'));
    await tester.pump();
    expect(selected, 'Oral');

    await tester.tap(find.text('All'));
    await tester.pump();
    expect(selected, isNull);
  });
}
