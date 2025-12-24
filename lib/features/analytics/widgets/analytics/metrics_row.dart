// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use CommonCard. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';

class MetricsRow extends StatelessWidget {
  final int totalEntries;
  final String mostUsedSubstance;
  final int mostUsedCount;
  final double weeklyAverage;
  final String topCategory;
  final double topCategoryPercent;
  const MetricsRow({
    super.key,
    required this.totalEntries,
    required this.mostUsedSubstance,
    required this.mostUsedCount,
    required this.weeklyAverage,
    required this.topCategory,
    required this.topCategoryPercent,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;
    // ===== MOBILE LAYOUT (Grid) =====
    if (isNarrow) {
      final aspect = screenWidth < 380 ? 1.1 : 1.25;
      return SizedBox(
        height: context.sizes.heightXl, // ensures proper rendering in ListViews
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: th.spacing.md,
          crossAxisSpacing: th.spacing.md,
          childAspectRatio: aspect,
          children: [
            _MetricCard(
              icon: Icons.analytics_outlined,
              accent: th.accent.primary,
              value: totalEntries.toString(),
              label: 'Total Entries',
            ),
            _MetricCard(
              icon: Icons.medication_outlined,
              accent: th.accent.secondary,
              value: mostUsedSubstance.isEmpty ? '-' : mostUsedSubstance,
              label: 'Most Used',
              subtitle: mostUsedCount > 0 ? '$mostUsedCount uses' : null,
            ),
            _MetricCard(
              icon: Icons.calendar_today_outlined,
              accent: th.accent.secondary, // replaced invalid primaryVariant
              value: weeklyAverage.toStringAsFixed(1),
              label: 'Weekly Average',
            ),
            _MetricCard(
              icon: Icons.category_outlined,
              accent: th.accent.primary,
              value: topCategory.isEmpty ? '-' : topCategory,
              label: 'Top Category',
              chipLabel: topCategoryPercent > 0
                  ? '${topCategoryPercent.toStringAsFixed(0)}%'
                  : null,
            ),
          ],
        ),
      );
    }
    // ===== TABLET/DESKTOP LAYOUT (Row) =====
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            icon: Icons.analytics_outlined,
            accent: th.accent.primary,
            value: totalEntries.toString(),
            label: 'Total Entries',
          ),
        ),
        SizedBox(width: th.spacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.medication_outlined,
            accent: th.accent.secondary,
            value: mostUsedSubstance.isEmpty ? '-' : mostUsedSubstance,
            label: 'Most Used',
            subtitle: mostUsedCount > 0 ? '$mostUsedCount uses' : null,
          ),
        ),
        SizedBox(width: th.spacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.calendar_today_outlined,
            accent: th.accent.secondary,
            value: weeklyAverage.toStringAsFixed(1),
            label: 'Weekly Average',
          ),
        ),
        SizedBox(width: th.spacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.category_outlined,
            accent: th.accent.primary,
            value: topCategory.isEmpty ? '-' : topCategory,
            label: 'Top Category',
            chipLabel: topCategoryPercent > 0
                ? '${topCategoryPercent.toStringAsFixed(0)}%'
                : null,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String value;
  final String label;
  final String? subtitle;
  final String? chipLabel;
  const _MetricCard({
    required this.icon,
    required this.accent,
    required this.value,
    required this.label,
    this.subtitle,
    this.chipLabel,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // ----- ICON -----
          Container(
            padding: EdgeInsets.all(th.spacing.sm),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: th.opacities.low),
              borderRadius: BorderRadius.circular(th.spacing.sm),
            ),
            child: Icon(icon, color: accent, size: th.sizes.iconSm),
          ),
          SizedBox(height: th.spacing.sm),
          // ----- VALUE -----
          FittedBox(
            fit: AppLayout.boxFitScaleDown,
            alignment: context.shapes.alignmentCenterLeft,
            child: Text(
              value,
              style: th.typography.heading2.copyWith(
                color: th.colors.textPrimary,
              ),
              maxLines: 1,
              overflow: AppLayout.textOverflowEllipsis,
            ),
          ),
          SizedBox(height: th.spacing.xs),
          // ----- LABEL -----
          Text(
            label,
            style: th.typography.bodySmall.copyWith(
              color: th.colors.textSecondary,
            ),
            maxLines: 2,
            overflow: AppLayout.textOverflowEllipsis,
          ),
          // ----- SUBTITLE -----
          if (subtitle != null) ...[
            SizedBox(height: th.spacing.xs),
            Text(
              subtitle!,
              style: th.typography.caption.copyWith(
                color: th.colors.textSecondary,
              ),
              maxLines: 1,
              overflow: AppLayout.textOverflowEllipsis,
            ),
          ],
          // ----- CHIP -----
          if (chipLabel != null) ...[
            SizedBox(height: th.spacing.sm),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: th.spacing.sm,
                vertical: th.spacing.xs,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: th.opacities.low),
                borderRadius: BorderRadius.circular(th.spacing.sm),
                border: Border.all(
                  color: accent.withValues(alpha: th.opacities.medium),
                ),
              ),
              child: Text(
                chipLabel!,
                style: th.typography.captionBold.copyWith(color: accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
