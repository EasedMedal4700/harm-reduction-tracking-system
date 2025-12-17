import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/date_selector.dart';
import '../../helpers/test_app_wrapper.dart';

void main() {
  group('DateSelector Widget', () {
    testWidgets('renders with initial date', (tester) async {
      final testDate = DateTime(2024, 1, 15);

      await tester.pumpWidget(
        wrapWithAppTheme(
          DateSelector(
            selectedDate: testDate,
            onDateChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Jan 15, 2024'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('displays formatted date', (tester) async {
      final testDate = DateTime(2023, 12, 25);

      await tester.pumpWidget(
        wrapWithAppTheme(
          DateSelector(
            selectedDate: testDate,
            onDateChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Dec 25, 2023'), findsOneWidget);
    });

    testWidgets('shows date picker when tapped', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          DateSelector(
            selectedDate: DateTime.now(),
            onDateChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Date picker dialog should be displayed
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('has calendar icon', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          DateSelector(
            selectedDate: DateTime.now(),
            onDateChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });
  });
}
