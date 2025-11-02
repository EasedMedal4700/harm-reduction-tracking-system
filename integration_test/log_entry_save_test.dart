import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_drug_use_app/main.dart'; // Or your app's main widget


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // No mocks for now - focus on UI testing

  testWidgets('Full log entry save flow (UI only)', (WidgetTester tester) async {
    // Pump the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle(); // Wait for initial load
    print('App pumped and settled');

    // Handle login if needed
    if (find.text('Login').evaluate().isNotEmpty) {
      print('Login page detected');
      await tester.enterText(find.byType(TextField).at(0), 'test'); // Email
      await tester.enterText(find.byType(TextField).at(1), 'test'); // Password
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login')); // Tap the login button specifically
      await Future.delayed(const Duration(seconds: 2)); // Wait for login to complete
      await tester.pumpAndSettle();
      print('Login completed');
    } else {
      print('No login page');
    }

    // Navigate to log entry screen
    // Try different finders if 'Log Entry' doesn't work
    if (find.text('Log Entry').evaluate().isNotEmpty) {
      print('Found Log Entry text');
      await tester.tap(find.text('Log Entry'));
    } else if (find.byIcon(Icons.add).evaluate().isNotEmpty) {
      print('Found add icon');
      await tester.tap(find.byIcon(Icons.add));
    } else {
      // If neither, assume it's the first button or fail gracefully
      final buttons = find.byType(ElevatedButton);
      print('Found ${buttons.evaluate().length} ElevatedButtons');
      for (var i = 0; i < buttons.evaluate().length; i++) {
        final button = buttons.at(i);
        final text = find.descendant(of: button, matching: find.byType(Text)).evaluate();
        if (text.isNotEmpty) {
          print('Button $i text: ${text.first.widget as Text}');
        }
      }
      if (buttons.evaluate().isNotEmpty) {
        print('Tapping first ElevatedButton');
        await tester.tap(buttons.first);
      } else {
        print('No ElevatedButtons found');
      }
    }
    await tester.pumpAndSettle();
    print('Navigation completed');

    // Verify screen is loaded
    if (find.text('Quick Log Entry').evaluate().isNotEmpty) {
      print('Log entry screen loaded');
    } else {
      print('Log entry screen not found');
    }
    expect(find.text('Quick Log Entry'), findsOneWidget);

    // Fill the form (simulate user input)
    print('Filling form');
    // Dosage (first TextFormField)
    await tester.enterText(find.byType(TextFormField).at(0), '1.0');
    print('Dosage entered: 1.0');
    // Substance (second TextFormField)
    await tester.enterText(find.byType(TextFormField).at(1), 'Cannabis');
    print('Substance entered: Cannabis');
    await tester.pumpAndSettle();
    // Route (select from ChoiceChip)
    await tester.tap(find.text('💊 ORAL')); // Select route
    await tester.pumpAndSettle();
    print('Route selected: ORAL');
    // Feelings (select primary)
    await tester.tap(find.text('HAPPY')); // Select feeling
    await tester.pumpAndSettle();
    print('Primary feeling selected: HAPPY');
    // Secondary feelings (if shown)
    await tester.tap(find.text('Joyful')); // Select secondary
    await tester.pumpAndSettle();
    print('Secondary feeling selected: Joyful');
    // Date/Time (use DateSelector/TimeSelector)
    // await tester.tap(find.byType(ListTile).first); // Open date picker
    // await tester.pumpAndSettle();
    // await tester.tap(find.text('OK')); // Confirm date
    // await tester.pumpAndSettle();
    // Location (dropdown)
    // await tester.tap(find.byType(DropdownButton<String>).last); // Location dropdown
    // await tester.pumpAndSettle();
    // await tester.tap(find.text('Home'));
    // await tester.pumpAndSettle();
    // Notes
    await tester.enterText(find.byType(TextFormField).last, 'Test notes');
    print('Notes entered: Test notes');
    print('Form filled');

    // Scroll to the bottom to make save button visible
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    // Tap Save
    await tester.tap(find.text('Save Entry'), warnIfMissed: false);
    await tester.pumpAndSettle(); // Wait for async operations
    await tester.pump(const Duration(milliseconds: 2500)); // Wait for snackbar
    print('Save tapped');

    // Verify success: SnackBar appears
    expect(find.text('Entry saved'), findsOneWidget);
    print('Test passed');

    // Skip DB verification for now
  });

  testWidgets('Save fails on invalid form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Handle login if needed
    if (find.text('Login').evaluate().isNotEmpty) {
      await tester.enterText(find.byType(TextField).at(0), 'test');
      await tester.enterText(find.byType(TextField).at(1), 'test');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await Future.delayed(const Duration(seconds: 2)); // Wait for login to complete
      await tester.pumpAndSettle();
    }

    // Navigate to screen
    await tester.tap(find.text('Log Entry'));
    await tester.pumpAndSettle();

    // Scroll to the bottom to make save button visible
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    // Tap Save without filling
    await tester.tap(find.text('Save Entry'), warnIfMissed: false);
    await tester.pump();

    // Verify no save (validation error)
    expect(find.text('Entry saved'), findsNothing);
    // Skip DB verification for now
  });
}