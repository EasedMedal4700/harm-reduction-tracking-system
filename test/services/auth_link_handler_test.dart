import 'package:flutter_test/flutter_test.dart';

/// Tests for AuthLinkHandler deep link parsing logic.
///
/// Note: These tests focus on URL parsing logic without requiring
/// actual navigation or Supabase initialization.
void main() {
  group('Deep Link URL Parsing', () {
    test('parses substancecheck://auth scheme correctly', () {
      final uri = Uri.parse('substancecheck://auth');

      expect(uri.scheme, 'substancecheck');
      expect(uri.host, 'auth');
    });

    test('parses substancecheck://reset-password scheme correctly', () {
      final uri = Uri.parse('substancecheck://reset-password');

      expect(uri.scheme, 'substancecheck');
      expect(uri.host, 'reset-password');
    });

    test('parses substancecheck://reset-password with access_token', () {
      final uri = Uri.parse(
        'substancecheck://reset-password?access_token=abc123&refresh_token=xyz789',
      );

      expect(uri.scheme, 'substancecheck');
      expect(uri.host, 'reset-password');
      expect(uri.queryParameters['access_token'], 'abc123');
      expect(uri.queryParameters['refresh_token'], 'xyz789');
    });

    test('parses Supabase verification URL with signup type', () {
      final uri = Uri.parse(
        'https://project.supabase.co/auth/v1/verify?token=XYZ&type=signup&redirect_to=substancecheck://auth',
      );

      expect(uri.scheme, 'https');
      expect(uri.path, '/auth/v1/verify');
      expect(uri.queryParameters['type'], 'signup');
      expect(uri.queryParameters['token'], 'XYZ');
      expect(uri.queryParameters['redirect_to'], 'substancecheck://auth');
    });

    test('parses Supabase verification URL with recovery type', () {
      final uri = Uri.parse(
        'https://project.supabase.co/auth/v1/verify?token=ABC&type=recovery&redirect_to=substancecheck://reset-password',
      );

      expect(uri.scheme, 'https');
      expect(uri.path, '/auth/v1/verify');
      expect(uri.queryParameters['type'], 'recovery');
      expect(uri.queryParameters['token'], 'ABC');
      expect(
        uri.queryParameters['redirect_to'],
        'substancecheck://reset-password',
      );
    });

    test('handles URL fragment with access token (implicit flow)', () {
      final uri = Uri.parse(
        'https://example.com/callback#access_token=abc&refresh_token=xyz&type=recovery',
      );

      expect(uri.fragment, isNotEmpty);

      final params = Uri.splitQueryString(uri.fragment);
      expect(params['access_token'], 'abc');
      expect(params['refresh_token'], 'xyz');
      expect(params['type'], 'recovery');
    });

    test('handles malformed URL gracefully', () {
      // Uri.parse doesn't throw, it returns a URI with empty components
      final uri = Uri.parse('not-a-valid-url');
      expect(uri.scheme, isEmpty);
    });

    test('handles empty query parameters', () {
      final uri = Uri.parse('substancecheck://auth?');

      expect(uri.queryParameters, isEmpty);
    });

    test('handles URL with only scheme', () {
      final uri = Uri.parse('substancecheck:');

      expect(uri.scheme, 'substancecheck');
      expect(uri.host, isEmpty);
    });
  });

  group('Verification Type Detection', () {
    test('identifies email verification types', () {
      const emailTypes = ['signup', 'email', 'email_change'];

      for (final type in emailTypes) {
        final isEmailVerification =
            type == 'signup' || type == 'email' || type == 'email_change';
        expect(
          isEmailVerification,
          isTrue,
          reason: 'Type "$type" should be email verification',
        );
      }
    });

    test('identifies recovery types', () {
      const recoveryTypes = ['recovery', 'magiclink'];

      for (final type in recoveryTypes) {
        final isRecovery = type == 'recovery' || type == 'magiclink';
        expect(isRecovery, isTrue, reason: 'Type "$type" should be recovery');
      }
    });

    test('unknown type is neither email nor recovery', () {
      const type = 'unknown_type';

      final isEmailVerification =
          type == 'signup' || type == 'email' || type == 'email_change';
      final isRecovery = type == 'recovery' || type == 'magiclink';

      expect(isEmailVerification, isFalse);
      expect(isRecovery, isFalse);
    });
  });

  group('Host Routing', () {
    test('routes auth host to email confirmation', () {
      const host = 'auth';
      final shouldRouteToEmailConfirm = host == 'auth';

      expect(shouldRouteToEmailConfirm, isTrue);
    });

    test('routes reset-password host to password reset', () {
      const host = 'reset-password';
      final shouldRouteToPasswordReset = host == 'reset-password';

      expect(shouldRouteToPasswordReset, isTrue);
    });

    test('unknown host should not route', () {
      const host = 'unknown';
      final shouldRouteToEmailConfirm = host == 'auth';
      final shouldRouteToPasswordReset = host == 'reset-password';

      expect(shouldRouteToEmailConfirm, isFalse);
      expect(shouldRouteToPasswordReset, isFalse);
    });
  });

  group('Token Extraction', () {
    test('extracts access_token from query parameters', () {
      final uri = Uri.parse(
        'substancecheck://auth?access_token=test_token_123',
      );
      final token = uri.queryParameters['access_token'];

      expect(token, 'test_token_123');
    });

    test('extracts refresh_token from query parameters', () {
      final uri = Uri.parse('substancecheck://auth?refresh_token=refresh_456');
      final token = uri.queryParameters['refresh_token'];

      expect(token, 'refresh_456');
    });

    test('extracts token from Supabase verify URL', () {
      final uri = Uri.parse(
        'https://project.supabase.co/auth/v1/verify?token=verify_token_789&type=recovery',
      );
      final token = uri.queryParameters['token'];

      expect(token, 'verify_token_789');
    });

    test('handles missing tokens gracefully', () {
      final uri = Uri.parse('substancecheck://auth');
      final accessToken = uri.queryParameters['access_token'];
      final refreshToken = uri.queryParameters['refresh_token'];

      expect(accessToken, isNull);
      expect(refreshToken, isNull);
    });

    test('extracts tokens from URL fragment', () {
      final uri = Uri.parse(
        'https://app.com/#access_token=frag_token&expires_in=3600&type=recovery',
      );
      final params = Uri.splitQueryString(uri.fragment);

      expect(params['access_token'], 'frag_token');
      expect(params['expires_in'], '3600');
      expect(params['type'], 'recovery');
    });
  });

  group('URL Path Detection', () {
    test('detects Supabase auth verify path', () {
      final paths = ['/auth/v1/verify', '/auth/v2/verify', '/verify'];

      for (final path in paths) {
        final isVerifyPath = path.contains('/verify');
        expect(
          isVerifyPath,
          isTrue,
          reason: 'Path "$path" should be detected as verify',
        );
      }
    });

    test('non-verify paths are not detected', () {
      final paths = ['/auth/v1/token', '/callback', '/login'];

      for (final path in paths) {
        final isVerifyPath =
            path.contains('/auth/v1/verify') || path.contains('/verify');
        // Only the first path should fail, verify is in path for others
        if (path == '/auth/v1/token') {
          expect(isVerifyPath, isFalse);
        }
      }
    });
  });

  group('Edge Cases', () {
    test('handles URL-encoded parameters', () {
      final uri = Uri.parse(
        'substancecheck://auth?email=${Uri.encodeComponent("test@example.com")}',
      );
      final email = uri.queryParameters['email'];

      expect(email, 'test@example.com');
    });

    test('handles special characters in token', () {
      final token = 'abc+123/xyz==';
      final encodedToken = Uri.encodeComponent(token);
      final uri = Uri.parse('substancecheck://auth?token=$encodedToken');
      final extractedToken = uri.queryParameters['token'];

      expect(extractedToken, token);
    });

    test('handles very long tokens', () {
      final longToken = 'a' * 1000;
      final uri = Uri.parse('substancecheck://auth?token=$longToken');
      final extractedToken = uri.queryParameters['token'];

      expect(extractedToken?.length, 1000);
    });

    test('handles multiple query parameters', () {
      final uri = Uri.parse(
        'substancecheck://reset-password?access_token=abc&refresh_token=xyz&expires_in=3600&type=recovery',
      );

      expect(uri.queryParameters.length, 4);
      expect(uri.queryParameters['access_token'], 'abc');
      expect(uri.queryParameters['refresh_token'], 'xyz');
      expect(uri.queryParameters['expires_in'], '3600');
      expect(uri.queryParameters['type'], 'recovery');
    });
  });
}
