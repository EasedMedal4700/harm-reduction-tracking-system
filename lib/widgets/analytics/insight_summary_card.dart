import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;

    return Container(
      padding: EdgeInsets.all(t.spacing.xl),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.md),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(t.spacing.sm),
                decoration: BoxDecoration(
                  color: t.accent.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(t.spacing.sm),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  color: t.accent.primary,
                  size: 22,
                ),
              ),
              SizedBox(width: t.spacing.md),
              Text(
                'Insight Summary',
                style: t.typography.heading3.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: t.spacing.lg),

          /// Insight text
          Text(
            _generateInsightText(),
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
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
    final categoryText =
        mostUsedCategory.isNotEmpty ? mostUsedCategory : 'various categories';

    if (totalEntries == 1) {
      return 'You have logged 1 entry in $selectedPeriodText. Continue tracking to build a comprehensive history and identify patterns in your usage.';
    }

    return 'During $selectedPeriodText, you logged $totalEntries entries with an average of $avgPerWeekText uses per week. Your most frequently used category is $categoryText. This helps identify patterns and supports informed decisions about your substance use habits.';
  }
}
