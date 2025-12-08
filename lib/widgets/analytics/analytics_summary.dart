import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class AnalyticsSummary extends StatelessWidget {
  final int totalEntries;
  final double avgPerWeek;
  final String mostUsedCategory;
  final int mostUsedCount;
  final String selectedPeriodText;
  final String mostUsedSubstance;
  final int mostUsedSubstanceCount;
  final int topCategoryPercent;

  const AnalyticsSummary({
    super.key,
    required this.totalEntries,
    required this.avgPerWeek,
    required this.mostUsedCategory,
    required this.mostUsedCount,
    required this.selectedPeriodText,
    required this.mostUsedSubstance,
    required this.mostUsedSubstanceCount,
    required this.topCategoryPercent,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.md),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics Summary ($selectedPeriodText)',
            style: t.typography.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
          SizedBox(height: t.spacing.md),

          Text(
            'Total Entries: $totalEntries',
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          Text(
            'Average per Week: ${avgPerWeek.toStringAsFixed(1)}',
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          Text(
            'Most Used Substance: $mostUsedSubstance ($mostUsedSubstanceCount)',
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          Text(
            'Main Category: $mostUsedCategory ($topCategoryPercent%)',
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
