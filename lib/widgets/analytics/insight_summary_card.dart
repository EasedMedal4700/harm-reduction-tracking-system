import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class InsightSummaryCard extends StatelessWidget {
  final int totalEntries;
  final String mostUsedCategory;
  final double weeklyAverage;
  final String selectedPeriodText;

  const InsightSummaryCard({
    super.key,
    required this.totalEntries,
    required this.mostUsedCategory,
    required this.weeklyAverage,
    required this.selectedPeriodText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonEmerald : UIColors.lightAccentGreen;

    return Container(
      padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
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
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ThemeConstants.space8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  color: accentColor,
                  size: ThemeConstants.iconMedium,
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              Text(
                'Insight Summary',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          // Insight paragraph
          Text(
            _generateInsightText(),
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontRegular,
              color: isDark
                  ? UIColors.darkText.withValues(alpha: 0.7)
                  : UIColors.lightText.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _generateInsightText() {
    if (totalEntries == 0) {
      return 'No usage data recorded for $selectedPeriodText. Start logging your substance usage to see personalized insights and trends.';
    }

    final avgPerWeekText = weeklyAverage.toStringAsFixed(1);
    final categoryText = mostUsedCategory.isNotEmpty ? mostUsedCategory : 'various categories';

    if (totalEntries == 1) {
      return 'You have logged 1 entry in $selectedPeriodText. Continue tracking to build a comprehensive history and identify patterns in your usage.';
    }

    return 'During $selectedPeriodText, you logged $totalEntries entries with an average of $avgPerWeekText uses per week. Your most frequently used category is $categoryText. This data helps identify patterns and can support informed decisions about your substance use habits.';
  }
}
