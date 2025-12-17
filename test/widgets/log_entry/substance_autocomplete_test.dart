import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/widgets/log_entry/substance_autocomplete.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('SubstanceAutocomplete', () {
    testWidgets('renders text field with icon', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        wrapWithAppTheme(
          SubstanceAutocomplete(
            controller: controller,
            options: const ['Nicotine', 'Caffeine'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.science), findsOneWidget);
      expect(find.text('Substance'), findsOneWidget);
    });

    testWidgets('updates external controller when typing', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        wrapWithAppTheme(
          SubstanceAutocomplete(
            controller: controller,
            options: const ['Nicotine', 'Caffeine'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Nicotine');
      await tester.pump();

      expect(controller.text, 'Nicotine');
    });

    testWidgets('selecting an option populates controller', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        wrapWithAppTheme(
          SubstanceAutocomplete(
            controller: controller,
            options: const ['Nicotine', 'Caffeine'],
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'nic');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Nicotine').last);
      await tester.pumpAndSettle();

      expect(controller.text, 'Nicotine');
    });
  });
}
