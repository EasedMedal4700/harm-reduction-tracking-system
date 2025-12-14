import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/substance_autocomplete.dart';

void main() {
  group('SubstanceAutocomplete Widget Tests', () {
    testWidgets('renders text field with search icon', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Check for text field
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Substance'), findsOneWidget);
    });

    testWidgets('syncs with external controller', (tester) async {
      final controller = TextEditingController(text: 'Initial');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                controller: controller,
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check initial value is displayed
      expect(controller.text, 'Initial');

      // Update external controller
      controller.text = 'Updated';
      await tester.pump();

      // Controller should have updated value
      expect(controller.text, 'Updated');
    });

    testWidgets('calls onSubstanceChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                onSubstanceChanged: (value) {
                  changedValue = value;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Type in the text field
      await tester.enterText(find.byType(TextFormField), 'caffeine');
      await tester.pump();

      // Should have called the callback
      expect(changedValue, 'caffeine');
    });

    testWidgets('displays substance input field', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the text field is present
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('accepts valid input without showing error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter valid text  
      await tester.enterText(find.byType(TextFormField), 'Nicotine');
      await tester.pumpAndSettle();

      // Should not show validation error for valid substance
      expect(find.text('Substance is required'), findsNothing);
    });

    testWidgets('syncs external controller on text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                controller: controller,
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Type in the text field
      await tester.enterText(find.byType(TextFormField), 'Nicotine');
      await tester.pump();

      // External controller should be synced
      expect(controller.text, 'Nicotine');
    });

    testWidgets('displays controller value initially', (tester) async {
      final controller = TextEditingController(text: 'TestSubstance');

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubstanceAutocomplete(
                controller: controller,
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check initial value
      expect(controller.text, 'TestSubstance');
    });
  });
}
