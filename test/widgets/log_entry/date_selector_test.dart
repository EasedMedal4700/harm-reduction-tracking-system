import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/date_selector.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';

void main() {
  group('DateSelector Widget', () {
    testWidgets('renders with initial date', (tester) async {
      final testDate = DateTime(2024, 1, 15);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateSelector(
              date: testDate,
              onDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Date'), findsOneWidget);
      expect(find.text('2024-01-15'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
    });

    testWidgets('displays formatted date', (tester) async {
      final testDate = DateTime(2023, 12, 25);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateSelector(
              date: testDate,
              onDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('2023-12-25'), findsOneWidget);
    });

    testWidgets('shows date picker when Change button is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateSelector(
              date: DateTime.now(),
              onDateChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Change'));
      await tester.pumpAndSettle();

      // Date picker dialog should be displayed
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('has calendar icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateSelector(
              date: DateTime.now(),
              onDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('renders with CommonCard', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateSelector(
              date: DateTime.now(),
              onDateChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(CommonCard), findsOneWidget);
    });
  });
}
