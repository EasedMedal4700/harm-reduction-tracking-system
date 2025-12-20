import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        if (kDebugMode) {
          debugPrint(
            '❌ AuthLinkHandler: Error listening to deep links: $error',
          );
        }
      },
    );
    if (kDebugMode) {
      debugPrint('🔗 AuthLinkHandler: Started listening for deep links');
    }
  }

  /// Handle the initial deep link if app was launched from a link.
  Future<void> _handleInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        if (kDebugMode) {
          debugPrint('🔗 AuthLinkHandler: Initial link: $initialUri');
        }
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AuthLinkHandler: Error getting initial link: $e');
      }
    }
  }

  /// Process an incoming deep link URI.
  void _handleDeepLink(Uri uri) {
    final linkKey = uri.toString();

    // Prevent double-handling
    if (_handledLinks.contains(linkKey)) {
      if (kDebugMode) {
        debugPrint('⚠️ AuthLinkHandler: Link already handled: $linkKey');
      }
      return;
    }
    _handledLinks.add(linkKey);

    // Clean up old links after 60 seconds to prevent memory leak
    Future.delayed(const Duration(seconds: 60), () {
      _handledLinks.remove(linkKey);
    });

    if (kDebugMode) {
      debugPrint('🔗 AuthLinkHandler: Handling deep link: $uri');
      debugPrint('🔗 AuthLinkHandler: Scheme: ${uri.scheme}');
      debugPrint('🔗 AuthLinkHandler: Host: ${uri.host}');
      debugPrint('🔗 AuthLinkHandler: Path: ${uri.path}');
      debugPrint('🔗 AuthLinkHandler: Query: ${uri.queryParameters}');
    }

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

    if (kDebugMode) {
      debugPrint('⚠️ AuthLinkHandler: Unknown scheme: ${uri.scheme}');
    }
  }

  /// Handle substancecheck:// deep links
  void _handleSubstanceCheckLink(Uri uri) {
    switch (uri.host) {
      case 'auth':
        // Email confirmation successful
        if (kDebugMode) {
          debugPrint('✅ AuthLinkHandler: Email confirmation link detected');
        }
        _navigateToEmailConfirmed();
        break;

      case 'reset-password':
        // Password reset flow
        if (kDebugMode) {
          debugPrint('🔑 AuthLinkHandler: Password reset link detected');
        }
        _handlePasswordReset(uri);
        break;

      default:
        if (kDebugMode) {
          debugPrint('⚠️ AuthLinkHandler: Unknown host: ${uri.host}');
        }
    }
  }

  /// Handle HTTPS Supabase verification links
  void _handleHttpsLink(Uri uri) {
    // Supabase verification URLs look like:
    // https://<project>.supabase.co/auth/v1/verify?token=XYZ&type=signup&redirect_to=substancecheck://auth
    // https://<project>.supabase.co/auth/v1/verify?token=XYZ&type=recovery&redirect_to=substancecheck://reset-password

    final path = uri.path;
    final queryParams = uri.queryParameters;

    if (kDebugMode) {
      debugPrint('🔗 AuthLinkHandler: HTTPS link path: $path');
      debugPrint('🔗 AuthLinkHandler: Query params: $queryParams');
    }

    // Check for Supabase auth verification path
    if (path.contains('/auth/v1/verify') || path.contains('/verify')) {
      final type = queryParams['type'];
      final token = queryParams['token'];
      final accessToken = queryParams['access_token'];
      final refreshToken = queryParams['refresh_token'];

      if (kDebugMode) {
        debugPrint('🔗 AuthLinkHandler: Verification type: $type');
        debugPrint('🔗 AuthLinkHandler: Token exists: ${token != null}');
        debugPrint(
          '🔗 AuthLinkHandler: Access token exists: ${accessToken != null}',
        );
      }

      switch (type) {
        case 'signup':
        case 'email':
        case 'email_change':
          // Email confirmation
          if (kDebugMode) {
            debugPrint('✅ AuthLinkHandler: Email verification successful');
          }
          _navigateToEmailConfirmed();
          break;

        case 'recovery':
        case 'magiclink':
          // Password recovery
          if (kDebugMode) {
            debugPrint('🔑 AuthLinkHandler: Password recovery flow');
          }
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
          if (kDebugMode) {
            debugPrint('⚠️ AuthLinkHandler: Unknown verification type: $type');
          }
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

    if (kDebugMode) {
      debugPrint('🔗 AuthLinkHandler: Fragment params: $params');
    }

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
        if (kDebugMode) {
          debugPrint('✅ AuthLinkHandler: Recovery token verified');
        }
        _navigateToSetNewPassword();
      } else {
        if (kDebugMode) {
          debugPrint('❌ AuthLinkHandler: Recovery token verification failed');
        }
        _showError('Invalid or expired reset link. Please request a new one.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AuthLinkHandler: Error verifying recovery token: $e');
      }
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
      if (kDebugMode) {
        debugPrint('✅ AuthLinkHandler: Session set from recovery tokens');
      }
      _navigateToSetNewPassword();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AuthLinkHandler: Error setting session: $e');
      }
      // Still navigate, the page will handle the error
      _navigateToSetNewPassword();
    }
  }

  /// Navigate to email confirmed page
  void _navigateToEmailConfirmed() {
    final context = _navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/email-confirmed', (route) => false);
    } else {
      if (kDebugMode) {
        debugPrint('⚠️ AuthLinkHandler: Navigator context not available');
      }
    }
  }

  /// Navigate to set new password page
  void _navigateToSetNewPassword() {
    final context = _navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/set-new-password', (route) => false);
    } else {
      if (kDebugMode) {
        debugPrint('⚠️ AuthLinkHandler: Navigator context not available');
      }
    }
  }

  /// Show error message using SnackBar
  void _showError(String message) {
    final context = _navigatorKey?.currentContext;
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }
}

/// Global instance for easy access
final authLinkHandler = AuthLinkHandler.instance;
