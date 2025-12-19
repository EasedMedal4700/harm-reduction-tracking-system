// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.

import 'package:flutter/material.dart';
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
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.text;
    final radii = context.shapes;
    
    final orderedBuckets = BucketDefinitions.orderedBuckets;

    // LOADING STATE
    if (systemTolerance == null) {
      return Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(radii.radiusMd),
          border: Border.all(color: colors.border),
        ),
        padding: EdgeInsets.all(spacing.lg),
        child: const Center(
          child: CommonLoader(),
        ),
      );
    }

    final data = systemTolerance!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.xs,
            vertical: spacing.sm,
          ),
          child: Text(
            'System Tolerance Overview',
            style: typography.heading3.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),

        CommonSpacer.vertical(spacing.sm),

        // BUCKET CARDS — horizontal scroll
        SizedBox(
          height: 140.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: spacing.sm),
            itemCount: orderedBuckets.length,
            separatorBuilder: (_, __) => CommonSpacer.horizontal(spacing.sm),
            itemBuilder: (context, index) {
              final bucket = orderedBuckets[index];
              final percent =
                  (data.bucketPercents[bucket] ?? 0.0).clamp(0.0, 100.0);

              final state = ToleranceCalculator.classifyState(percent);

              final contributions = substanceContributions[bucket];
              final isActive = contributions != null && contributions.isNotEmpty;

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