// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: System overview widget

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../common/feedback/common_loader.dart';
import '../../../common/cards/common_card.dart';
import '../../../models/bucket_definitions.dart';
import '../models/tolerance_models.dart';
import '../controllers/tolerance_logic.dart';
import 'system_bucket_card.dart';

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
    final th = context.theme;
    final sp = th.sp;
    final sh = th.shapes;

    if (systemTolerance == null) {
      return CommonCard(
        borderRadius: sh.radiusMd,
        padding: EdgeInsets.all(sp.lg),
        child: const Center(child: CommonLoader()),
      );
    }

    final data = systemTolerance!;
    final orderedBuckets = BucketDefinitions.orderedBuckets;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: th.sizes.heightMd,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: orderedBuckets.length,
            separatorBuilder: (context, index) =>
                CommonSpacer.horizontal(sp.md),
            itemBuilder: (context, index) {
              final bucket = orderedBuckets[index];
              final percent = data.bucketPercents[bucket] ?? 0.0;
              final state = ToleranceLogic.classifyState(percent);

              bool isActive = false;
              if (substanceContributions.containsKey(bucket)) {
                for (final substance in substanceContributions[bucket]!.keys) {
                  if (substanceActiveStates[substance] == true) {
                    isActive = true;
                    break;
                  }
                }
              }

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
