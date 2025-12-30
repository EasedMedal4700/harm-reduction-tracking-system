// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Service.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile_drug_use_app/common/logging/app_log.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Handles deep links for authentication flows (email confirmation, password reset).
///
/// This service listens to incoming deep links and routes users to the appropriate
/// screens based on the Supabase verification type.
///
/// Supported deep link patterns:
/// - `substancecheck://auth` → Email confirmation → [EmailConfirmedPage]
/// - `substancecheck://reset-password` → Password reset → [SetNewPasswordPage]
class AuthLinkHandler {
  AuthLinkHandler._();
  static final AuthLinkHandler instance = AuthLinkHandler._();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  GlobalKey<NavigatorState>? _navigatorKey;
  // Track handled links to prevent double-handling
  final Set<String> _handledLinks = {};

  /// Initialize the deep link handler with a navigator key for routing.
  ///
  /// Call this in your app's initState() after the MaterialApp is built.
  void init(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
    _startListening();
    _handleInitialLink();
  }

  /// Dispose of the deep link listener.
  ///
  /// Call this in your app's dispose() method.
  void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _handledLinks.clear();
  }

  /// Start listening for incoming deep links.
  void _startListening() {
    _linkSubscription?.cancel();
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (error) {
        AppLog.e('❌ AuthLinkHandler: Error listening to deep links: $error');
      },
    );
    AppLog.d('🔗 AuthLinkHandler: Started listening for deep links');
  }

  /// Handle the initial deep link if app was launched from a link.
  Future<void> _handleInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        AppLog.d('🔗 AuthLinkHandler: Initial link: $initialUri');
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      AppLog.w('⚠️ AuthLinkHandler: Error getting initial link: $e');
    }
  }

  /// Process an incoming deep link URI.
  void _handleDeepLink(Uri uri) {
    final linkKey = uri.toString();
    // Prevent double-handling
    if (_handledLinks.contains(linkKey)) {
      AppLog.w('⚠️ AuthLinkHandler: Link already handled: $linkKey');
      return;
    }
    _handledLinks.add(linkKey);
    // Clean up old links after 60 seconds to prevent memory leak
    Future.delayed(const Duration(seconds: 60), () {
      _handledLinks.remove(linkKey);
    });
    AppLog.d('🔗 AuthLinkHandler: Handling deep link: $uri');
    AppLog.d('🔗 AuthLinkHandler: Scheme: ${uri.scheme}');
    AppLog.d('🔗 AuthLinkHandler: Host: ${uri.host}');
    AppLog.d('🔗 AuthLinkHandler: Path: ${uri.path}');
    AppLog.d('🔗 AuthLinkHandler: Query: ${uri.queryParameters}');
    // Handle substancecheck:// scheme
    if (uri.scheme == 'substancecheck') {
      _handleSubstanceCheckLink(uri);
      return;
    }
    // Handle HTTPS links (Supabase verification redirects)
    if (uri.scheme == 'https' || uri.scheme == 'http') {
      _handleHttpsLink(uri);
      return;
    }
    AppLog.w('⚠️ AuthLinkHandler: Unknown scheme: ${uri.scheme}');
  }

  /// Handle substancecheck:// deep links
  void _handleSubstanceCheckLink(Uri uri) {
    switch (uri.host) {
      case 'auth':
        // Email confirmation successful
        AppLog.d('✅ AuthLinkHandler: Email confirmation link detected');
        _navigateToEmailConfirmed();
        break;
      case 'reset-password':
        // Password reset flow
        AppLog.d('🔑 AuthLinkHandler: Password reset link detected');
        _handlePasswordReset(uri);
        break;
      default:
        AppLog.w('⚠️ AuthLinkHandler: Unknown host: ${uri.host}');
    }
  }

  /// Handle HTTPS Supabase verification links
  void _handleHttpsLink(Uri uri) {
    // Supabase verification URLs look like:
    // https://<project>.supabase.co/auth/v1/verify?token=XYZ&type=signup&redirect_to=substancecheck://auth
    // https://<project>.supabase.co/auth/v1/verify?token=XYZ&type=recovery&redirect_to=substancecheck://reset-password
    final path = uri.path;
    final queryParams = uri.queryParameters;
    AppLog.d('🔗 AuthLinkHandler: HTTPS link path: $path');
    AppLog.d('🔗 AuthLinkHandler: Query params: $queryParams');
    // Check for Supabase auth verification path
    if (path.contains('/auth/v1/verify') || path.contains('/verify')) {
      final type = queryParams['type'];
      final token = queryParams['token'];
      final accessToken = queryParams['access_token'];
      final refreshToken = queryParams['refresh_token'];
      AppLog.d('🔗 AuthLinkHandler: Verification type: $type');
      AppLog.d('🔗 AuthLinkHandler: Token exists: ${token != null}');
      AppLog.d(
        '🔗 AuthLinkHandler: Access token exists: ${accessToken != null}',
      );
      switch (type) {
        case 'signup':
        case 'email':
        case 'email_change':
          // Email confirmation
          AppLog.d('✅ AuthLinkHandler: Email verification successful');
          _navigateToEmailConfirmed();
          break;
        case 'recovery':
        case 'magiclink':
          // Password recovery
          AppLog.d('🔑 AuthLinkHandler: Password recovery flow');
          // Try to set the session if we have tokens
          if (accessToken != null) {
            _setSessionAndNavigateToResetPassword(accessToken, refreshToken);
          } else if (token != null) {
            _verifyRecoveryToken(token);
          } else {
            // Navigate anyway - the reset page will handle validation
            _navigateToSetNewPassword();
          }
          break;
        default:
          AppLog.w('⚠️ AuthLinkHandler: Unknown verification type: $type');
      }
    } else {
      // Check for direct token in URL fragment (Supabase implicit flow)
      final fragment = uri.fragment;
      if (fragment.isNotEmpty) {
        _handleUrlFragment(fragment);
      }
    }
  }

  /// Handle URL fragment containing tokens (implicit flow)
  void _handleUrlFragment(String fragment) {
    // Parse fragment like: access_token=XXX&refresh_token=YYY&type=recovery
    final params = Uri.splitQueryString(fragment);
    AppLog.d('🔗 AuthLinkHandler: Fragment params: $params');
    final type = params['type'];
    final accessToken = params['access_token'];
    final refreshToken = params['refresh_token'];
    if (accessToken != null) {
      if (type == 'recovery') {
        _setSessionAndNavigateToResetPassword(accessToken, refreshToken);
      } else if (type == 'signup' || type == 'email') {
        _navigateToEmailConfirmed();
      }
    }
  }

  /// Handle password reset with token from query params
  void _handlePasswordReset(Uri uri) {
    final queryParams = uri.queryParameters;
    final accessToken = queryParams['access_token'];
    final refreshToken = queryParams['refresh_token'];
    if (accessToken != null) {
      _setSessionAndNavigateToResetPassword(accessToken, refreshToken);
    } else {
      // No token in URL, navigate to reset page anyway
      // The page will check if user is authenticated
      _navigateToSetNewPassword();
    }
  }

  /// Verify recovery token with Supabase
  Future<void> _verifyRecoveryToken(String token) async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        token: token,
        type: OtpType.recovery,
      );
      if (response.session != null) {
        AppLog.d('✅ AuthLinkHandler: Recovery token verified');
        _navigateToSetNewPassword();
      } else {
        AppLog.e('❌ AuthLinkHandler: Recovery token verification failed');
        _showError('Invalid or expired reset link. Please request a new one.');
      }
    } catch (e) {
      AppLog.e('❌ AuthLinkHandler: Error verifying recovery token: $e');
      _showError('Could not verify reset link. Please try again.');
    }
  }

  /// Set session from tokens and navigate to password reset
  Future<void> _setSessionAndNavigateToResetPassword(
    String accessToken,
    String? refreshToken,
  ) async {
    try {
      await Supabase.instance.client.auth.setSession(accessToken);
      AppLog.d('✅ AuthLinkHandler: Session set from recovery tokens');
      _navigateToSetNewPassword();
    } catch (e) {
      AppLog.e('❌ AuthLinkHandler: Error setting session: $e');
      // Still navigate, the page will handle the error
      _navigateToSetNewPassword();
    }
  }

  /// Navigate to email confirmed page
  void _navigateToEmailConfirmed() {
    final context = _navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      GoRouter.of(context).go('/email-confirmed');
    } else {
      AppLog.w('⚠️ AuthLinkHandler: Navigator context not available');
    }
  }

  /// Navigate to set new password page
  void _navigateToSetNewPassword() {
    final context = _navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      GoRouter.of(context).go('/set-new-password');
    } else {
      AppLog.w('⚠️ AuthLinkHandler: Navigator context not available');
    }
  }

  /// Show error message using SnackBar
  void _showError(String message) {
    final context = _navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      final c = context.colors;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: c.error),
      );
    }
  }
}

/// Global instance for easy access
final authLinkHandler = AuthLinkHandler.instance;
