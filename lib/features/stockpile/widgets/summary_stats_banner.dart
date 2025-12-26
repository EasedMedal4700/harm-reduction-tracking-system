// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../constants/data/drug_categories.dart';

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
    final tx = context.text;
    final th = context.theme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(th.spacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            th.colors.surface,
            th.colors.surface.withValues(alpha: th.isDark ? 0.8 : 0.9),
          ],
          begin: context.shapes.alignmentTopLeft,
          end: context.shapes.alignmentBottomRight,
        ),
        border: Border(bottom: BorderSide(color: th.colors.border)),
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
                context,
              ),
              _buildSummaryItem(
                'Active Substances',
                '$activeSubstances',
                Icons.science,
                context,
              ),
              _buildSummaryItem(
                'Avg Uses',
                avgUses.toStringAsFixed(1),
                Icons.trending_up,
                context,
              ),
            ],
          ),
          CommonSpacer.vertical(th.spacing.sm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: th.spacing.sm,
              vertical: th.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: th.colors.border.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
            ),
            child: Row(
              mainAxisSize: AppLayout.mainAxisSizeMin,
              children: [
                Icon(
                  Icons.star,
                  size: th.sizes.iconSm,
                  color: DrugCategoryColors.colorFor(mostUsedCategory),
                ),
                CommonSpacer.horizontal(th.spacing.xs),
                Text(
                  'Most Used Category: $mostUsedCategory',
                  style: th.typography.bodySmall.copyWith(
                    fontWeight: tx.bodyBold.fontWeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    BuildContext context,
  ) {
    final th = context.theme;
    final tx = context.text;

    return Column(
      children: [
        Icon(icon, size: context.sizes.iconMd, color: th.accent.primary),
        CommonSpacer.vertical(context.spacing.xs / 2),
        Text(
          value,
          style: th.typography.heading3.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
          ),
        ),
        Text(
          label,
          style: th.typography.caption.copyWith(color: th.colors.textSecondary),
        ),
      ],
    );
  }
}
