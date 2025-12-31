import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/catalog/services/drug_profile_service.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/log_entry_form.dart';
import '../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets('Substance autocomplete normalizes alias to canonical', (
    tester,
  ) async {
    final substanceCtrl = TextEditingController();

    Future<Iterable<DrugSearchResult>> fakeOptions(String query) async {
      if (!query.toLowerCase().contains('dex')) return const [];
      return [
        DrugSearchResult(
          displayName: 'dexedrine → Dextroamphetamine',
          canonicalName: 'Dextroamphetamine',
          isAlias: true,
        ),
      ];
    }

    await tester.pumpWidget(
      wrapWithAppTheme(
        LogEntryForm(
          isSimpleMode: true,
          substanceCtrl: substanceCtrl,
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

    await tester.enterText(find.byType(TextFormField).first, 'dex');
    await tester.pumpAndSettle();

    expect(find.text('dexedrine → Dextroamphetamine'), findsOneWidget);
    await tester.tap(find.text('dexedrine → Dextroamphetamine'));
    await tester.pump();

    expect(substanceCtrl.text, 'Dextroamphetamine');
  });
}
