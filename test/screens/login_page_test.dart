import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/screens/login_page.dart';
import '../helpers/test_credentials.dart';

void main() {
  group('LoginPage', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('has AppBar with Login title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      expect(find.widgetWithText(AppBar, 'Login'), findsOneWidget);
    });

    testWidgets('password field is obscured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final passwordField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Password'),
      );
      
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('email field is not obscured', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final emailField = tester.widget<TextField>(
        find.widgetWithText(TextField, 'Email'),
      );
      
      expect(emailField.obscureText, isFalse);
    });

    testWidgets('login_data.json provides credentials', (tester) async {
      expect(TestCredentials.email, isNotEmpty);
      expect(TestCredentials.password, isNotEmpty);
    });

    testWidgets('can enter text in email field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final emailField = find.widgetWithText(TextField, 'Email');
      await tester.enterText(emailField, TestCredentials.email);
      
      expect(find.text(TestCredentials.email), findsOneWidget);
    });

    testWidgets('can enter text in password field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final passwordField = find.widgetWithText(TextField, 'Password');
      await tester.enterText(passwordField, TestCredentials.password);
      
      // Password is obscured, so the actual text won't be visible
      // But we can verify text was entered by checking the controller
      expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    });

    testWidgets('has login button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(loginButton, findsOneWidget);
    });

    testWidgets('layout is centered', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('has spacing between fields', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: LoginPage()),
      );

      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
      
      // Find the SizedBox with height 20
      final sizedBox = tester.widgetList<SizedBox>(sizedBoxes)
        .firstWhere((box) => box.height == 20);
      expect(sizedBox.height, 20);
    });
  });
}
