import 'package:flutter/material.dart';
import '../../models/tolerance_model.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

class ToleranceStatsCard extends StatelessWidget {
  final ToleranceModel toleranceModel;
  final double daysUntilBaseline;
  final int recentUseCount;

  const ToleranceStatsCard({
    required this.toleranceModel,
    required this.daysUntilBaseline,
    required this.recentUseCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkSurface : Colors.white;
    final borderColor = isDark
        ? UIColors.darkBorder
        : Colors.black.withOpacity(0.05);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        side: BorderSide(color: borderColor),
      ),
      color: backgroundColor,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key metrics',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            const SizedBox(height: ThemeConstants.space16),

            // 2-Column Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetricItem(
                        context,
                        'Half-life',
                        '${toleranceModel.halfLifeHours}h',
                        Icons.timelapse,
                      ),
                      const SizedBox(height: ThemeConstants.space16),
                      _buildMetricItem(
                        context,
                        'Days to baseline',
                        daysUntilBaseline <= 0
                            ? 'Baseline'
                            : '${daysUntilBaseline.toStringAsFixed(1)} days',
                        Icons.calendar_today,
                      ),
                    ],
                  ),
                ),

                // Vertical Divider
                Container(
                  width: 1,
                  height: 80,
                  color: isDark ? UIColors.darkDivider : UIColors.lightDivider,
                  margin: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space16,
                  ),
                ),

                // Column 2
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMetricItem(
                        context,
                        'Tolerance decay',
                        '${toleranceModel.toleranceDecayDays} days',
                        Icons.trending_down,
                      ),
                      const SizedBox(height: ThemeConstants.space16),
                      _buildMetricItem(
                        context,
                        'Recent uses',
                        '$recentUseCount',
                        Icons.history,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: secondaryTextColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: secondaryTextColor,
                fontWeight: ThemeConstants.fontMediumWeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            value,
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
