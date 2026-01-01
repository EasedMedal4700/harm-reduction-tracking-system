import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/data/drug_categories.dart';
import 'package:mobile_drug_use_app/features/catalog/services/drug_profile_service.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/log_entry_form.dart';

import '../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets(
    'Substance autocomplete renders per-category colors (not default)',
    (tester) async {
      final substanceCtrl = TextEditingController();

      Future<Iterable<DrugSearchResult>> fakeOptions(String query) async {
        if (query.trim().isEmpty) return const [];
        return [
          DrugSearchResult(
            displayName: 'LSD',
            canonicalName: 'LSD',
            isAlias: false,
            category: 'Psychedelic',
          ),
          DrugSearchResult(
            displayName: 'Morphine',
            canonicalName: 'Morphine',
            isAlias: false,
            category: 'Opioid',
          ),
        ];
      }

      await tester.pumpWidget(
        wrapWithAppTheme(
          LogEntryForm(
            isSimpleMode: true,
            substanceCtrl: substanceCtrl,
            categoryAccent: DrugCategoryColors.colorFor('Psychedelic'),
            doseCtrl: TextEditingController(),
            onSubstanceChanged: (_) {},
            onUnitChanged: (_) {},
            onDoseChanged: (_) {},
            onRouteChanged: (_) {},
            onLocationChanged: (_) {},
            onDateChanged: (_) {},
            onHourChanged: (_) {},
            onMinuteChanged: (_) {},
            onMedicalPurposeChanged: (_) {},
            onCravingIntensityChanged: (_) {},
            onIntentionChanged: (_) {},
            onTriggersChanged: (_) {},
            onBodySignalsChanged: (_) {},
            onSave: () {},
            substanceOptionsBuilder: fakeOptions,
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'l');
      await tester.pumpAndSettle();

      final lsdText = tester.widget<Text>(find.text('LSD'));
      final morphineText = tester.widget<Text>(find.text('Morphine'));

      final expectedPsychedelic = DrugCategoryColors.colorFor('Psychedelic');
      final expectedOpioid = DrugCategoryColors.colorFor('Opioid');

      expect(lsdText.style?.color, expectedPsychedelic);
      expect(morphineText.style?.color, expectedOpioid);
      expect(expectedPsychedelic, isNot(expectedOpioid));

      // The field tint is driven by the page-derived categoryAccent.
      await tester.tap(find.byType(TextFormField).first);
      await tester.pump();

      final editable = tester.widget<EditableText>(
        find.byType(EditableText).first,
      );
      expect(editable.cursorColor, expectedPsychedelic);
    },
  );
}
