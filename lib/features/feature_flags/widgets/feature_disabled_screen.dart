import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../common/buttons/common_primary_button.dart';
import '../../../common/buttons/common_outlined_button.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppThemeExtension and Common buttons.
/// A screen displayed when a feature is currently disabled.
/// Shows a friendly message and provides navigation options.
class FeatureDisabledScreen extends StatelessWidget {
  /// The name of the disabled feature (e.g., 'craving_log')
  final String featureName;

  /// Optional custom message to display
  final String? customMessage;
  const FeatureDisabledScreen({
    super.key,
    required this.featureName,
    this.customMessage,
  });

  /// Formats a feature name for display (e.g., 'craving_log' -> 'Craving Log')
  String _formatFeatureName(String name) {
    return name
        .split('_')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    final ac = context.accent;
    final formattedName = _formatFeatureName(featureName);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
        title: Text(formattedName, style: tx.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: c.textPrimary,
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentCenter,
            children: [
              SizedBox(height: sp.xl),
              // Icon
              Container(
                width: sp.xl * 2,
                height: sp.xl * 2,
                decoration: BoxDecoration(
                  color: ac.primary.withValues(
                    alpha: context.opacities.veryLow,
                  ),
                  shape: sh.boxShapeCircle,
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: sp.xl,
                  color: ac.primary,
                ),
              ),
              SizedBox(height: sp.lg),
              // Title
              Text(
                'Feature Temporarily Unavailable',
                style: tx.heading3.copyWith(color: c.textPrimary),
                textAlign: AppLayout.textAlignCenter,
              ),
              SizedBox(height: sp.md),
              // Description
              Text(
                customMessage ??
                    'The $formattedName feature is currently undergoing maintenance. '
                        'Please check back later.',
                style: tx.body.copyWith(color: c.textSecondary),
                textAlign: AppLayout.textAlignCenter,
              ),
              SizedBox(height: sp.xl),
              // Go Home button
              CommonPrimaryButton(
                onPressed: () {
                  Navigator.of(context);
                  if (!context.mounted) return;
                  context.go('/home');
                },
                icon: Icons.home_rounded,
                label: 'Go to Home',
                width: double.infinity,
              ),
              SizedBox(height: sp.sm),
              // Back button
              CommonOutlinedButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon: Icons.arrow_back_rounded,
                label: 'Go Back',
                width: double.infinity,
              ),
              SizedBox(height: sp.lg),
              // Info card
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.info.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(color: c.info.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: c.info,
                      size: sp.md,
                    ),
                    SizedBox(width: sp.sm),
                    Expanded(
                      child: Text(
                        'This feature will be available again soon. '
                        'Thank you for your patience.',
                        style: tx.bodySmall.copyWith(color: c.info),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
