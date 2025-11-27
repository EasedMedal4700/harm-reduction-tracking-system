import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

/// Card showing days until tolerance returns to baseline
class BucketBaselineCard extends StatelessWidget {
  final double daysToBaseline;
  final bool isDark;

  const BucketBaselineCard({
    super.key,
    required this.daysToBaseline,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: isDark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
            size: 24,
          ),
          SizedBox(width: ThemeConstants.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Days to Baseline',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: ThemeConstants.space4),
                Text(
                  daysToBaseline < 0.1
                      ? 'At baseline'
                      : '${daysToBaseline.toStringAsFixed(1)} days',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontBold,
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
}
