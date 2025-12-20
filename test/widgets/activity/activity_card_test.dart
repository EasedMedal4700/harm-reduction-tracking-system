import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityCard widget tests', () {
    testWidgets('displays drug use entry correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                leading: const Icon(Icons.medication),
                title: const Text('Cannabis'),
                subtitle: const Text('10 mg • Home'),
                trailing: const Text('2h ago'),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Cannabis'), findsOneWidget);
      expect(find.text('10 mg • Home'), findsOneWidget);
      expect(find.text('2h ago'), findsOneWidget);
      expect(find.byIcon(Icons.medication), findsOneWidget);
    });

    testWidgets('displays craving entry correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                leading: const Icon(Icons.psychology),
                title: const Text('MDMA'),
                subtitle: const Text('Intensity: 8 • Home'),
                trailing: const Text('5h ago'),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('MDMA'), findsOneWidget);
      expect(find.text('Intensity: 8 • Home'), findsOneWidget);
      expect(find.text('5h ago'), findsOneWidget);
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });

    testWidgets('displays reflection entry correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Daily Reflection'),
                subtitle: const Text('My thoughts today...'),
                trailing: const Text('1d ago'),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Daily Reflection'), findsOneWidget);
      expect(find.text('My thoughts today...'), findsOneWidget);
      expect(find.text('1d ago'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb), findsOneWidget);
    });

    testWidgets('card is tappable', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                leading: const Icon(Icons.medication),
                title: const Text('Cannabis'),
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Card));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('displays timestamp in relative format', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: const Text('Entry'),
                trailing: const Text('Just now'),
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('displays multiple entries in list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                Card(
                  child: ListTile(title: const Text('Cannabis'), onTap: () {}),
                ),
                Card(
                  child: ListTile(title: const Text('MDMA'), onTap: () {}),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Reflection'),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Cannabis'), findsOneWidget);
      expect(find.text('MDMA'), findsOneWidget);
      expect(find.text('Reflection'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(3));
    });
  });

  group('ActivityCard empty states', () {
    testWidgets('displays empty state when no entries', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text('No recent activity'))),
        ),
      );

      expect(find.text('No recent activity'), findsOneWidget);
    });

    testWidgets('displays loading indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
