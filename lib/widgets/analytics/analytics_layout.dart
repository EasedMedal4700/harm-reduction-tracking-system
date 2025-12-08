import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

import 'analytics_filter_card.dart';
import 'metrics_row.dart';
import 'use_distribution_card.dart';
import 'insight_summary_card.dart';
import 'usage_trends_card.dart';
import 'recent_activity_list.dart';
import '../../models/log_entry_model.dart';
import '../../constants/emus/time_period.dart';

/// Main layout widget for analytics content
/// Handles responsive layout switching between single and two-column layouts
class AnalyticsLayout extends StatelessWidget {
  final Widget filterContent;
  final int totalEntries;
  final String mostUsedSubstance;
  final int mostUsedCount;
  final double weeklyAverage;
  final String topCategory;
  final double topCategoryPercent;
  final Map<String, int> categoryCounts;
  final Map<String, int> substanceCounts;
  final List<LogEntry> filteredEntries;
  final Map<String, String> substanceToCategory;
  final Function(String) onCategoryTapped;
  final TimePeriod period;
  final String selectedPeriodText;
  final String mostUsedCategory;

  const AnalyticsLayout({
    super.key,
    required this.filterContent,
    required this.totalEntries,
    required this.mostUsedSubstance,
    required this.mostUsedCount,
    required this.weeklyAverage,
    required this.topCategory,
    required this.topCategoryPercent,
    required this.categoryCounts,
    required this.substanceCounts,
    required this.filteredEntries,
    required this.substanceToCategory,
    required this.onCategoryTapped,
    required this.period,
    required this.selectedPeriodText,
    required this.mostUsedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 900;

        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 200),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(t.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Filters section
                AnalyticsFilterCard(filterContent: filterContent),
                SizedBox(height: t.spacing.lg),

                /// Metrics row
                MetricsRow(
                  totalEntries: totalEntries,
                  mostUsedSubstance: mostUsedSubstance,
                  mostUsedCount: mostUsedCount,
                  weeklyAverage: weeklyAverage,
                  topCategory: topCategory,
                  topCategoryPercent: topCategoryPercent,
                ),
                SizedBox(height: t.spacing.lg),

                /// Wide vs Narrow
                isWideScreen ? _buildWideLayout(context) : _buildNarrowLayout(context),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------
  // Wide layout (desktop/tablet)
  // ---------------------------
  Widget _buildWideLayout(BuildContext context) {
    final t = context.theme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT COLUMN
        Expanded(
          child: Column(
            children: [
              UseDistributionCard(
                categoryCounts: categoryCounts,
                substanceCounts: substanceCounts,
                filteredEntries: filteredEntries,
                substanceToCategory: substanceToCategory,
                onCategoryTapped: onCategoryTapped,
              ),
              SizedBox(height: t.spacing.lg),
              InsightSummaryCard(
                totalEntries: totalEntries,
                mostUsedCategory: mostUsedCategory,
                weeklyAverage: weeklyAverage,
                selectedPeriodText: selectedPeriodText,
              ),
            ],
          ),
        ),

        SizedBox(width: t.spacing.lg),

        /// RIGHT COLUMN
        Expanded(
          child: Column(
            children: [
              UsageTrendsCard(
                filteredEntries: filteredEntries,
                period: period,
                substanceToCategory: substanceToCategory,
              ),
              SizedBox(height: t.spacing.lg),
              RecentActivityList(
                entries: filteredEntries,
                substanceToCategory: substanceToCategory,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------
  // Narrow layout (mobile)
  // ---------------------------
  Widget _buildNarrowLayout(BuildContext context) {
    final t = context.theme;

    return Column(
      children: [
        UseDistributionCard(
          categoryCounts: categoryCounts,
          substanceCounts: substanceCounts,
          filteredEntries: filteredEntries,
          substanceToCategory: substanceToCategory,
          onCategoryTapped: onCategoryTapped,
        ),
        SizedBox(height: t.spacing.lg),

        UsageTrendsCard(
          filteredEntries: filteredEntries,
          period: period,
          substanceToCategory: substanceToCategory,
        ),
        SizedBox(height: t.spacing.lg),

        InsightSummaryCard(
          totalEntries: totalEntries,
          mostUsedCategory: mostUsedCategory,
          weeklyAverage: weeklyAverage,
          selectedPeriodText: selectedPeriodText,
        ),
        SizedBox(height: t.spacing.lg),

        RecentActivityList(
          entries: filteredEntries,
          substanceToCategory: substanceToCategory,
        ),
      ],
    );
  }
}
