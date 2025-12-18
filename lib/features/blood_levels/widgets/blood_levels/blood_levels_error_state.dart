// MIGRATION
// Theme: COMPLETE
// Common: N/A
// Riverpod: TODO
// Notes: Fully migrated to new theme system. Uses spacing, colors, typography.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Error state for blood levels with retry option
class BloodLevelsErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const BloodLevelsErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.lg),
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
              error,
              style: t.typography.body.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: sp.lg),

            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: c.error,
                foregroundColor: c.textInverse,
                padding: EdgeInsets.symmetric(
                  horizontal: sp.lg,
                  vertical: sp.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                ),
                shadowColor: c.overlayHeavy,
              ),
              child: Text(
                'Retry',
                style: t.typography.button.copyWith(color: c.textInverse),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
