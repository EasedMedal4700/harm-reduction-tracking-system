// Comprehensive widget test for LoginPage
// Covers: UI rendering, interactions, state updates, navigation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/features/login/login/login_controller.dart';
import 'package:mobile_drug_use_app/features/login/login/login_page.dart';
import 'package:mobile_drug_use_app/features/login/login/login_state.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';

// Fake implementation of LoginController to avoid StateNotifier mocking issues
class FakeLoginController extends LoginController {
  // Tracking calls for verification
  String? lastEmail;
  String? lastPassword;
  bool? lastRememberMe;

  LoginState _testState = const LoginState();

  @override
  LoginState build() {
    return _testState;
  }

  @override
  Future<void> submitLogin({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
  }

  @override
  void toggleRememberMe(bool value) {
    lastRememberMe = value;
    state = state.copyWith(rememberMe: value);
  }

  // Helper to set state directly for testing
  void setState(LoginState newState) {
    _testState = newState;
    try {
      state = newState;
    } catch (_) {
      // If the notifier is not yet initialized (mounted), we can't set state.
      // That's fine, because build() will return _testState when it initializes.
    }
  }
}

void main() {
  late FakeLoginController fakeController;

  setUp(() {
    fakeController = FakeLoginController();
  });

  Widget createTestWidget(LoginState state) {
    fakeController.setState(state);

    final navigatorKey = GlobalKey<NavigatorState>();
    final nav = NavigationService()..bind(navigatorKey);

    final router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppRoutePaths.login,
      routes: [
        GoRoute(
          path: AppRoutePaths.login,
          builder: (context, _) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutePaths.forgotPassword,
          builder: (context, _) =>
              const Scaffold(body: Text('Forgot Password')),
        ),
        GoRoute(
          path: AppRoutePaths.register,
          builder: (context, _) => const Scaffold(body: Text('Sign Up')),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        loginControllerProvider.overrideWith(() => fakeController),
        navigationProvider.overrideWithValue(nav),
      ],
      child: AppThemeProvider(
        theme: AppTheme.light(fontSize: 1.0, compactMode: false),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }

  group('LoginPage - UI Elements', () {
    testWidgets('renders all UI elements', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Keep me logged in'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text("Don’t have an account?"), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('email field has correct keyboard type', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      final emailField = find.widgetWithText(TextField, 'Email');
      expect(emailField, findsOneWidget);

      final textField = tester.widget<TextField>(emailField);
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('password field is obscured', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      final passwordField = find.widgetWithText(TextField, 'Password');
      expect(passwordField, findsOneWidget);

      final textField = tester.widget<TextField>(passwordField);
      expect(textField.obscureText, true);
    });

    testWidgets('displays error message when present', (tester) async {
      const errorState = LoginState(errorMessage: 'Invalid credentials');
      await tester.pumpWidget(createTestWidget(errorState));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('hides error message when null', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));
      await tester.pumpAndSettle();

      expect(find.textContaining('Invalid'), findsNothing);
      expect(find.textContaining('Error'), findsNothing);
    });
  });

  group('LoginPage - Interactions', () {
    testWidgets('can enter email and password', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password123',
      );

      expect(find.text('test@test.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('tapping sign in calls submitLogin', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'test@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'password',
      );

      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(fakeController.lastEmail, 'test@test.com');
      expect(fakeController.lastPassword, 'password');
    });

    testWidgets('remember me checkbox toggles state', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      final checkbox = find.byType(CheckboxListTile);
      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();

      expect(fakeController.lastRememberMe, true);
    });

    testWidgets('forgot password button navigates', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
    });

    testWidgets('sign up button navigates', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsOneWidget);
    });
  });

  group('LoginPage - Loading State', () {
    testWidgets('shows loading indicator when isLoading is true', (
      tester,
    ) async {
      const loadingState = LoginState(isLoading: true);
      await tester.pumpWidget(createTestWidget(loadingState));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('disables button when loading', (tester) async {
      const loadingState = LoginState(isLoading: true);
      await tester.pumpWidget(createTestWidget(loadingState));
      await tester.pump();

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(button.onPressed, null);
    });
  });

  group('LoginPage - Remember Me State', () {
    testWidgets('checkbox reflects rememberMe state', (tester) async {
      const state = LoginState(rememberMe: true);
      await tester.pumpWidget(createTestWidget(state));

      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );

      expect(checkbox.value, true);
    });

    testWidgets('checkbox is unchecked by default', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );

      expect(checkbox.value, false);
    });
  });

  group('LoginPage - Accessibility', () {
    testWidgets('has correct semantics for screen readers', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      expect(find.bySemanticsLabel('Email'), findsWidgets);
    });

    testWidgets('buttons are tappable with sufficient size', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginState()));

      final signInButton = tester.getSize(
        find.ancestor(
          of: find.text('Sign in'),
          matching: find.byType(ElevatedButton),
        ),
      );

      expect(signInButton.width, greaterThanOrEqualTo(48.0));
      expect(signInButton.height, greaterThanOrEqualTo(48.0));
    });
  });
}
