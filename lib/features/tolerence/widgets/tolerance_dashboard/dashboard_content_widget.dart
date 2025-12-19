// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../utils/tolerance_calculator.dart';
import 'system_overview_widget.dart';
import 'bucket_details_widget.dart';
import 'empty_state_widget.dart';

class DashboardContentWidget extends ConsumerWidget {
  final ToleranceResult? systemTolerance;
  final Map<String, bool> substanceActiveStates;
  final Map<String, Map<String, double>> substanceContributions;
  final String? selectedBucket;
  final Function(String?) onBucketSelected;
  final VoidCallback? onAddEntry;

  const DashboardContentWidget({
    super.key,
    required this.systemTolerance,
    required this.substanceActiveStates,
    required this.substanceContributions,
    required this.selectedBucket,
    required this.onBucketSelected,
    this.onAddEntry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;

    // EMPTY STATE
    if (systemTolerance == null || 
        (systemTolerance!.bucketPercents.isEmpty && 
         substanceActiveStates.isEmpty)) {
      return EmptyStateWidget(onAddEntry: onAddEntry);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SYSTEM OVERVIEW
          SystemOverviewWidget(
            systemTolerance: systemTolerance,
            substanceActiveStates: substanceActiveStates,
            substanceContributions: substanceContributions,
            selectedBucket: selectedBucket,
            onBucketSelected: (bucket) => onBucketSelected(bucket),
          ),

          CommonSpacer.vertical(spacing.lg),

          // BUCKET DETAILS (if selected)
          if (selectedBucket != null) ...[
            BucketDetailsWidget(
              bucketType: selectedBucket!,
              tolerancePercent: systemTolerance?.bucketPercents[selectedBucket!] ?? 0.0,
              substanceContributions: substanceContributions[selectedBucket!] ?? {},
              onClose: () => onBucketSelected(null),
            ),
            CommonSpacer.vertical(spacing.lg),
          ],

          // HELPFUL TIP
          _HelpfulTipCard(),
        ],
      ),
    );
  }
}

class _HelpfulTipCard extends ConsumerWidget {
  const _HelpfulTipCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: colors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radii.radiusSm),
        border: Border.all(color: colors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: colors.info,
            size: context.sizes.iconMd,
          ),
          CommonSpacer.horizontal(spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Tolerance Systems',
                  style: typography.body.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CommonSpacer.vertical(spacing.xs),
                Text(
                  'Different substances affect different neurotransmitter systems. Understanding cross-tolerance helps you make safer choices.',
                  style: typography.bodySmall.copyWith(
                    color: colors.textSecondary,
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