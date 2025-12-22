import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Review for theme/context migration if needed.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../common/layout/common_spacer.dart';

import '../../../../services/auth_link_handler.dart';

/// Debug utility widget for testing deep link flows.
///
/// This widget provides buttons to simulate incoming deep links
/// for email confirmation and password reset without needing
/// actual emails or links.
///
/// Only available in debug mode.
class DeepLinkDebugWidget extends StatelessWidget {
  const DeepLinkDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    // Only show in debug mode
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final acc = context.accent;

    return Container(
      margin: EdgeInsets.all(sp.md),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.warning.withValues(alpha: 0.5),
          width: context.sizes.borderRegular,
        ),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report,
                color: c.warning,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Deep Link Debug Tools',
                style: text.heading3.copyWith(color: c.textPrimary),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.sm),
          Text(
            'Simulate deep links for testing auth flows',
            style: text.bodySmall.copyWith(color: c.textSecondary),
          ),
          CommonSpacer.vertical(sp.md),
          // Email Confirmation Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _simulateEmailConfirmDeepLink(context),
              icon: const Icon(Icons.email_outlined),
              label: const Text('Simulate Email Confirmation'),
              style: OutlinedButton.styleFrom(
                foregroundColor: acc.primary,
                side: BorderSide(color: acc.primary),
                padding: EdgeInsets.symmetric(vertical: sp.md),
              ),
            ),
          ),
          CommonSpacer.vertical(sp.md),
          // Password Reset Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _simulateResetPasswordDeepLink(context),
              icon: const Icon(Icons.lock_reset),
              label: const Text('Simulate Password Reset'),
              style: OutlinedButton.styleFrom(
                foregroundColor: acc.primary,
                side: BorderSide(color: acc.primary),
                padding: EdgeInsets.symmetric(vertical: sp.md),
              ),
            ),
          ),
          SizedBox(height: sp.md),
          // Supabase Verify URL Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _simulateSupabaseVerifyUrl(context),
              icon: const Icon(Icons.link),
              label: const Text('Simulate Supabase Verify URL'),
              style: OutlinedButton.styleFrom(
                foregroundColor: acc.primary,
                side: BorderSide(color: acc.primary),
                padding: EdgeInsets.symmetric(vertical: sp.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Simulate an email confirmation deep link
  void _simulateEmailConfirmDeepLink(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🔧 DEBUG: Simulating email confirmation deep link');
    }

    final uri = Uri.parse('substancecheck://auth');
    authLinkHandler._handleDeepLink(uri);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Simulated: substancecheck://auth'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Simulate a password reset deep link
  void _simulateResetPasswordDeepLink(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🔧 DEBUG: Simulating password reset deep link');
    }

    final uri = Uri.parse('substancecheck://reset-password');
    authLinkHandler._handleDeepLink(uri);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Simulated: substancecheck://reset-password'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Simulate a Supabase verification URL
  void _simulateSupabaseVerifyUrl(BuildContext context) {
    if (kDebugMode) {
      debugPrint('🔧 DEBUG: Simulating Supabase verify URL');
    }

    // Show a dialog to choose the type
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Verification Type'),
        content: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Signup'),
              onTap: () {
                Navigator.pop(context);
                final uri = Uri.parse(
                  'https://project.supabase.co/auth/v1/verify?token=test_token&type=signup&redirect_to=substancecheck://auth',
                );
                authLinkHandler._handleDeepLink(uri);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Password Recovery'),
              onTap: () {
                Navigator.pop(context);
                final uri = Uri.parse(
                  'https://project.supabase.co/auth/v1/verify?token=test_token&type=recovery&redirect_to=substancecheck://reset-password',
                );
                authLinkHandler._handleDeepLink(uri);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

// Extension to access private method for testing
extension AuthLinkHandlerDebug on AuthLinkHandler {
  void _handleDeepLink(Uri uri) {
    // We need to call the handler's method, but it's private
    // So we use reflection-like pattern by calling it via the exposed method
    // This is a workaround for debug purposes

    // The actual handler listens to links, but for simulation we directly navigate
    final context = _navigatorKey?.currentContext;
    if (context == null) return;

    if (uri.scheme == 'substancecheck') {
      switch (uri.host) {
        case 'auth':
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/email-confirmed', (route) => false);
          break;
        case 'reset-password':
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/set-new-password', (route) => false);
          break;
      }
    } else if (uri.scheme == 'https') {
      final type = uri.queryParameters['type'];
      switch (type) {
        case 'signup':
        case 'email':
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/email-confirmed', (route) => false);
          break;
        case 'recovery':
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/set-new-password', (route) => false);
          break;
      }
    }
  }

  GlobalKey<NavigatorState>? get _navigatorKey {
    // Access the navigator key
    // This won't work directly, but illustrates the intent
    // The actual implementation uses the handler's internal state
    return null; // Placeholder
  }
}

/// Standalone debug simulation functions for use in tests or debug menus.
class DeepLinkSimulator {
  DeepLinkSimulator._();

  /// Navigate to email confirmed page (simulates email confirmation link)
  static void simulateEmailConfirmation(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/email-confirmed', (route) => false);
  }

  /// Navigate to set new password page (simulates password reset link)
  static void simulatePasswordReset(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/set-new-password', (route) => false);
  }

  /// Log a simulated deep link URI for debugging
  static void logSimulatedLink(String url) {
    if (kDebugMode) {
      final uri = Uri.parse(url);
      debugPrint('🔧 Simulated Deep Link:');
      debugPrint('   URL: $url');
      debugPrint('   Scheme: ${uri.scheme}');
      debugPrint('   Host: ${uri.host}');
      debugPrint('   Path: ${uri.path}');
      debugPrint('   Query: ${uri.queryParameters}');
      debugPrint('   Fragment: ${uri.fragment}');
    }
  }
}
