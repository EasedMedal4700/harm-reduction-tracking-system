// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonPrimaryButton.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Icon(Icons.error_outline, size: th.sizes.icon2xl, color: c.error),
            SizedBox(height: sp.lg),
            Text(
              error,
              style: th.typography.body.copyWith(color: c.textPrimary),
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(th.spacing.xl),
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
