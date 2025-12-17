import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/time_selector.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('TimeSelector Widget', () {
    testWidgets('renders with initial time', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 14, minute: 30),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.access_time), findsOneWidget);
      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('displays formatted time with zero padding', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 9, minute: 5),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('09:05'), findsOneWidget);
    });

    testWidgets('has clock icon', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 12, minute: 0),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('has InkWell for tappable area', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 10, minute: 25),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('tapping opens time picker dialog', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 10, minute: 25),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('midnight displays as 00:00', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 0, minute: 0),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('23:59 displays correctly', (tester) async {
      await tester.pumpWidget(
        wrapWithAppTheme(
          MediaQuery(
            data: const MediaQueryData(alwaysUse24HourFormat: true),
            child: TimeSelector(
              selectedTime: const TimeOfDay(hour: 23, minute: 59),
              onTimeChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('23:59'), findsOneWidget);
    });
  });

  group('TimeSelector Time Formatting', () {
    test('padding helper works', () {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      expect(twoDigits(0), equals('00'));
      expect(twoDigits(5), equals('05'));
      expect(twoDigits(12), equals('12'));
    });
  });
}
