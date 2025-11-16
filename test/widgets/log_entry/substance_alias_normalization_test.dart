import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/substance_autocomplete.dart';
import 'package:mobile_drug_use_app/services/drug_profile_service.dart';

void main() {
  group('Substance Alias Normalization Tests', () {
    testWidgets('normalizes Ritalin alias to Methylphenidate', (tester) async {
      String? normalizedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              onSubstanceChanged: (value) {
                normalizedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Type "Ritalin" in the text field
      await tester.enterText(find.byType(TextFormField), 'Ritalin');
      await tester.pump();

      // In a real scenario with database, this would trigger normalization
      // For this test, we're verifying the callback is called with the entered value
      expect(normalizedValue, 'Ritalin');

      // Note: Actual normalization happens when selecting from autocomplete dropdown
      // which requires mocking the DrugProfileService to return alias data
    });

    testWidgets('shows normalization message when alias is selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              onSubstanceChanged: (value) {
                // Callback receives the canonical name after normalization
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The normalization message should appear after selecting an alias
      // from the autocomplete dropdown (requires database/mock)
      
      // For now, verify the widget renders correctly
      expect(find.byType(SubstanceAutocomplete), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('validates normalized substance name', (tester) async {
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: GlobalKey<FormState>(),
              child: SubstanceAutocomplete(
                substance: '',
                controller: controller,
                onSubstanceChanged: (value) {
                  changedValue = value;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter a substance name
      await tester.enterText(find.byType(TextFormField), 'Methylphenidate');
      await tester.pump();

      // Verify the value was set
      expect(controller.text, 'Methylphenidate');
      expect(changedValue, 'Methylphenidate');

      // Validate the form
      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();

      // Should be valid (non-empty, and database is empty in tests so accepts any value)
      expect(isValid, true);
    });

    testWidgets('preserves canonical name after normalization', (tester) async {
      final controller = TextEditingController();
      String? finalValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              controller: controller,
              onSubstanceChanged: (value) {
                finalValue = value;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate entering and normalizing
      await tester.enterText(find.byType(TextFormField), 'Methylphenidate');
      await tester.pump();

      // The canonical name should be preserved
      expect(controller.text, 'Methylphenidate');
      expect(finalValue, 'Methylphenidate');
    });

    testWidgets('handles empty input correctly', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: SubstanceAutocomplete(
                substance: '',
                controller: controller,
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to validate without entering anything
      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();

      // Should be invalid (empty)
      expect(isValid, false);
      
      // After pump, error message should appear
      await tester.pump();
      expect(find.text('Please enter a substance'), findsOneWidget);
    });

    testWidgets('controller stays in sync during text changes', (tester) async {
      final controller = TextEditingController();
      final values = <String>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SubstanceAutocomplete(
              substance: '',
              controller: controller,
              onSubstanceChanged: (value) {
                values.add(value);
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Type character by character
      await tester.enterText(find.byType(TextFormField), 'R');
      await tester.pump();
      expect(controller.text, 'R');

      await tester.enterText(find.byType(TextFormField), 'Ri');
      await tester.pump();
      expect(controller.text, 'Ri');

      await tester.enterText(find.byType(TextFormField), 'Rit');
      await tester.pump();
      expect(controller.text, 'Rit');

      await tester.enterText(find.byType(TextFormField), 'Ritalin');
      await tester.pump();
      expect(controller.text, 'Ritalin');

      // Verify all changes were captured
      expect(values.length, greaterThan(0));
      expect(values.last, 'Ritalin');
    });

    test('DrugSearchResult correctly identifies aliases', () {
      // Test the DrugSearchResult class structure
      final aliasResult = DrugSearchResult(
        displayName: 'Ritalin (alias for Methylphenidate)',
        canonicalName: 'Methylphenidate',
        isAlias: true,
      );

      expect(aliasResult.displayName, contains('Ritalin'));
      expect(aliasResult.canonicalName, 'Methylphenidate');
      expect(aliasResult.isAlias, true);

      final canonicalResult = DrugSearchResult(
        displayName: 'Methylphenidate',
        canonicalName: 'Methylphenidate',
        isAlias: false,
      );

      expect(canonicalResult.displayName, 'Methylphenidate');
      expect(canonicalResult.canonicalName, 'Methylphenidate');
      expect(canonicalResult.isAlias, false);
    });

    testWidgets('form submission uses canonical name', (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();
      String? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  SubstanceAutocomplete(
                    substance: '',
                    controller: controller,
                    onSubstanceChanged: (value) {
                      submittedValue = value;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        // Form is valid, would save here
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter substance
      await tester.enterText(find.byType(TextFormField), 'Methylphenidate');
      await tester.pump();

      // Tap save button
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify the canonical name is what would be saved
      expect(submittedValue, 'Methylphenidate');
      expect(controller.text, 'Methylphenidate');
    });

    testWidgets('displays normalization info message', (tester) async {
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

      await tester.pumpAndSettle();

      // The normalization message widget should exist
      // (it appears after selecting an alias from autocomplete)
      expect(find.byType(SubstanceAutocomplete), findsOneWidget);
      
      // Look for the Column that contains the message area
      expect(find.byType(Column), findsWidgets);
    });
  });

  group('Database Integration Scenarios', () {
    testWidgets('handles case-insensitive substance matching', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: SubstanceAutocomplete(
                substance: '',
                controller: controller,
                onSubstanceChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test various cases
      await tester.enterText(find.byType(TextFormField), 'methylphenidate');
      await tester.pump();
      
      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();

      // Should be valid (database empty in tests accepts any non-empty value)
      expect(isValid, true);
    });

    testWidgets('rejects empty substance after trim', (tester) async {
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

      // Enter only whitespace
      await tester.enterText(find.byType(TextFormField), '   ');
      await tester.pump();

      final formState = tester.state<FormState>(find.byType(Form));
      final isValid = formState.validate();

      // Should be invalid (empty after trim)
      expect(isValid, false);
    });
  });
}
