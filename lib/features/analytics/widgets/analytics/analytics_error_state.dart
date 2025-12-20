// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant. Uses CommonPrimaryButton.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import '../../../../common/layout/common_spacer.dart';

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
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Icon(
              Icons.error_outline,
              size: context.sizes.icon2xl,
              color: c.error,
            ),

            CommonSpacer.vertical(sp.lg),

            Text(
              message,
              style: text.heading3.copyWith(color: c.textPrimary),
              textAlign: AppLayout.textAlignCenter,
            ),

            if (details != null) ...[
              CommonSpacer.vertical(sp.md),
              SelectableText(
                details!,
                textAlign: AppLayout.textAlignCenter,
                style: text.bodySmall.copyWith(color: c.textSecondary),
              ),
            ],

            CommonSpacer.vertical(sp.xl),

            CommonPrimaryButton(
              onPressed: onRetry,
              icon: Icons.refresh,
              label: 'Try Again',
              backgroundColor: acc.primary,
              textColor: c.textInverse,
            ),
          ],
        ),
      ),
    );
  }
}
