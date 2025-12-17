import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/log_entry_form.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/data/drug_use_catalog.dart';

import 'package:mobile_drug_use_app/common/buttons/common_chip.dart';

void main() {
  Widget createWidgetUnderTest({
    required bool isSimpleMode,
    ValueChanged<bool>? onMedicalPurposeChanged,
    ValueChanged<double>? onCravingIntensityChanged,
    ValueChanged<List<String>>? onFeelingsChanged,
  }) {
    final theme = AppTheme.light();
    
    return AppThemeProvider(
      theme: theme,
      child: MaterialApp(
        theme: theme.themeData,
        home: Scaffold(
          body: SingleChildScrollView(
            child: LogEntryForm(
              isSimpleMode: isSimpleMode,
              onMedicalPurposeChanged: onMedicalPurposeChanged,
              onCravingIntensityChanged: onCravingIntensityChanged,
              onFeelingsChanged: onFeelingsChanged,
              substanceCtrl: TextEditingController(),
              doseCtrl: TextEditingController(),
              notesCtrl: TextEditingController(),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('Simple mode shows basic inputs only', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(isSimpleMode: true));

    // Basic inputs should be present
    expect(find.text('Substance'), findsOneWidget);
    expect(find.text('Dose'), findsOneWidget);
    // Route defaults to 'oral', so we look for 'Oral' (capitalized by itemLabel)
    expect(find.text('Oral'), findsOneWidget); 
    expect(find.text('Time'), findsOneWidget); // Label
    // Location defaults to 'Select a location'
    expect(find.text('Select a location'), findsOneWidget); 
    expect(find.text('Medical Purpose'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);

    // Complex inputs should NOT be present
    // Intention defaults to '-- Select Intention--'
    expect(find.text('-- Select Intention--'), findsNothing);
    expect(find.text('Craving Intensity'), findsNothing);
    expect(find.text('Emotions'), findsNothing);
    expect(find.text('Triggers'), findsNothing);
    expect(find.text('Body Signals'), findsNothing);
  });

  testWidgets('Complex mode shows all inputs', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(isSimpleMode: false));

    // Basic inputs should be present
    expect(find.text('Substance'), findsOneWidget);
    expect(find.text('Dose'), findsOneWidget);
    expect(find.text('Medical Purpose'), findsOneWidget);

    // Complex inputs should be present
    expect(find.text('-- Select Intention--'), findsOneWidget);
    expect(find.text('Craving Intensity'), findsOneWidget);
    expect(find.text('Emotions'), findsOneWidget);
    expect(find.text('Triggers'), findsOneWidget);
    expect(find.text('Body Signals'), findsOneWidget);
  });

  testWidgets('Medical Purpose switch works', (WidgetTester tester) async {
    bool? medicalPurpose;
    await tester.pumpWidget(createWidgetUnderTest(
      isSimpleMode: true,
      onMedicalPurposeChanged: (val) => medicalPurpose = val,
    ));

    await tester.tap(find.text('Medical Purpose'));
    await tester.pump();

    expect(medicalPurpose, isTrue);
  });

  testWidgets('Craving Intensity slider works', (WidgetTester tester) async {
    double? craving;
    await tester.pumpWidget(createWidgetUnderTest(
      isSimpleMode: false,
      onCravingIntensityChanged: (val) => craving = val,
    ));

    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);

    await tester.tap(sliderFinder);
    await tester.pump();

    expect(craving, isNotNull);
  });

  testWidgets('Emotions selection works', (WidgetTester tester) async {
    List<String>? feelings;
    await tester.pumpWidget(createWidgetUnderTest(
      isSimpleMode: false,
      onFeelingsChanged: (val) => feelings = val,
    ));

    // Find an emotion chip (e.g., 'Happy')
    final emotion = DrugUseCatalog.primaryEmotions.first['name']!;
    
    // Find the CommonChip with the specific label
    // Using .first to resolve potential ambiguity if multiple widgets match
    final chipFinder = find.widgetWithText(CommonChip, emotion).first;
    
    await tester.ensureVisible(chipFinder);
    await tester.tap(chipFinder);
    await tester.pump();

    expect(feelings, contains(emotion));
  });
}
