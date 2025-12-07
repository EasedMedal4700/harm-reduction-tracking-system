import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/drug_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [UIColors.darkSurface, UIColors.darkSurface.withValues(alpha: 0.8)]
              : [UIColors.lightSurface, UIColors.lightSurface.withValues(alpha: 0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryItem(
                'Total Uses',
                '$totalUses',
                Icons.bar_chart,
                isDark,
              ),
              _buildSummaryItem(
                'Active Substances',
                '$activeSubstances',
                Icons.science,
                isDark,
              ),
              _buildSummaryItem(
                'Avg Uses',
                avgUses.toStringAsFixed(1),
                Icons.trending_up,
                isDark,
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space12,
              vertical: ThemeConstants.space8,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? UIColors.darkBorder.withValues(alpha: 0.3)
                  : UIColors.lightBorder.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 16,
                  color: DrugCategoryColors.colorFor(mostUsedCategory),
                ),
                SizedBox(width: ThemeConstants.space8),
                Text(
                  'Most Used Category: $mostUsedCategory',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    fontWeight: ThemeConstants.fontSemiBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconMedium,
          color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
        ),
        SizedBox(height: ThemeConstants.space4),
        Text(
          value,
          style: TextStyle(
            fontSize: ThemeConstants.fontLarge,
            fontWeight: ThemeConstants.fontBold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
