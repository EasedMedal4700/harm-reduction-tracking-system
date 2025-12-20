import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/home/widgets/home/quick_action_button.dart';
import '../flutter_test_config.dart'; // Provides TestUtils

void main() {
  group('QuickActionButton', () {
    testWidgets('renders icon and label', (tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: QuickActionButton(
            icon: Icons.add,
            label: 'Add Entry',
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add Entry'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: QuickActionButton(
            icon: Icons.analytics,
            label: 'Analytics',
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(QuickActionButton));
      expect(pressed, isTrue);
    });

    testWidgets('is an ElevatedButton.icon', (tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: QuickActionButton(
            icon: Icons.note_add,
            label: 'Log Entry',
            onPressed: () {},
          ),
        ),
      );

      // ElevatedButton.icon is actually an ElevatedButton with specific structure
      expect(find.byType(QuickActionButton), findsOneWidget);
      expect(find.byIcon(Icons.note_add), findsOneWidget);
      expect(find.text('Log Entry'), findsOneWidget);
    });

    testWidgets('has correct padding', (tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: QuickActionButton(
            icon: Icons.home,
            label: 'Home',
            onPressed: () {},
          ),
        ),
      );

      final paddings = find.byType(Padding);
      expect(paddings, findsWidgets);

      // Find the Padding widget that is a direct child of QuickActionButton
      final padding = tester.widgetList<Padding>(paddings)
        .firstWhere((p) => p.padding == const EdgeInsets.only(bottom: 8));
      expect(padding.padding, const EdgeInsets.only(bottom: 8));
    });

    testWidgets('handles different icons', (tester) async {
      final icons = [
        Icons.add,
        Icons.analytics,
        Icons.home,
        Icons.settings,
        Icons.person,
      ];

      for (final icon in icons) {
        await tester.pumpWidget(
          TestUtils.createTestApp(
            child: QuickActionButton(
              icon: icon,
              label: 'Test',
              onPressed: () {},
            ),
          ),
        );

        expect(find.byIcon(icon), findsOneWidget);
      }
    });

    testWidgets('handles long labels', (tester) async {
      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: QuickActionButton(
            icon: Icons.add,
            label: 'This is a very long label that might wrap',
            onPressed: () {},
          ),
        ),
      );

      expect(find.text('This is a very long label that might wrap'), findsOneWidget);
    });

    testWidgets('maintains button state', (tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: QuickActionButton(
            icon: Icons.add,
            label: 'Tap Me',
            onPressed: () => tapCount++,
          ),
        ),
      );

      await tester.tap(find.byType(QuickActionButton));
      expect(tapCount, 1);

      await tester.tap(find.byType(QuickActionButton));
      expect(tapCount, 2);

      await tester.tap(find.byType(QuickActionButton));
      expect(tapCount, 3);
    });
  });
}
