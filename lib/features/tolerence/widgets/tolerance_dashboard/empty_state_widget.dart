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
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            // ICON
            Container(
              padding: EdgeInsets.all(sp.xl),
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                shape: context.shapes.boxShapeCircle,
              ),
              child: Icon(
                Icons.science_outlined,
                size: 64.0,
                color: c.textSecondary,
              ),
            ),
            CommonSpacer.vertical(sp.lg),
            // TITLE
            Text(
              'No Tolerance Data',
              style: tx.heading2.copyWith(color: c.textPrimary),
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(sp.sm),
            // DESCRIPTION
            Text(
              'Start tracking your substance use to see\ntolerance insights and system interactions',
              style: tx.body.copyWith(color: c.textSecondary),
              textAlign: AppLayout.textAlignCenter,
            ),
            if (onAddEntry != null) ...[
              CommonSpacer.vertical(sp.xl),
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
