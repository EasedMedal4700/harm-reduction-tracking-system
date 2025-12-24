// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final sp = context.spacing;
    // EMPTY STATE
    if (systemTolerance == null ||
        (systemTolerance!.bucketPercents.isEmpty &&
            substanceActiveStates.isEmpty)) {
      return EmptyStateWidget(onAddEntry: onAddEntry);
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // SYSTEM OVERVIEW
          SystemOverviewWidget(
            systemTolerance: systemTolerance,
            substanceActiveStates: substanceActiveStates,
            substanceContributions: substanceContributions,
            selectedBucket: selectedBucket,
            onBucketSelected: (bucket) => onBucketSelected(bucket),
          ),
          CommonSpacer.vertical(sp.lg),
          // BUCKET DETAILS (if selected)
          if (selectedBucket != null) ...[
            BucketDetailsWidget(
              bucketType: selectedBucket!,
              tolerancePercent:
                  systemTolerance?.bucketPercents[selectedBucket!] ?? 0.0,
              substanceContributions:
                  substanceContributions[selectedBucket!] ?? {},
              onClose: () => onBucketSelected(null),
            ),
            CommonSpacer.vertical(sp.lg),
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
    final sp = context.spacing;

    final c = context.colors;
    final tx = context.text;
    final sh = context.shapes;
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(sh.radiusSm),
        border: Border.all(color: c.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: c.info,
            size: context.sizes.iconMd,
          ),
          CommonSpacer.horizontal(sp.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  'About Tolerance Systems',
                  style: tx.body.copyWith(
                    color: c.textPrimary,
                    fontWeight: tx.bodyBold.fontWeight,
                  ),
                ),
                CommonSpacer.vertical(sp.xs),
                Text(
                  'Different substances affect different neurotransmitter systems. Understanding cross-tolerance helps you make safer choices.',
                  style: tx.bodySmall.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
