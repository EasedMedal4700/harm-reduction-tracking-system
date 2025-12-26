// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Empty state for tolerance dashboard

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/buttons/common_primary_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onAddEntry;
  const EmptyStateWidget({super.key, this.onAddEntry});

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = th.colors;
    final sp = th.sp;
    final tx = th.text;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ICON
            Container(
              padding: EdgeInsets.all(sp.xl),
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.science_outlined,
                size: th.sizes.icon2xl,
                color: c.textSecondary,
              ),
            ),
            CommonSpacer.vertical(sp.lg),
            // TITLE
            Text(
              'No Tolerance Data',
              style: tx.heading2.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),
            CommonSpacer.vertical(sp.sm),
            // DESCRIPTION
            Text(
              'Start tracking your substance use to see\ntolerance insights and system interactions',
              style: tx.bodyMedium.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onAddEntry != null) ...[
              CommonSpacer.vertical(sp.xl),
              CommonPrimaryButton(
                label: 'Add Log Entry',
                onPressed: onAddEntry!,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
