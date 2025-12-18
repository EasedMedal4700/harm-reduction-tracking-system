// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final acc = context.accent;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: c.error,
            ),

            SizedBox(height: sp.lg),

            Text(
              message,
              style: text.heading3.copyWith(
                color: c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            if (details != null) ...[
              SizedBox(height: sp.md),
              SelectableText(
                details!,
                textAlign: TextAlign.center,
                style: text.bodySmall.copyWith(
                  color: c.textSecondary,
                ),
              ),
            ],

            SizedBox(height: sp.xl),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: acc.primary,
                foregroundColor: c.textInverse,
                padding: EdgeInsets.symmetric(
                  horizontal: sp.lg,
                  vertical: sp.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(sp.md),
                ),
                shadowColor: c.overlayHeavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
