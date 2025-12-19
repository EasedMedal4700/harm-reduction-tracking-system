// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use CommonCard. No Riverpod.
import 'package:flutter/material.dart';
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
    final t = context.theme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;

    // ===== MOBILE LAYOUT (Grid) =====
    if (isNarrow) {
      final aspect = screenWidth < 380 ? 1.1 : 1.25;

      return SizedBox(
        height: 330,     // ensures proper rendering in ListViews
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: t.spacing.md,
          crossAxisSpacing: t.spacing.md,
          childAspectRatio: aspect,
          children: [
            _MetricCard(
              icon: Icons.analytics_outlined,
              accent: t.accent.primary,
              value: totalEntries.toString(),
              label: 'Total Entries',
            ),
            _MetricCard(
              icon: Icons.medication_outlined,
              accent: t.accent.secondary,
              value: mostUsedSubstance.isEmpty ? '-' : mostUsedSubstance,
              label: 'Most Used',
              subtitle: mostUsedCount > 0 ? '$mostUsedCount uses' : null,
            ),
            _MetricCard(
              icon: Icons.calendar_today_outlined,
              accent: t.accent.secondary,          // replaced invalid primaryVariant
              value: weeklyAverage.toStringAsFixed(1),
              label: 'Weekly Average',
            ),
            _MetricCard(
              icon: Icons.category_outlined,
              accent: t.accent.primary,
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
            accent: t.accent.primary,
            value: totalEntries.toString(),
            label: 'Total Entries',
          ),
        ),
        SizedBox(width: t.spacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.medication_outlined,
            accent: t.accent.secondary,
            value: mostUsedSubstance.isEmpty ? '-' : mostUsedSubstance,
            label: 'Most Used',
            subtitle: mostUsedCount > 0 ? '$mostUsedCount uses' : null,
          ),
        ),
        SizedBox(width: t.spacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.calendar_today_outlined,
            accent: t.accent.secondary,
            value: weeklyAverage.toStringAsFixed(1),
            label: 'Weekly Average',
          ),
        ),
        SizedBox(width: t.spacing.md),
        Expanded(
          child: _MetricCard(
            icon: Icons.category_outlined,
            accent: t.accent.primary,
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
    final t = context.theme;

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----- ICON -----
          Container(
            padding: EdgeInsets.all(t.spacing.sm),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(t.spacing.sm),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),

          SizedBox(height: t.spacing.sm),

          // ----- VALUE -----
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: t.typography.heading2.copyWith(
                color: t.colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: t.spacing.xs),

          // ----- LABEL -----
          Text(
            label,
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // ----- SUBTITLE -----
          if (subtitle != null) ...[
            SizedBox(height: t.spacing.xs),
            Text(
              subtitle!,
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // ----- CHIP -----
          if (chipLabel != null) ...[
            SizedBox(height: t.spacing.sm),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.sm,
                vertical: t.spacing.xs,
              ),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(t.spacing.sm),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Text(
                chipLabel!,
                style: t.typography.captionBold.copyWith(color: accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
