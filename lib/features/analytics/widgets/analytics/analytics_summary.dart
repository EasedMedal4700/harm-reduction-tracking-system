// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Modernized summary card using CommonCard & unified typography. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';

import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';

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
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSectionHeader(
            title: 'Analytics Summary',
            subtitle: selectedPeriodText,
          ),

          const CommonSpacer.vertical(16),

          _buildMetric(context, label: 'Total Entries', value: '$totalEntries'),
          const CommonSpacer.vertical(8),

          _buildMetric(
            context,
            label: 'Average per Week',
            value: avgPerWeek.toStringAsFixed(1),
          ),
          const CommonSpacer.vertical(8),

          _buildMetric(
            context,
            label: 'Most Used Substance',
            value: '$mostUsedSubstance ($mostUsedSubstanceCount)',
          ),
          const CommonSpacer.vertical(8),

          _buildMetric(
            context,
            label: 'Top Category',
            value: '$mostUsedCategory ($topCategoryPercent%)',
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final t = context.theme;

    return Row(
      mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
      children: [
        Text(
          label,
          style: t.typography.body.copyWith(color: t.colors.textSecondary),
        ),
        Text(
          value,
          style: t.typography.bodyBold.copyWith(color: t.colors.textPrimary),
        ),
      ],
    );
  }
}
