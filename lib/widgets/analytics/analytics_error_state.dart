import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Widget displaying error state for the analytics page
class AnalyticsErrorState extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback onRetry;

  const AnalyticsErrorState({
    super.key,
    required this.message,
    this.details,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: t.colors.error,
            ),

            SizedBox(height: t.spacing.lg),

            Text(
              message,
              style: t.typography.heading3.copyWith(
                color: t.colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            if (details != null) ...[
              SizedBox(height: t.spacing.md),
              SelectableText(
                details!,
                textAlign: TextAlign.center,
                style: t.typography.bodySmall.copyWith(
                  color: t.colors.textSecondary,
                ),
              ),
            ],

            SizedBox(height: t.spacing.xl),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.accent.primary,
                foregroundColor: t.colors.textInverse,
                padding: EdgeInsets.symmetric(
                  horizontal: t.spacing.lg,
                  vertical: t.spacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.spacing.md),
                ),
                shadowColor: t.colors.overlayHeavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
