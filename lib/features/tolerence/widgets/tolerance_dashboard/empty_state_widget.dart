// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/buttons/common_primary_button.dart';

class EmptyStateWidget extends ConsumerWidget {
  final VoidCallback? onAddEntry;

  const EmptyStateWidget({super.key, this.onAddEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            // ICON
            Container(
              padding: EdgeInsets.all(spacing.xl),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                shape: context.shapes.boxShapeCircle,
              ),
              child: Icon(
                Icons.science_outlined,
                size: 64.0,
                color: colors.textSecondary,
              ),
            ),

            CommonSpacer.vertical(spacing.lg),

            // TITLE
            Text(
              'No Tolerance Data',
              style: typography.heading2.copyWith(color: colors.textPrimary),
              textAlign: AppLayout.textAlignCenter,
            ),

            CommonSpacer.vertical(spacing.sm),

            // DESCRIPTION
            Text(
              'Start tracking your substance use to see\ntolerance insights and system interactions',
              style: typography.body.copyWith(color: colors.textSecondary),
              textAlign: AppLayout.textAlignCenter,
            ),

            if (onAddEntry != null) ...[
              CommonSpacer.vertical(spacing.xl),

              // ACTION BUTTON
              CommonPrimaryButton(
                onPressed: onAddEntry!,
                icon: Icons.add,
                label: 'Add First Entry',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
