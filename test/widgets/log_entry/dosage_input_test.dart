import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/dosage_input.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('DosageInput', () {
    testWidgets('renders label with unit', (tester) async {
      final controller = TextEditingController(text: '10');

      await tester.pumpWidget(
        wrapWithAppTheme(DosageInput(controller: controller, unit: 'mg')),
      );

      expect(find.text('Dosage (mg)'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('updates controller on text input', (tester) async {
      final controller = TextEditingController(text: '10');

      await tester.pumpWidget(
        wrapWithAppTheme(DosageInput(controller: controller, unit: 'mg')),
      );

      await tester.enterText(find.byType(TextFormField), '25.5');
      await tester.pump();

      expect(controller.text, '25.5');
    });

    testWidgets('validates required + numeric', (tester) async {
      final controller = TextEditingController(text: '');
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        wrapWithAppTheme(
          Form(
            key: formKey,
            child: DosageInput(controller: controller, unit: 'mg'),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);

      controller.text = 'abc';
      await tester.pump();
      expect(formKey.currentState!.validate(), isFalse);

      controller.text = '10';
      await tester.pump();
      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
