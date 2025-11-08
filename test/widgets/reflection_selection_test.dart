import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/reflection/reflection_selection.dart';

void main() {
  final entries = [
    {
      'use_id': 1,
      'name': 'Cannabis',
      'dose': '10 mg',
      'start_time': '2025-11-07T12:00:00Z',
      'place': 'Home',
    },
    {
      'use_id': 2,
      'name': 'MDMA',
      'dose': '120 mg',
      'start_time': '2025-11-05T21:00:00Z',
      'place': 'Club',
    },
  ];

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders each entry with dose information', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    expect(find.text('Cannabis - 10 mg'), findsOneWidget);
    expect(find.text('MDMA - 120 mg'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('shows Next button when an entry is selected', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {'1'},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('delegates checkbox changes through onEntryChanged', (tester) async {
    String? toggledId;
    bool? toggledValue;

    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {},
      onEntryChanged: (id, selected) {
        toggledId = id;
        toggledValue = selected;
      },
      onNext: () {},
    )));

    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();

    expect(toggledId, '1');
    expect(toggledValue, isTrue);
  });
}
