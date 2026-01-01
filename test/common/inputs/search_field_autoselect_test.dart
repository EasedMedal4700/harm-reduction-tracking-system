import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/inputs/search_field.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets('CommonSearchField auto-selects when only one option remains', (
    tester,
  ) async {
    final controller = TextEditingController();
    String? selected;

    Future<Iterable<String>> optionsBuilder(String query) async {
      if (query.trim().isEmpty) return const <String>[];
      if (query.toLowerCase().contains('dex')) {
        return const <String>['Dextroamphetamine'];
      }
      return const <String>[];
    }

    await tester.pumpWidget(
      wrapWithAppTheme(
        Padding(
          padding: const EdgeInsets.all(16),
          child: CommonSearchField<String>(
            controller: controller,
            labelText: 'Substance',
            optionsBuilder: optionsBuilder,
            displayStringForOption: (s) => s,
            itemBuilder: (context, s) => Text(s),
            onSelected: (s) => selected = s,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'dex');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    expect(selected, 'Dextroamphetamine');
    expect(controller.text, 'Dextroamphetamine');
  });
}
