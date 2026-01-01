import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/set_new_password_page.dart';
import 'package:mobile_drug_use_app/core/providers/core_providers.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';

import '../../../mocks/supabase_mocks.mocks.dart';

void main() {
  group('SetNewPasswordPage', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    Widget buildApp() {
      final navigatorKey = GlobalKey<NavigatorState>();
      final nav = NavigationService()..bind(navigatorKey);
      final router = GoRouter(
        navigatorKey: navigatorKey,
        initialLocation: AppRoutePaths.setNewPassword,
        routes: [
          GoRoute(
            path: AppRoutePaths.setNewPassword,
            builder: (context, _) => const SetNewPasswordPage(),
          ),
          GoRoute(
            path: AppRoutePaths.login,
            builder: (context, _) => const Scaffold(body: Text('Login Page')),
          ),
          GoRoute(
            path: AppRoutePaths.forgotPassword,
            builder: (context, _) =>
                const Scaffold(body: Text('Forgot Password')),
          ),
        ],
      );

      return ProviderScope(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockSupabase),
          navigationProvider.overrideWithValue(nav),
        ],
        child: AppThemeProvider(
          theme: AppTheme.light(fontSize: 1.0, compactMode: false),
          child: MaterialApp.router(routerConfig: router),
        ),
      );
    }

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      when(mockSupabase.auth).thenReturn(mockAuth);
    });

    testWidgets('shows link expired UI when session is missing', (
      tester,
    ) async {
      when(mockAuth.currentSession).thenReturn(null);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(find.text('Link Expired'), findsOneWidget);
      expect(find.text('Request New Link'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });

    testWidgets('Request New Link navigates to forgot password', (
      tester,
    ) async {
      when(mockAuth.currentSession).thenReturn(null);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Request New Link'));
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password'), findsOneWidget);
    });

    testWidgets('successful submit updates password and navigates to login', (
      tester,
    ) async {
      when(mockAuth.currentSession).thenReturn(MockSession());
      when(
        mockAuth.updateUser(any),
      ).thenAnswer((_) async => MockUserResponse());
      when(mockAuth.signOut()).thenAnswer((_) async {});

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(2));

      await tester.enterText(fields.at(0), 'password123');
      await tester.enterText(fields.at(1), 'password123');

      await tester.tap(find.text('Update Password'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
      verify(mockAuth.updateUser(any)).called(1);
      verify(mockAuth.signOut()).called(1);
    });

    testWidgets(
      'mismatched passwords shows validation error and does not submit',
      (tester) async {
        when(mockAuth.currentSession).thenReturn(MockSession());

        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();

        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), 'password123');
        await tester.enterText(fields.at(1), 'different');

        await tester.tap(find.text('Update Password'));
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
        verifyNever(mockAuth.updateUser(any));
      },
    );

    testWidgets('AuthException shows error message', (tester) async {
      when(mockAuth.currentSession).thenReturn(MockSession());
      when(mockAuth.updateUser(any)).thenThrow(const AuthException('Nope'));

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'password123');
      await tester.enterText(fields.at(1), 'password123');

      await tester.tap(find.text('Update Password'));
      await tester.pumpAndSettle();

      expect(find.text('Nope'), findsOneWidget);
      verify(mockAuth.updateUser(any)).called(1);
    });
  });
}
