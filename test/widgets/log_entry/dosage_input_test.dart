import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/dosage_input.dart';

void main() {
  group('DosageInput Widget', () {
    testWidgets('renders with initial values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: 10.0,
              unit: 'mg',
              units: const ['mg', 'g', 'ml'],
              onDoseChanged: (_) {},
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('10.0'), findsOneWidget);
      expect(find.text('mg'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('increment button increases dose by 1', (tester) async {
      double currentDose = 5.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: currentDose,
              unit: 'mg',
              units: const ['mg'],
              onDoseChanged: (newDose) {
                currentDose = newDose;
              },
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      expect(currentDose, 6.0);
    });

    testWidgets('decrement button decreases dose by 1', (tester) async {
      double currentDose = 5.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: currentDose,
              unit: 'mg',
              units: const ['mg'],
              onDoseChanged: (newDose) {
                currentDose = newDose;
              },
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      expect(currentDose, 4.0);
    });

    testWidgets('decrement button clamps to 0', (tester) async {
      double currentDose = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: currentDose,
              unit: 'mg',
              units: const ['mg'],
              onDoseChanged: (newDose) {
                currentDose = newDose;
              },
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.remove));
      expect(currentDose, 0.0); // Should not go below 0
    });

    testWidgets('text field allows manual input', (tester) async {
      double currentDose = 10.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: currentDose,
              unit: 'mg',
              units: const ['mg'],
              onDoseChanged: (newDose) {
                currentDose = newDose;
              },
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '25.5');
      expect(currentDose, 25.5);
    });

    testWidgets('unit dropdown changes unit', (tester) async {
      String currentUnit = 'mg';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: 10.0,
              unit: currentUnit,
              units: const ['mg', 'g', 'ml'],
              onDoseChanged: (_) {},
              onUnitChanged: (newUnit) {
                currentUnit = newUnit;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('mg'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('g').last);
      await tester.pumpAndSettle();

      expect(currentUnit, 'g');
    });

    testWidgets('displays all available units in dropdown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: 10.0,
              unit: 'mg',
              units: const ['mg', 'g', 'ml', 'pills'],
              onDoseChanged: (_) {},
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('mg'));
      await tester.pumpAndSettle();

      expect(find.text('mg'), findsWidgets);
      expect(find.text('g'), findsOneWidget);
      expect(find.text('ml'), findsOneWidget);
      expect(find.text('pills'), findsOneWidget);
    });

    testWidgets('handles invalid text input gracefully', (tester) async {
      double currentDose = 10.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DosageInput(
              dose: currentDose,
              unit: 'mg',
              units: const ['mg'],
              onDoseChanged: (newDose) {
                currentDose = newDose;
              },
              onUnitChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'invalid');
      expect(currentDose, 10.0); // Should keep previous value
    });

    testWidgets('validates dosage input', (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: DosageInput(
                dose: 0.0,
                unit: 'mg',
                units: const ['mg'],
                onDoseChanged: (_) {},
                onUnitChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      final isValid = formKey.currentState!.validate();
      await tester.pump();

      // Should not be valid for 0 dosage
      expect(isValid, false);
    });
  });
}
