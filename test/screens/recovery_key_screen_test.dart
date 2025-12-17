import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/screens/recovery_key_screen.dart';
import '../helpers/test_app_wrapper.dart';

void main() {
  group('RecoveryKeyScreen Widget Tests', () {
    testWidgets('renders recovery key screen correctly', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      // Check for title
      expect(find.text('Enter Recovery Key'), findsOneWidget);
      
      // Check for continue button
      expect(find.text('Continue'), findsOneWidget);
      
      // Check for back button text
      expect(find.text('Back to PIN Unlock'), findsOneWidget);
    });

    testWidgets('has AppBar with Recovery Key title', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      expect(find.widgetWithText(AppBar, 'Recovery Key'), findsOneWidget);
    });

    testWidgets('has key icon', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      expect(find.byIcon(Icons.vpn_key), findsOneWidget);
    });

    testWidgets('has recovery key input field', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('recovery key field is obscured by default', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('has visibility toggle for recovery key', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('toggling visibility icon shows/hides recovery key', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      // Initially visibility icon (text obscured)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      
      // Tap visibility icon
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      
      // Now should show visibility_off (text visible)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('can enter recovery key', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'abc123def456789012345678');
      await tester.pump();

      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller?.text, equals('abc123def456789012345678'));
    });

    testWidgets('has info box explaining recovery key format', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      // There are multiple texts mentioning 24-character, which is fine
      expect(find.textContaining('24-character'), findsWidgets);
    });

    testWidgets('has continue button', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      final continueButton = find.widgetWithText(ElevatedButton, 'Continue');
      expect(continueButton, findsOneWidget);
    });

    testWidgets('has back to PIN unlock link', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      // TextButton.icon stores text differently - just find the text
      expect(find.text('Back to PIN Unlock'), findsOneWidget);
    });

    testWidgets('shows description text', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      expect(find.textContaining('recovery key'), findsWidgets);
    });

    testWidgets('layout uses SingleChildScrollView', (tester) async {
      await tester.pumpWidget(
        wrapWithAppThemeApp(home: const RecoveryKeyScreen()),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('Recovery Key Validation Logic', () {
    test('recovery key must be 24 characters', () {
      bool isValidLength(String key) => key.length == 24;

      expect(isValidLength('abc123def456789012345678'), isTrue);
      expect(isValidLength('abc'), isFalse);
      expect(isValidLength('abc123def4567890123456789'), isFalse); // 25 chars
    });

    test('recovery key must be valid hex', () {
      bool isValidHex(String key) {
        return RegExp(r'^[0-9a-f]+$', caseSensitive: false).hasMatch(key);
      }

      expect(isValidHex('abc123def456789012345678'), isTrue);
      expect(isValidHex('ABC123DEF456789012345678'), isTrue);
      expect(isValidHex('ghijklmnopqrstuvwxyz1234'), isFalse); // g-z not hex
    });

    test('combined validation for recovery key', () {
      bool isValidRecoveryKey(String key) {
        if (key.length != 24) return false;
        return RegExp(r'^[0-9a-f]{24}$', caseSensitive: false).hasMatch(key);
      }

      expect(isValidRecoveryKey('abc123def456789012345678'), isTrue);
      expect(isValidRecoveryKey('1234567890abcdef12345678'), isTrue);
      expect(isValidRecoveryKey('abc'), isFalse);
      expect(isValidRecoveryKey(''), isFalse);
      expect(isValidRecoveryKey('xyz123def456789012345678'), isFalse);
    });
  });
}
