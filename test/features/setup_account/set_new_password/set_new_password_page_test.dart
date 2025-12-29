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

import '../../../mocks/supabase_mocks.mocks.dart';

void main() {
  group('SetNewPasswordPage', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    Widget buildApp() {
      final router = GoRouter(
        initialLocation: '/set-new-password',
        routes: [
          GoRoute(
            path: '/set-new-password',
            builder: (context, _) => const SetNewPasswordPage(),
          ),
          GoRoute(
            path: '/login_page',
            builder: (context, _) => const Scaffold(body: Text('Login Page')),
          ),
          GoRoute(
            path: '/forgot-password',
            builder: (context, _) =>
                const Scaffold(body: Text('Forgot Password')),
          ),
        ],
      );

      return ProviderScope(
        overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
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
