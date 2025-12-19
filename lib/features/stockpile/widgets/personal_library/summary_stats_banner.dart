
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

import '../../../../constants/data/drug_categories.dart';


class SummaryStatsBanner extends StatelessWidget {
  final int totalUses;
  final int activeSubstances;
  final double avgUses;
  final String mostUsedCategory;

  const SummaryStatsBanner({
    super.key,
    required this.totalUses,
    required this.activeSubstances,
    required this.avgUses,
    required this.mostUsedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            t.colors.surface,
            t.colors.surface.withValues(alpha: t.isDark ? 0.8 : 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: t.colors.border,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceEvenly,
            children: [
              _buildSummaryItem(
                'Total Uses',
                '$totalUses',
                Icons.bar_chart,
                t,
              ),
              _buildSummaryItem(
                'Active Substances',
                '$activeSubstances',
                Icons.science,
                t,
              ),
              _buildSummaryItem(
                'Avg Uses',
                avgUses.toStringAsFixed(1),
                Icons.trending_up,
                t,
              ),
            ],
          ),
          CommonSpacer.vertical(t.spacing.sm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.sm,
              vertical: t.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: t.colors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
            ),
            child: Row(
              mainAxisSize: AppLayout.mainAxisSizeMin,
              children: [
                Icon(
                  Icons.star,
                  size: t.sizes.iconSm,
                  color: DrugCategoryColors.colorFor(mostUsedCategory),
                ),
                CommonSpacer.horizontal(t.spacing.xs),
                Text(
                  'Most Used Category: $mostUsedCategory',
                  style: t.typography.bodySmall.copyWith(
                    fontWeight: text.bodyBold.fontWeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, AppTheme t) {
    return Column(
      children: [
        Icon(
          icon,
          size: t.sizes.iconMd,
          color: t.accent.primary,
        ),
        CommonSpacer.vertical(t.spacing.xs / 2),
        Text(
          value,
          style: t.typography.heading3.copyWith(
            fontWeight: text.bodyBold.fontWeight,
          ),
        ),
        Text(
          label,
          style: t.typography.caption.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

