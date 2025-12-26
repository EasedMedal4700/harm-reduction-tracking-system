// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Presentation-only; insight text comes from computed providers.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/text/common_section_header.dart';
import '../../../common/layout/common_spacer.dart';

class InsightSummaryCard extends StatelessWidget {
  final String selectedPeriodText;
  final String insightText;
  const InsightSummaryCard({
    super.key,
    required this.selectedPeriodText,
    required this.insightText,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          /// Standardized header with icon
          CommonSectionHeader(
            title: 'Insight Summary',
            subtitle: selectedPeriodText,
          ),
          CommonSpacer.vertical(th.spacing.md),
          Text(
            insightText,
            style: th.typography.body.copyWith(
              color: th.colors.textSecondary,
              height: context.borders.medium,
            ),
          ),
        ],
      ),
    );
  }
}
