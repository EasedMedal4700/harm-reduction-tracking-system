
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Modern Insight Summary using CommonCard & SectionHeader. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';

import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';

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

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          /// Standardized header with icon
          CommonSectionHeader(
            title: 'Insight Summary',
            subtitle: selectedPeriodText,
          ),

          CommonSpacer.vertical(t.spacing.md),

          Text(
            _generateInsightText(),
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
              height: context.borders.medium,
            ),
          ),
        ],
      ),
    );
  }

  // Keep for now; move to AnalyticsService later
  String _generateInsightText() {
    if (totalEntries == 0) {
      return 'No usage records found for $selectedPeriodText. Start logging to receive personalized insights and healthier pattern tracking.';
    }

    if (totalEntries == 1) {
      return 'You logged 1 entry in $selectedPeriodText. Keep tracking to build a meaningful overview of your habits and long-term trends.';
    }

    final avg = weeklyAverage.toStringAsFixed(1);
    final cat = mostUsedCategory.isEmpty ? 'multiple categories' : mostUsedCategory;

    return 'During $selectedPeriodText, you logged $totalEntries entries with an average of $avg uses per week. Your most frequent category was $cat. Identifying these trends helps support safer and more informed decisions.';
  }
}
