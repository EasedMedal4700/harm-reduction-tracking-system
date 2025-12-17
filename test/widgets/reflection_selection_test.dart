import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/reflection/reflection_selection.dart';
import '../helpers/test_app_wrapper.dart';


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

  Widget wrap(Widget child) => wrapWithAppTheme(child);

  testWidgets('renders each entry with dose information', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    // Widget uses "•" separator now, not "-"
    expect(find.textContaining('Cannabis'), findsOneWidget);
    expect(find.textContaining('10 mg'), findsOneWidget);
    expect(find.textContaining('MDMA'), findsOneWidget);
    expect(find.textContaining('120 mg'), findsOneWidget);
  });

  testWidgets('shows Next Step button (disabled when none selected)', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    // Button text is "Next Step", and should always be visible
    expect(find.text('Next Step'), findsOneWidget);
  });

  testWidgets('Next Step button enabled when entry selected', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {'1'},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Next Step'),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Next Step button disabled when no entry selected', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Next Step'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('tapping entry calls onEntryChanged', (tester) async {
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

    // Tap the first InkWell (entry card)
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();

    expect(toggledId, '1');
    expect(toggledValue, isTrue);
  });

  testWidgets('displays selection title', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    expect(find.text('Select entries to reflect on'), findsOneWidget);
  });

  testWidgets('shows empty state when no entries', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: const [],
      selectedIds: const {},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    expect(find.text('No recent entries found.'), findsOneWidget);
  });

  testWidgets('selected entry shows check icon', (tester) async {
    await tester.pumpWidget(wrap(ReflectionSelection(
      entries: entries,
      selectedIds: const {'1'},
      onEntryChanged: (_, __) {},
      onNext: () {},
    )));

    // Check icon appears when entry is selected
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}

