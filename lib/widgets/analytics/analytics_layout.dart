import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use single column for narrow screens (< 900px)
        // Use 2-column for wide screens (>= 900px)
        final isWideScreen = constraints.maxWidth >= 900;

        return AnimatedOpacity(
          opacity: 1.0,
          duration: ThemeConstants.animationNormal,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ThemeConstants.homePagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters section
                AnalyticsFilterCard(
                  filterContent: filterContent,
                ),
                SizedBox(height: ThemeConstants.cardSpacing),

                // Metrics row
                MetricsRow(
                  totalEntries: totalEntries,
                  mostUsedSubstance: mostUsedSubstance,
                  mostUsedCount: mostUsedCount,
                  weeklyAverage: weeklyAverage,
                  topCategory: topCategory,
                  topCategoryPercent: topCategoryPercent,
                ),
                SizedBox(height: ThemeConstants.cardSpacing),

                // Two-column grid layout for wide screens
                if (isWideScreen)
                  _buildWideLayout()
                else
                  // Single column layout for narrow screens
                  _buildNarrowLayout(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
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
              SizedBox(height: ThemeConstants.cardSpacing),
              InsightSummaryCard(
                totalEntries: totalEntries,
                mostUsedCategory: mostUsedCategory,
                weeklyAverage: weeklyAverage,
                selectedPeriodText: selectedPeriodText,
              ),
            ],
          ),
        ),
        SizedBox(width: ThemeConstants.cardSpacing),
        // Right column
        Expanded(
          child: Column(
            children: [
              UsageTrendsCard(
                filteredEntries: filteredEntries,
                period: period,
                substanceToCategory: substanceToCategory,
              ),
              SizedBox(height: ThemeConstants.cardSpacing),
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

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        UseDistributionCard(
          categoryCounts: categoryCounts,
          substanceCounts: substanceCounts,
          filteredEntries: filteredEntries,
          substanceToCategory: substanceToCategory,
          onCategoryTapped: onCategoryTapped,
        ),
        SizedBox(height: ThemeConstants.cardSpacing),
        UsageTrendsCard(
          filteredEntries: filteredEntries,
          period: period,
          substanceToCategory: substanceToCategory,
        ),
        SizedBox(height: ThemeConstants.cardSpacing),
        InsightSummaryCard(
          totalEntries: totalEntries,
          mostUsedCategory: mostUsedCategory,
          weeklyAverage: weeklyAverage,
          selectedPeriodText: selectedPeriodText,
        ),
        SizedBox(height: ThemeConstants.cardSpacing),
        RecentActivityList(
          entries: filteredEntries,
          substanceToCategory: substanceToCategory,
        ),
      ],
    );
  }
}
