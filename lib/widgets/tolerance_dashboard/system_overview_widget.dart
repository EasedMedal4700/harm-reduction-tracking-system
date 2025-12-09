import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../models/tolerance_model.dart';
import '../../models/bucket_definitions.dart';
import '../../utils/tolerance_calculator.dart';
import '../tolerance/system_bucket_card.dart';

class SystemOverviewWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final t = context.theme;
    final orderedBuckets = BucketDefinitions.orderedBuckets;

    // LOADING STATE
    if (systemTolerance == null) {
      return Container(
        decoration: BoxDecoration(
          color: t.colors.surface,
          borderRadius: BorderRadius.circular(t.spacing.md),
          border: Border.all(color: t.colors.border),
        ),
        padding: EdgeInsets.all(t.spacing.lg),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final data = systemTolerance!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: t.spacing.xs,
            vertical: t.spacing.sm,
          ),
          child: Text(
            'System Tolerance Overview',
            style: t.typography.heading3.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
        ),

        SizedBox(height: t.spacing.sm),

        // BUCKET CARDS — horizontal
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: t.spacing.sm),
            itemCount: orderedBuckets.length,
            separatorBuilder: (_, __) => SizedBox(width: t.spacing.sm),
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
