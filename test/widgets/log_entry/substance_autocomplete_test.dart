import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/substance_autocomplete.dart';

void main() {
  group('SubstanceAutocomplete Widget Tests', () {
    testWidgets('renders text field with search icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              onSubstanceChanged: (_) {},
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
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: 'Initial',
              controller: controller,
              onSubstanceChanged: (_) {},
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
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              onSubstanceChanged: (value) {
                changedValue = value;
              },
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

    testWidgets('validates input correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: SubstanceAutocomplete(
                substance: '',
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to validate empty field
      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();

      // Should be invalid (empty)
      expect(isValid, false);
    });

    testWidgets('accepts valid input in validation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: SubstanceAutocomplete(
                substance: 'Nicotine',
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter valid text (must be from DrugUseCatalog.substances)
      await tester.enterText(find.byType(TextFormField), 'Nicotine');
      await tester.pump();

      // Validate the form
      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();

      // Should be valid
      expect(isValid, true);
    });

    testWidgets('syncs external controller on text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              controller: controller,
              onSubstanceChanged: (_) {},
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

    testWidgets('displays substance parameter value initially', (tester) async {
      final controller = TextEditingController(text: 'TestSubstance');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: 'TestSubstance',
              controller: controller,
              onSubstanceChanged: (_) {},
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
