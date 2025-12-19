
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Theme alignment & structural cleanup. Not fully migrated or Riverpod integrated.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

import 'analytics_filter_card.dart';
import 'metrics_row.dart';
import 'insight_summary_card.dart';
import 'recent_activity_list.dart';
import 'use_distribution_card.dart';
import 'usage_trends_card.dart';

import '../../../../models/log_entry_model.dart';
import '../../../../constants/enums/time_period.dart';

/// Layout wrapper for Analytics page.
/// Handles responsive switching between single-column (mobile)
/// and two-column (tablet/desktop) displays.
///
/// This widget should remain **layout only**.
/// Do NOT put business logic here — that belongs in the parent.
///
/// WARNING:
/// If this file grows again → extract to:
/// analytics/layout/
///    - analytics_layout_mobile.dart
///    - analytics_layout_desktop.dart
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

        return SingleChildScrollView(
          padding: EdgeInsets.all(t.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Filters
              AnalyticsFilterCard(filterContent: filterContent),
              CommonSpacer.vertical(t.spacing.lg),

              /// 🔹 Metrics at the top (always full-width)
              MetricsRow(
                totalEntries: totalEntries,
                mostUsedSubstance: mostUsedSubstance,
                mostUsedCount: mostUsedCount,
                weeklyAverage: weeklyAverage,
                topCategory: topCategory,
                topCategoryPercent: topCategoryPercent,
              ),
              CommonSpacer.vertical(t.spacing.lg),

              /// 🔹 Main responsive content
              isWideScreen
                  ? _buildWideLayout(context)
                  : _buildNarrowLayout(context),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // DESKTOP/TABLET LAYOUT (2-columns)
  // ---------------------------------------------------------------------------
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
              CommonSpacer.vertical(t.spacing.lg),

              InsightSummaryCard(
                totalEntries: totalEntries,
                mostUsedCategory: mostUsedCategory,
                weeklyAverage: weeklyAverage,
                selectedPeriodText: selectedPeriodText,
              ),
            ],
          ),
        ),

        CommonSpacer.horizontal(t.spacing.lg),

        /// RIGHT COLUMN
        Expanded(
          child: Column(
            children: [
              UsageTrendsCard(
                filteredEntries: filteredEntries,
                period: period,
                substanceToCategory: substanceToCategory,
              ),
              CommonSpacer.vertical(t.spacing.lg),

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

  // ---------------------------------------------------------------------------
  // MOBILE LAYOUT (single column)
  // ---------------------------------------------------------------------------
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
        CommonSpacer.vertical(t.spacing.lg),

        UsageTrendsCard(
          filteredEntries: filteredEntries,
          period: period,
          substanceToCategory: substanceToCategory,
        ),
        CommonSpacer.vertical(t.spacing.lg),

        InsightSummaryCard(
          totalEntries: totalEntries,
          mostUsedCategory: mostUsedCategory,
          weeklyAverage: weeklyAverage,
          selectedPeriodText: selectedPeriodText,
        ),
        CommonSpacer.vertical(t.spacing.lg),

        RecentActivityList(
          entries: filteredEntries,
          substanceToCategory: substanceToCategory,
        ),
      ],
    );
  }
}
