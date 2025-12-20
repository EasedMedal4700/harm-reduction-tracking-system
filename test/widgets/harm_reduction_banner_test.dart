import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/feedback/harm_reduction_banner.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HarmReductionBanner', () {
    setUp(() {
      // Initialize SharedPreferences for tests
      SharedPreferences.setMockInitialValues({});
    });

    Widget createWidgetUnderTest(
      Widget child, {
      Brightness brightness = Brightness.light,
    }) {
      final theme = brightness == Brightness.light
          ? AppTheme.light()
          : AppTheme.dark();
      return AppThemeProvider(
        theme: theme,
        child: MaterialApp(
          theme: theme.themeData,
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('displays default message', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(const HarmReductionBanner()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Harm Reduction Notice'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('displays custom message', (tester) async {
      const customMessage = 'Custom warning message';

      await tester.pumpWidget(
        createWidgetUnderTest(
          const HarmReductionBanner(message: customMessage),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('shows dismiss button when dismissKey is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          HarmReductionBanner(dismissKey: 'test_key', onDismiss: () {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('hides dismiss button when dismissKey is not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(const HarmReductionBanner()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onDismiss when dismiss button is tapped', (
      tester,
    ) async {
      bool dismissed = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          HarmReductionBanner(
            dismissKey: 'test_dismiss_key',
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(dismissed, true);
    });

    testWidgets('renders in light theme', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const HarmReductionBanner(),
          brightness: Brightness.light,
        ),
      );

      expect(find.text('Harm Reduction Notice'), findsOneWidget);
    });

    testWidgets('renders in dark theme', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          const HarmReductionBanner(),
          brightness: Brightness.dark,
        ),
      );

      expect(find.text('Harm Reduction Notice'), findsOneWidget);
    });
  });
}
