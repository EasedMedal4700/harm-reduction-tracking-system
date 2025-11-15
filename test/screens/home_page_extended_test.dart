import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/screens/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders home page with title', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
    });

    testWidgets('has floating action button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('has drawer menu', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('displays all quick action buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.text('Log Entry'), findsOneWidget);
      expect(find.text('Reflection'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Cravings'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Blood Levels'), findsOneWidget);
    });

    testWidgets('has correct icons for quick actions', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byIcon(Icons.note_add), findsOneWidget);
      expect(find.byIcon(Icons.self_improvement), findsOneWidget);
      expect(find.byIcon(Icons.analytics), findsOneWidget);
      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.byIcon(Icons.directions_run), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsOneWidget);
      expect(find.byIcon(Icons.inventory), findsOneWidget);
      expect(find.byIcon(Icons.bloodtype), findsOneWidget);
    });

    testWidgets('quick actions are in scrollable view', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('renders as Scaffold', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('has app bar', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomePage()));

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
