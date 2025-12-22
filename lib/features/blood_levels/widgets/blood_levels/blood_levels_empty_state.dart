// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonSpacer.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

/// Empty state shown when no substances have active blood levels,
/// or when filters hide all visible data.
class BloodLevelsEmptyState extends StatelessWidget {
  final bool hasActiveFilters;

  const BloodLevelsEmptyState({super.key, this.hasActiveFilters = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors; // color palette
    final text = context.text; // typography

    return Center(
      child: Column(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Icon(
            Icons.science_outlined,
            size: context.sizes.icon2xl,
            color: c.textTertiary,
          ),
          CommonSpacer.vertical(context.spacing.xl),

          Text(
            'No active substances',
            style: text.heading4.copyWith(color: c.textSecondary),
          ),

          if (hasActiveFilters) ...[
            const CommonSpacer.vertical(8),
            Text(
              'Try adjusting filters',
              style: text.bodySmall.copyWith(color: c.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
