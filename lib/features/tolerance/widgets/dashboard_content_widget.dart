// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Dashboard content widget

import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import '../models/tolerance_models.dart';
import 'system_overview_widget.dart';
import 'empty_state_widget.dart';
import 'bucket_details_widget.dart';

class DashboardContentWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final th = context.theme;
    final sp = th.sp;

    // EMPTY STATE
    if (systemTolerance == null ||
        (systemTolerance!.bucketPercents.isEmpty &&
            substanceActiveStates.isEmpty)) {
      return EmptyStateWidget(onAddEntry: onAddEntry);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SYSTEM OVERVIEW
          SystemOverviewWidget(
            systemTolerance: systemTolerance,
            substanceActiveStates: substanceActiveStates,
            substanceContributions: substanceContributions,
            selectedBucket: selectedBucket,
            onBucketSelected: (bucket) {
              if (selectedBucket == bucket) {
                onBucketSelected(null); // Deselect
              } else {
                onBucketSelected(bucket);
              }
            },
          ),

          if (selectedBucket != null) ...[
            CommonSpacer.vertical(sp.lg),
            // BUCKET DETAILS
            BucketDetailsWidget(
              bucketType: selectedBucket!,
              tolerancePercent:
                  systemTolerance!.bucketPercents[selectedBucket] ?? 0.0,
              substanceContributions:
                  substanceContributions[selectedBucket] ?? {},
              onClose: () => onBucketSelected(null),
            ),
          ],
        ],
      ),
    );
  }
}
