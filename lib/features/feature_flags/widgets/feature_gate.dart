import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../services/feature_flag_service.dart';
import '../../../services/user_service.dart';
import 'feature_disabled_screen.dart';

/// A wrapper widget that conditionally shows a page based on feature flags.
///
/// If the feature is enabled (or user is admin), shows the child widget.
/// Otherwise, shows the [FeatureDisabledScreen].
///
/// Usage:
/// ```dart
/// FeatureGate(
///   featureName: 'home_page',
///   child: HomePage(),
/// )
/// ```
class FeatureGate extends StatelessWidget {
  /// The feature flag name to check (e.g., 'home_page', 'analytics_page').
  final String featureName;

  /// The widget to show if the feature is enabled.
  final Widget child;

  /// Optional custom disabled screen. If null, uses [FeatureDisabledScreen].
  final Widget? disabledScreen;
  const FeatureGate({
    super.key,
    required this.featureName,
    required this.child,
    this.disabledScreen,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserService.isAdmin(),
      builder: (context, adminSnapshot) {
        // Show loading while checking admin status
        if (adminSnapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }
        final isAdmin = adminSnapshot.data ?? false;
        // Use Consumer to listen to feature flag changes
        return Consumer<FeatureFlagService>(
          builder: (context, flags, _) {
            // Check if flags are still loading
            if (flags.isLoading && !flags.isLoaded) {
              return const _LoadingScreen();
            }
            // Check if feature is enabled (or admin override)
            final isEnabled = flags.isEnabled(featureName, isAdmin: isAdmin);
            if (isEnabled) {
              return child;
            }
            // Show disabled screen
            return disabledScreen ??
                FeatureDisabledScreen(featureName: featureName);
          },
        );
      },
    );
  }
}

/// A simple loading screen shown while checking feature flags.
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return Scaffold(
      backgroundColor: th.colors.background,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
