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
import '../../../../common/feedback/common_loader.dart';
import '../../../../models/bucket_definitions.dart';
import '../../../../utils/tolerance_calculator.dart';
import '../tolerance/system_bucket_card.dart';

class SystemOverviewWidget extends ConsumerWidget {
  final ToleranceResult? systemTolerance;
  final Map<String, bool> substanceActiveStates;
  final Map<String, Map<String, double>> substanceContributions;
  final String? selectedBucket;
  final Function(String) onBucketSelected;
  const SystemOverviewWidget({
    super.key,
    required this.systemTolerance,
    required this.substanceActiveStates,
    required this.substanceContributions,
    required this.selectedBucket,
    required this.onBucketSelected,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    final orderedBuckets = BucketDefinitions.orderedBuckets;
    // LOADING STATE
    if (systemTolerance == null) {
      return Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(color: c.border),
        ),
        padding: EdgeInsets.all(sp.lg),
        child: const Center(child: CommonLoader()),
      );
    }
    final data = systemTolerance!;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        // HEADER
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sp.xs, vertical: sp.sm),
          child: Text(
            'System Tolerance Overview',
            style: tx.heading3.copyWith(color: c.textPrimary),
          ),
        ),
        CommonSpacer.vertical(sp.sm),
        // BUCKET CARDS — horizontal scroll
        SizedBox(
          height: 140.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: sp.sm),
            itemCount: orderedBuckets.length,
            separatorBuilder: (_, __) => CommonSpacer.horizontal(sp.sm),
            itemBuilder: (context, index) {
              final bucket = orderedBuckets[index];
              final percent = (data.bucketPercents[bucket] ?? 0.0).clamp(
                0.0,
                100.0,
              );
              final state = ToleranceCalculator.classifyState(percent);
              final contributions = substanceContributions[bucket];
              final isActive =
                  contributions != null && contributions.isNotEmpty;
              return SystemBucketCard(
                bucketType: bucket,
                tolerancePercent: percent,
                state: state,
                isActive: isActive,
                isSelected: selectedBucket == bucket,
                onTap: () => onBucketSelected(bucket),
              );
            },
          ),
        ),
      ],
    );
  }
}
