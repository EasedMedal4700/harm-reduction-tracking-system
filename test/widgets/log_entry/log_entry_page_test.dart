import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_page.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';

void main() {
  Widget createWidgetUnderTest() {
    return AppThemeProvider(
      theme: AppTheme.light(),
      child: const MaterialApp(home: QuickLogEntryPage()),
    );
  }

  group('QuickLogEntryPage Widget Tests', () {
    testWidgets('renders all form fields correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify core fields exist
      expect(find.text('Substance'), findsOneWidget);
      expect(find.text('Dose'), findsOneWidget);
      // Route dropdown defaults to 'Oral'
      expect(find.text('Oral'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);

      // Verify Save button exists
      expect(find.text('Save Entry'), findsOneWidget);
    });

    testWidgets('shows validation error when saving empty form', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap save without filling anything
      await tester.tap(find.text('Save Entry'));
      await tester.pumpAndSettle();

      // Should show validation error snackbar or dialog
      // The implementation uses _showSnackBar('Please fix validation errors before saving.')
      expect(
        find.text('Please fix validation errors before saving.'),
        findsOneWidget,
      );
    });

    testWidgets('updates state when fields are modified', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter substance
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Substance'),
        'Caffeine',
      );

      // Enter dose
      await tester.enterText(find.widgetWithText(TextFormField, 'Dose'), '100');

      // Enter notes
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Notes'),
        'Morning coffee',
      );

      await tester.pumpAndSettle();

      // Verify text is in fields
      expect(find.text('Caffeine'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Morning coffee'), findsOneWidget);
    });
  });
}
