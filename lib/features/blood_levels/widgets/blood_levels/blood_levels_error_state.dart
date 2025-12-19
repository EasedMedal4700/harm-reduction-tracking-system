// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonPrimaryButton.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/buttons/common_primary_button.dart';
import '../../../../common/layout/common_spacer.dart';

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
              size: t.sizes.icon2xl,
              color: c.error,
            ),

            SizedBox(height: sp.lg),

            Text(
              error,
              style: t.typography.body.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),

            CommonSpacer.vertical(t.spacing.xl),

            CommonPrimaryButton(
              label: 'Retry',
              onPressed: onRetry,
              backgroundColor: c.error,
              textColor: c.textInverse,
            ),
          ],
        ),
      ),
    );
  }
}
