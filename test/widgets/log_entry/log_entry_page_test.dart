import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_page.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_controller.dart';
import 'package:mobile_drug_use_app/features/log_entry/models/log_entry_form_data.dart';
import 'package:mobile_drug_use_app/features/log_entry/providers/log_entry_providers.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'log_entry_page_test.mocks.dart';

class FakeLogEntryNotifier extends LogEntryNotifier {
  @override
  LogEntryFormData build() {
    return LogEntryFormData.initial();
  }

  @override
  void setSubstance(String value) {
    state = state.copyWith(substance: value);
  }

  @override
  List<String> getAvailableROAs() => ['Oral', 'Insufflated'];

  @override
  bool isROAValidated(String roa) => true;
}

@GenerateMocks([LogEntryController])
void main() {
  late MockLogEntryController mockController;

  setUp(() {
    mockController = MockLogEntryController();

    // Stub common methods
    when(
      mockController.loadSubstanceDetails(any),
    ).thenAnswer((_) async => null);
    when(
      mockController.getAvailableROAs(any),
    ).thenReturn(['Oral', 'Insufflated']);
    when(mockController.isROAValidated(any, any)).thenReturn(true);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        logEntryProvider.overrideWith(() => FakeLogEntryNotifier()),
        logEntryControllerProvider.overrideWithValue(mockController),
      ],
      child: AppThemeProvider(
        theme: AppTheme.light(),
        child: const MaterialApp(home: QuickLogEntryPage()),
      ),
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
