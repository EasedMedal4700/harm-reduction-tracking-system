import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_drug_use_app/main.dart'; // Or your app's main widget


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // No mocks for now - focus on UI testing

  testWidgets('Full log entry save flow (UI only)', (WidgetTester tester) async {
    // Pump the app (or just the screen)
    await tester.pumpWidget(const MyApp()); // Replace with your app's root widget

    // Navigate to log entry screen (adjust based on your navigation)
    await tester.tap(find.byIcon(Icons.add)); // Example: Tap a button to open log_entry.dart
    await tester.pumpAndSettle();

    // Verify screen is loaded
    expect(find.text('Quick Log Entry'), findsOneWidget);

    // Fill the form (simulate user input)
    // Substance (first TextFormField)
    await tester.enterText(find.byType(TextFormField).at(0), 'Cannabis');
    // Dosage (via DosageInput - tap buttons or enter text)
    await tester.tap(find.byIcon(Icons.add)); // Increase dosage
    // Route (select from ChoiceChip)
    await tester.tap(find.text('oral')); // Select route
    // Feelings (select primary)
    await tester.tap(find.text('Happy')); // Select feeling
    // Secondary feelings (if shown)
    await tester.tap(find.text('Joyful')); // Select secondary
    // Date/Time (use DateSelector/TimeSelector)
    await tester.tap(find.byType(ListTile).first); // Open date picker
    await tester.tap(find.text('OK')); // Confirm date
    // Location (dropdown)
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    // Notes
    await tester.enterText(find.byType(TextFormField).last, 'Test notes');

    // Tap Save
    await tester.tap(find.text('Save Entry'));
    await tester.pumpAndSettle(); // Wait for async operations

    // Verify success: SnackBar appears
    expect(find.text('Entry saved'), findsOneWidget);

    // Skip DB verification for now
  });

  testWidgets('Save fails on invalid form', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to screen
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Tap Save without filling
    await tester.tap(find.text('Save Entry'));
    await tester.pump();

    // Verify no save (validation error)
    expect(find.text('Entry saved'), findsNothing);
    // Skip DB verification for now
  });
}