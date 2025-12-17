import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: TODO
// Riverpod: TODO
// Notes: Fully migrated to AppThemeExtension. Deprecated theme usage removed. No hardcoded values.

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
    final text = context.text;
    final acc = context.accent;

    final formattedName = _formatFeatureName(featureName);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.surface,
        elevation: 0,
        title: Text(
          formattedName,
          style: text.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: c.textPrimary,
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(sp.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: sp.xl),

              // Icon
              Container(
                width: sp.xl * 2,
                height: sp.xl * 2,
                decoration: BoxDecoration(
                  color: acc.primary.withValues(alpha: AppThemeConstants.opacityVeryLow),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: sp.xl,
                  color: acc.primary,
                ),
              ),

              SizedBox(height: sp.lg),

              // Title
              Text(
                'Feature Temporarily Unavailable',
                style: text.heading3.copyWith(
                  color: c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: sp.md),

              // Description
              Text(
                customMessage ??
                    'The $formattedName feature is currently undergoing maintenance. '
                        'Please check back later.',
                style: text.body.copyWith(
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: sp.xl),

              // Go Home button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (_) => false,
                    );
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Go to Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: acc.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: sp.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(sh.radiusMd),
                    ),
                  ),
                ),
              ),

              SizedBox(height: sp.sm),

              // Back button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: acc.primary,
                    side: BorderSide(color: acc.primary),
                    padding: EdgeInsets.symmetric(vertical: sp.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(sh.radiusMd),
                    ),
                  ),
                ),
              ),

              SizedBox(height: sp.lg),

              // Info card
              Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: c.info.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  border: Border.all(
                    color: c.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: text.bodySmall.copyWith(
                          color: c.info,
                        ),
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
