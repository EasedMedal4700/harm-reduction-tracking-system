import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/time_selector.dart';

void main() {
  group('TimeSelector Widget', () {
    testWidgets('renders with initial time', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 14,
              minute: 30,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      // Check for Time label
      expect(find.text('Time'), findsOneWidget);
      
      // Check for formatted time display (14:30)
      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('displays formatted hour and minute with zero padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 9,
              minute: 5,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      // Check for zero-padded time display (09:05)
      expect(find.text('09:05'), findsOneWidget);
    });

    testWidgets('shows hint text to tap for change', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 12,
              minute: 0,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Tap to change time'), findsOneWidget);
    });

    testWidgets('has clock icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 12,
              minute: 0,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('has edit icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 12,
              minute: 0,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });

    testWidgets('renders as Column', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 10,
              minute: 25,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('has InkWell for tappable area', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 10,
              minute: 25,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('midnight displays as 00:00', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 0,
              minute: 0,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('23:59 displays correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 23,
              minute: 59,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('23:59'), findsOneWidget);
    });
  });

  group('TimeSelector Time Formatting', () {
    test('hour padding adds leading zero for single digit', () {
      String formatHour(int hour) => hour.toString().padLeft(2, '0');
      
      expect(formatHour(0), equals('00'));
      expect(formatHour(5), equals('05'));
      expect(formatHour(9), equals('09'));
      expect(formatHour(10), equals('10'));
      expect(formatHour(23), equals('23'));
    });

    test('minute padding adds leading zero for single digit', () {
      String formatMinute(int minute) => minute.toString().padLeft(2, '0');
      
      expect(formatMinute(0), equals('00'));
      expect(formatMinute(5), equals('05'));
      expect(formatMinute(9), equals('09'));
      expect(formatMinute(30), equals('30'));
      expect(formatMinute(59), equals('59'));
    });
  });
}
