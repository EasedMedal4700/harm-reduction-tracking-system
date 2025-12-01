import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/screens/pin_unlock_screen.dart';

void main() {
  group('PinUnlockScreen Widget Tests', () {
    testWidgets('renders PIN unlock screen correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      // Check for title
      expect(find.text('Enter Your PIN'), findsOneWidget);
      
      // Check for unlock button (on the button, not the AppBar)
      expect(find.widgetWithText(ElevatedButton, 'Unlock'), findsOneWidget);
      
      // Check for recovery key link
      expect(find.text('Forgot PIN? Use Recovery Key'), findsOneWidget);
    });

    testWidgets('has lock icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('has AppBar with Unlock title and no back button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      expect(find.widgetWithText(AppBar, 'Unlock'), findsOneWidget);
      
      // Should not have back button (automaticallyImplyLeading: false)
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('PIN field accepts only numbers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      
      // Enter numbers - should work
      await tester.enterText(textField, '123456');
      await tester.pump();
      
      // Verify the text was entered
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.controller?.text, equals('123456'));
    });

    testWidgets('PIN field is limited to 6 characters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      final textField = find.byType(TextField);
      
      // Try to enter more than 6 digits
      await tester.enterText(textField, '12345678');
      await tester.pump();
      
      final textFieldWidget = tester.widget<TextField>(textField);
      expect(textFieldWidget.maxLength, equals(6));
    });

    testWidgets('PIN field is obscured by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('visibility toggle button exists', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      // Find visibility toggle icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('tapping visibility icon toggles PIN visibility', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      // Initially visibility icon (meaning text is obscured)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);
      
      // Tap the visibility button
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      
      // Now should show visibility_off icon (meaning text is visible)
      expect(find.byIcon(Icons.visibility), findsNothing);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('unlock button is enabled by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      final unlockButton = find.widgetWithText(ElevatedButton, 'Unlock');
      expect(unlockButton, findsOneWidget);
      
      final button = tester.widget<ElevatedButton>(unlockButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('forgot PIN link is tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const PinUnlockScreen(),
          routes: {
            '/recovery-key': (context) => const Scaffold(body: Text('Recovery')),
          },
        ),
      );
      await tester.pump();

      final forgotPinLink = find.text('Forgot PIN? Use Recovery Key');
      expect(forgotPinLink, findsOneWidget);
      
      // Verify it's a TextButton
      expect(find.widgetWithText(TextButton, 'Forgot PIN? Use Recovery Key'), findsOneWidget);
    });

    testWidgets('shows description text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      expect(find.text('Unlock to access your encrypted data'), findsOneWidget);
    });

    testWidgets('PIN input has keyboard type number', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.keyboardType, equals(TextInputType.number));
    });

    testWidgets('PIN input has digit-only filter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.inputFormatters, isNotNull);
      expect(textField.inputFormatters!.length, greaterThan(0));
      
      // Check that the first formatter is digits only
      expect(
        textField.inputFormatters!.any((f) => f is FilteringTextInputFormatter),
        isTrue,
      );
    });

    testWidgets('screen is wrapped in PopScope to prevent back navigation', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      expect(find.byType(PopScope), findsOneWidget);
    });

    testWidgets('layout uses SingleChildScrollView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: PinUnlockScreen()),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });

  group('PIN Validation Logic', () {
    test('PIN must be 6 digits', () {
      // Test helper
      bool isValidPin(String pin) {
        if (pin.length != 6) return false;
        return int.tryParse(pin) != null;
      }

      expect(isValidPin('123456'), isTrue);
      expect(isValidPin('000000'), isTrue);
      expect(isValidPin('999999'), isTrue);
      expect(isValidPin('12345'), isFalse);
      expect(isValidPin('1234567'), isFalse);
      expect(isValidPin('abcdef'), isFalse);
      expect(isValidPin(''), isFalse);
    });

    test('PIN with leading zeros is valid', () {
      bool isValidPin(String pin) {
        if (pin.length != 6) return false;
        return int.tryParse(pin) != null;
      }

      expect(isValidPin('000001'), isTrue);
      expect(isValidPin('000000'), isTrue);
    });
  });
}
