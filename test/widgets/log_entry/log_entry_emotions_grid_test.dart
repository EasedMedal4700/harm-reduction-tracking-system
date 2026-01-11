import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/buttons/common_chip.dart';
import 'package:mobile_drug_use_app/constants/data/drug_use_catalog.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/log_entry_form.dart';

void main() {
  Widget createWidgetUnderTest({
    required List<String> selectedPrimary,
    required Map<String, List<String>> selectedSecondary,
  }) {
    final theme = AppTheme.light();

    return AppThemeProvider(
      theme: theme,
      child: MaterialApp(
        theme: theme.themeData,
        home: Scaffold(
          body: LogEntryForm(
            isSimpleMode: false,
            feelings: selectedPrimary,
            secondaryFeelings: selectedSecondary,
            substanceCtrl: TextEditingController(text: 'Test'),
            doseCtrl: TextEditingController(text: '1'),
            notesCtrl: TextEditingController(),
            onFeelingsChanged: (_) {},
            onSecondaryFeelingsChanged: (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('Primary emotions render as 2-column grid', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      createWidgetUnderTest(
        selectedPrimary: const [],
        selectedSecondary: const {},
      ),
    );

    // Uses catalog ordering: Happy then Calm.
    final happy = tester.getTopLeft(
      find.byKey(const ValueKey('primary_emotion_Happy')),
    );
    final calm = tester.getTopLeft(
      find.byKey(const ValueKey('primary_emotion_Calm')),
    );

    expect(happy.dy, equals(calm.dy));

    // Third (Anxious) should be next row with 2 columns.
    final anxious = tester.getTopLeft(
      find.byKey(const ValueKey('primary_emotion_Anxious')),
    );
    expect(anxious.dy, greaterThan(happy.dy));
  });

  testWidgets('Secondary emotions render 4 per row when shown', (tester) async {
    await tester.binding.setSurfaceSize(const Size(600, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      createWidgetUnderTest(
        selectedPrimary: const ['Happy'],
        selectedSecondary: const {},
      ),
    );
    await tester.pumpAndSettle();

    // Happy secondary options in catalog are 4 items.
    final opts = DrugUseCatalog.secondaryEmotions['Happy']!;
    expect(opts.length, 4);

    final dy = <double>[];
    for (final opt in opts) {
      final finder = find.byKey(ValueKey('secondary_Happy_$opt'));
      expect(finder, findsOneWidget);
      dy.add(tester.getTopLeft(finder).dy);
    }

    // All on same row -> same dy.
    expect(dy.toSet().length, 1);

    // Secondary chips have no emoji.
    final firstChip = tester.widget<CommonChip>(
      find.byKey(ValueKey('secondary_Happy_${opts.first}')),
    );
    expect(firstChip.emoji, isNull);
  });
}
