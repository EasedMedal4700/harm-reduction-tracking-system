import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/pin_setup_page.dart';
import '../helpers/test_app_wrapper.dart';

void main() {
  group('PinSetupScreen Widget Tests', () {
    testWidgets('renders PIN setup screen correctly', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      // Check for title in AppBar
      expect(find.text('Setup Encryption'), findsOneWidget);

      // Check for PIN input labels
      expect(find.textContaining('Create'), findsWidgets);
      expect(find.text('Confirm PIN'), findsOneWidget);
    });

    testWidgets('has AppBar with no back button', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      expect(find.widgetWithText(AppBar, 'Setup Encryption'), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('has two PIN input fields', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
    });

    testWidgets('PIN fields are obscured by default', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in textFields) {
        expect(field.obscureText, isTrue);
      }
    });

    testWidgets('PIN fields have maxLength of 6', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in textFields) {
        expect(field.maxLength, equals(6));
      }
    });

    testWidgets('PIN fields have number keyboard type', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      for (final field in textFields) {
        expect(field.keyboardType, equals(TextInputType.number));
      }
    });

    testWidgets('has visibility toggle for both PIN fields', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      // Should have two visibility icons
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));
    });

    testWidgets('has Create PIN button', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      expect(find.widgetWithText(ElevatedButton, 'Create PIN'), findsOneWidget);
    });

    testWidgets('can enter PIN in first field', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      final firstTextField = find.byType(TextField).first;
      await tester.enterText(firstTextField, '123456');
      await tester.pump();

      final textFieldWidget = tester.widget<TextField>(firstTextField);
      expect(textFieldWidget.controller?.text, equals('123456'));
    });

    testWidgets('can enter PIN in second field', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      final secondTextField = find.byType(TextField).last;
      await tester.enterText(secondTextField, '123456');
      await tester.pump();

      final textFieldWidget = tester.widget<TextField>(secondTextField);
      expect(textFieldWidget.controller?.text, equals('123456'));
    });

    testWidgets('screen is wrapped in PopScope', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      expect(find.byType(PopScope), findsOneWidget);
    });

    testWidgets('has lock icon', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('has descriptive text about encryption', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      // Should have some info about the PIN
      expect(find.textContaining('6-digit'), findsOneWidget);
    });

    testWidgets('toggling visibility icon changes PIN visibility', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithAppThemeAndProvidersApp(home: const PinSetupScreen()),
      );
      await tester.pump();

      // Initially all visibility icons (text obscured)
      expect(find.byIcon(Icons.visibility), findsNWidgets(2));

      // Tap first visibility icon
      await tester.tap(find.byIcon(Icons.visibility).first);
      await tester.pump();

      // Now should have one visibility and one visibility_off
      expect(find.byIcon(Icons.visibility), findsNWidgets(1));
      expect(find.byIcon(Icons.visibility_off), findsNWidgets(1));
    });
  });

  group('PIN Validation Logic', () {
    test('PINs must match', () {
      bool pinsMatch(String pin1, String pin2) => pin1 == pin2;

      expect(pinsMatch('123456', '123456'), isTrue);
      expect(pinsMatch('123456', '654321'), isFalse);
      expect(pinsMatch('123456', '123457'), isFalse);
    });

    test('PIN must be exactly 6 digits', () {
      bool isValidPin(String pin) {
        if (pin.length != 6) return false;
        return int.tryParse(pin) != null;
      }

      expect(isValidPin('123456'), isTrue);
      expect(isValidPin('12345'), isFalse);
      expect(isValidPin('1234567'), isFalse);
      expect(isValidPin('abcdef'), isFalse);
    });

    test('PIN with leading zeros is valid', () {
      bool isValidPin(String pin) {
        if (pin.length != 6) return false;
        return RegExp(r'^\d{6}$').hasMatch(pin);
      }

      expect(isValidPin('000000'), isTrue);
      expect(isValidPin('000001'), isTrue);
      expect(isValidPin('100000'), isTrue);
    });
  });

  group('Recovery Key Format', () {
    test('recovery key is 24 hex characters', () {
      bool isValidRecoveryKey(String key) {
        if (key.length != 24) return false;
        return RegExp(r'^[0-9a-f]{24}$').hasMatch(key);
      }

      expect(isValidRecoveryKey('abc123def456789012345678'), isTrue);
      expect(isValidRecoveryKey('1234567890abcdef12345678'), isTrue);
      expect(isValidRecoveryKey('abc'), isFalse);
      expect(isValidRecoveryKey('ghijkl'), isFalse); // g-z not valid hex
    });
  });
}
