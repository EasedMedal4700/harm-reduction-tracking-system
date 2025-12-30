// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Wrapper widget for feature gating.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile_drug_use_app/features/feature_flags/providers/feature_flag_providers.dart';
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
class FeatureGate extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(isAdminProvider);
    return admin.when(
      loading: () => const _LoadingScreen(),
      error: (_, __) => const _LoadingScreen(),
      data: (isAdmin) {
        final flags = ref.watch(featureFlagServiceProvider);
        if (flags.isLoading && !flags.isLoaded) {
          return const _LoadingScreen();
        }
        final isEnabled = flags.isEnabled(featureName, isAdmin: isAdmin);
        if (isEnabled) {
          return child;
        }
        return disabledScreen ??
            FeatureDisabledScreen(featureName: featureName);
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
