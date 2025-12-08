import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/common/old_common/harm_reduction_banner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HarmReductionBanner', () {
    setUp(() {
      // Initialize SharedPreferences for tests
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('displays default message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HarmReductionBanner(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Harm Reduction Notice'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('displays custom message', (tester) async {
      const customMessage = 'Custom warning message';
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HarmReductionBanner(message: customMessage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('shows dismiss button when dismissKey is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HarmReductionBanner(
              dismissKey: 'test_key',
              onDismiss: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('hides dismiss button when dismissKey is not provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HarmReductionBanner(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onDismiss when dismiss button is tapped', (tester) async {
      bool dismissed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HarmReductionBanner(
              dismissKey: 'test_dismiss_key',
              onDismiss: () => dismissed = true,
            ),
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
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: HarmReductionBanner(),
          ),
        ),
      );

      expect(find.text('Harm Reduction Notice'), findsOneWidget);
    });

    testWidgets('renders in dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: HarmReductionBanner(),
          ),
        ),
      );

      expect(find.text('Harm Reduction Notice'), findsOneWidget);
    });
  });
}
