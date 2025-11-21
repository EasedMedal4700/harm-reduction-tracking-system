import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _MetricCard(
            icon: Icons.analytics_outlined,
            iconColor: UIColors.darkNeonBlue,
            value: totalEntries.toString(),
            label: 'Total Entries',
          ),
          SizedBox(width: ThemeConstants.space12),
          _MetricCard(
            icon: Icons.medication_outlined,
            iconColor: UIColors.darkNeonPurple,
            value: mostUsedSubstance.isEmpty ? '-' : mostUsedSubstance,
            label: 'Most Used',
            subtitle: mostUsedCount > 0 ? '$mostUsedCount uses' : null,
          ),
          SizedBox(width: ThemeConstants.space12),
          _MetricCard(
            icon: Icons.calendar_today_outlined,
            iconColor: UIColors.darkNeonTeal,
            value: weeklyAverage.toStringAsFixed(1),
            label: 'Weekly Average',
          ),
          SizedBox(width: ThemeConstants.space12),
          _MetricCard(
            icon: Icons.category_outlined,
            iconColor: UIColors.darkNeonEmerald,
            value: topCategory.isEmpty ? '-' : topCategory,
            label: 'Top Category',
            chipLabel: topCategoryPercent > 0 ? '${topCategoryPercent.toStringAsFixed(0)}%' : null,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? subtitle;
  final String? chipLabel;

  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.subtitle,
    this.chipLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 160,
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: iconColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with colored background
          Container(
            padding: EdgeInsets.all(ThemeConstants.space8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: ThemeConstants.iconMedium,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          // Big number
          Text(
            value,
            style: TextStyle(
              fontSize: ThemeConstants.font3XLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: ThemeConstants.space4),
          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: ThemeConstants.fontXSmall,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
          ),
          // Optional subtitle
          if (subtitle != null) ...[
            SizedBox(height: ThemeConstants.space4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                fontWeight: ThemeConstants.fontRegular,
                color: isDark
                    ? UIColors.darkTextSecondary.withValues(alpha: 0.7)
                    : UIColors.lightTextSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
          // Optional category chip
          if (chipLabel != null) ...[
            SizedBox(height: ThemeConstants.space8),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.space8,
                vertical: ThemeConstants.space4,
              ),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.3),
                  width: ThemeConstants.borderThin,
                ),
              ),
              child: Text(
                chipLabel!,
                style: TextStyle(
                  fontSize: ThemeConstants.fontXSmall,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
