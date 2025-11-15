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

      expect(find.text('Time'), findsOneWidget);
      expect(find.text('Hour:'), findsOneWidget);
      expect(find.text('Minute:'), findsOneWidget);
      expect(find.text('Selected time: 14:30'), findsOneWidget);
    });

    testWidgets('displays formatted hour and minute', (tester) async {
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

      expect(find.text('Selected time: 09:05'), findsOneWidget);
    });

    testWidgets('has hour slider', (tester) async {
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

      expect(find.byType(Slider), findsNWidgets(2));
    });

    testWidgets('hour slider calls onHourChanged', (tester) async {
      int? changedHour;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 12,
              minute: 0,
              onHourChanged: (hour) {
                changedHour = hour;
              },
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      final hourSlider = find.byType(Slider).first;
      await tester.drag(hourSlider, const Offset(100, 0));
      await tester.pump();

      expect(changedHour, isNotNull);
      expect(changedHour, greaterThan(12));
    });

    testWidgets('minute slider calls onMinuteChanged', (tester) async {
      int? changedMinute;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 12,
              minute: 30,
              onHourChanged: (_) {},
              onMinuteChanged: (minute) {
                changedMinute = minute;
              },
            ),
          ),
        ),
      );

      final minuteSlider = find.byType(Slider).last;
      await tester.drag(minuteSlider, const Offset(50, 0));
      await tester.pump();

      expect(changedMinute, isNotNull);
      expect(changedMinute, greaterThan(30));
    });

    testWidgets('hour slider has correct range 0-23', (tester) async {
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

      final hourSlider = tester.widget<Slider>(find.byType(Slider).first);
      expect(hourSlider.min, 0);
      expect(hourSlider.max, 23);
      expect(hourSlider.divisions, 23);
    });

    testWidgets('minute slider has correct range 0-59', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 12,
              minute: 30,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      final minuteSlider = tester.widget<Slider>(find.byType(Slider).last);
      expect(minuteSlider.min, 0);
      expect(minuteSlider.max, 59);
      expect(minuteSlider.divisions, 59);
    });

    testWidgets('displays current hour value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              hour: 18,
              minute: 45,
              onHourChanged: (_) {},
              onMinuteChanged: (_) {},
            ),
          ),
        ),
      );

      // Hour value displayed multiple times (in slider and in time display)
      expect(find.text('18'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays current minute value', (tester) async {
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

      // Minute value displayed multiple times
      expect(find.text('25'), findsAtLeastNWidgets(1));
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
  });
}
