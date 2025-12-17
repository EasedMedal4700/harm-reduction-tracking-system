import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/complex_fields.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  group('ComplexFields', () {
    testWidgets('renders dropdown and text fields', (tester) async {
      final notes = TextEditingController();
      final location = TextEditingController();
      final people = TextEditingController();
      final cost = TextEditingController();

      await tester.pumpWidget(
        wrapWithAppTheme(
          SingleChildScrollView(
            child: ComplexFields(
              notesController: notes,
              locationController: location,
              peopleController: people,
              costController: cost,
              selectedRoa: null,
              roaOptions: const ['oral', 'inhaled'],
              onRoaChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.text('People (comma separated)'), findsOneWidget);
      expect(find.text('Cost'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
    });

    testWidgets('shows selected ROA', (tester) async {
      final notes = TextEditingController();
      final location = TextEditingController();
      final people = TextEditingController();
      final cost = TextEditingController();

      await tester.pumpWidget(
        wrapWithAppTheme(
          SingleChildScrollView(
            child: ComplexFields(
              notesController: notes,
              locationController: location,
              peopleController: people,
              costController: cost,
              selectedRoa: 'oral',
              roaOptions: const ['oral', 'inhaled'],
              onRoaChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('oral'), findsOneWidget);
    });
  });
}
