import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/buttons/common_chip.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/features/log_entry/widgets/log_entry/log_entry_form.dart';

void main() {
  Widget createWidgetUnderTest({required List<String> availableROAs}) {
    final theme = AppTheme.light();

    return AppThemeProvider(
      theme: theme,
      child: MaterialApp(
        theme: theme.themeData,
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: LogEntryForm(
              isSimpleMode: true,
              availableROAs: availableROAs,
              substanceCtrl: TextEditingController(text: 'LSD'),
              doseCtrl: TextEditingController(text: '10'),
              notesCtrl: TextEditingController(),
              onRouteChanged: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('ROA grid shows 3 primary buttons with emoji', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      createWidgetUnderTest(
        availableROAs: const ['oral', 'inhaled', 'insufflated'],
      ),
    );

    final oral = find.byKey(const ValueKey('roa_oral'));
    final inhaled = find.byKey(const ValueKey('roa_inhaled'));
    final insufflated = find.byKey(const ValueKey('roa_insufflated'));

    expect(oral, findsOneWidget);
    expect(inhaled, findsOneWidget);
    expect(insufflated, findsOneWidget);

    expect(tester.widget<CommonChip>(oral).emoji, '💊');
    expect(tester.widget<CommonChip>(inhaled).emoji, '💨');
    expect(tester.widget<CommonChip>(insufflated).emoji, '👃');
  });

  testWidgets('Extra DB ROA (sublingual) shows without emoji', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      createWidgetUnderTest(
        availableROAs: const ['oral', 'inhaled', 'insufflated', 'sublingual'],
      ),
    );

    final sublingual = find.byKey(const ValueKey('roa_sublingual'));
    expect(sublingual, findsOneWidget);
    expect(tester.widget<CommonChip>(sublingual).emoji, isNull);
  });

  testWidgets('Wide layout places 3 primary ROAs on one row', (tester) async {
    await tester.binding.setSurfaceSize(const Size(600, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      createWidgetUnderTest(
        availableROAs: const ['oral', 'inhaled', 'insufflated', 'sublingual'],
      ),
    );

    final oral = tester.getTopLeft(find.byKey(const ValueKey('roa_oral')));
    final inhaled = tester.getTopLeft(
      find.byKey(const ValueKey('roa_inhaled')),
    );
    final insufflated = tester.getTopLeft(
      find.byKey(const ValueKey('roa_insufflated')),
    );

    expect(oral.dy, equals(inhaled.dy));
    expect(oral.dy, equals(insufflated.dy));
  });

  testWidgets('Narrow layout wraps 3rd primary ROA to next row', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      createWidgetUnderTest(
        // include extras so wrap layout is exercised
        availableROAs: const ['oral', 'inhaled', 'insufflated', 'sublingual'],
      ),
    );

    final oral = tester.getTopLeft(find.byKey(const ValueKey('roa_oral')));
    final inhaled = tester.getTopLeft(
      find.byKey(const ValueKey('roa_inhaled')),
    );
    final insufflated = tester.getTopLeft(
      find.byKey(const ValueKey('roa_insufflated')),
    );

    expect(oral.dy, equals(inhaled.dy));
    expect(insufflated.dy, greaterThan(oral.dy));
  });
}
