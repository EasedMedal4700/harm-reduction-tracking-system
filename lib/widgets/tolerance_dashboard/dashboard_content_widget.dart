import 'package:flutter/material.dart';
import '../../models/tolerance_model.dart';
import '../../utils/tolerance_calculator.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';
import '../tolerance/tolerance_stats_card.dart';
import '../tolerance/tolerance_notes_card.dart';
import '../tolerance/recent_uses_card.dart';
import '../tolerance/debug_substance_list.dart';
import '../tolerance/tolerance_disclaimer.dart';
import '../tolerance/unified_bucket_tolerance_widget.dart';
import 'system_overview_widget.dart';
import 'bucket_details_widget.dart';
import 'debug_panel_widget.dart';

class DashboardContentWidget extends StatelessWidget {
  final ToleranceModel? toleranceModel;
  final ToleranceResult? systemTolerance;
  final ToleranceResult? substanceTolerance;
  final List<UseLogEntry> useEvents;
  final String? errorMessage;
  final String? selectedSubstance;
  final String? selectedBucket;
  final Map<String, Map<String, double>> substanceContributions;
  final Map<String, bool> substanceActiveStates;
  final bool showDebugSubstances;
  final bool showDebugPanel;
  final Map<String, double> perSubstanceTolerances;
  final bool isLoadingPerSubstance;
  final Function(String) onSubstanceSelected;
  final Function(String) onBucketSelected;
  final GlobalKey bucketDetailKey;
  final bool isDark;

  const DashboardContentWidget({
    super.key,
    required this.toleranceModel,
    required this.systemTolerance,
    required this.substanceTolerance,
    required this.useEvents,
    required this.errorMessage,
    required this.selectedSubstance,
    required this.selectedBucket,
    required this.substanceContributions,
    required this.substanceActiveStates,
    required this.showDebugSubstances,
    required this.showDebugPanel,
    required this.perSubstanceTolerances,
    required this.isLoadingPerSubstance,
    required this.onSubstanceSelected,
    required this.onBucketSelected,
    required this.bucketDetailKey,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 0. Safety Disclaimer (TOP - CRITICAL)
        const CompactToleranceDisclaimer(),
        const SizedBox(height: ThemeConstants.cardSpacing),

        // 1. System Tolerance Overview (ALL 7 BUCKETS)
        SystemOverviewWidget(
          systemTolerance: systemTolerance,
          substanceActiveStates: substanceActiveStates,
          substanceContributions: substanceContributions,
          selectedBucket: selectedBucket,
          onBucketSelected: onBucketSelected,
          isDark: isDark,
        ),
        const SizedBox(height: ThemeConstants.cardSpacing),

        // 2. Bucket Details (Selected bucket with contributing substances)
        if (selectedBucket != null)
          BucketDetailsWidget(
            selectedBucket: selectedBucket,
            systemTolerance: systemTolerance,
            substanceContributions: substanceContributions,
            substanceActiveStates: substanceActiveStates,
            selectedSubstance: selectedSubstance,
            onSubstanceSelected: onSubstanceSelected,
            bucketDetailKey: bucketDetailKey,
          ),
        
        if (selectedBucket != null)
          const SizedBox(height: ThemeConstants.cardSpacing),

        // 3. Substance Detail (existing unified widget - only if substance selected)
        if (selectedSubstance != null && toleranceModel != null && substanceTolerance != null)
          UnifiedBucketToleranceWidget(
            toleranceModel: toleranceModel!,
            toleranceResult: substanceTolerance!,
            substanceName: selectedSubstance!,
          ),

        if (selectedSubstance != null && toleranceModel != null && substanceTolerance != null)
          const SizedBox(height: ThemeConstants.cardSpacing),

        // 4. Key Metrics (Bottom)
        if (errorMessage != null)
          Card(
            color: isDark ? UIColors.darkSurface : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: isDark ? UIColors.darkTextSecondary : Colors.black54,
                ),
              ),
            ),
          )
        else if (toleranceModel != null) ...[
          ToleranceStatsCard(
            toleranceModel: toleranceModel!,
            daysUntilBaseline: substanceTolerance?.overallDaysUntilBaseline ?? 0,
            recentUseCount: useEvents.length,
          ),
          const SizedBox(height: ThemeConstants.cardSpacing),
          ToleranceNotesCard(notes: toleranceModel!.notes),
        ],

        if (useEvents.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.cardSpacing),
          RecentUsesCard(useEvents: useEvents),
        ],

        // Debug: Per-substance tolerances
        if (showDebugSubstances) ...[
          const SizedBox(height: ThemeConstants.cardSpacing),
          DebugSubstanceList(
            perSubstanceTolerances: perSubstanceTolerances,
            isLoading: isLoadingPerSubstance,
          ),
        ],

        if (showDebugPanel) ...[
          const SizedBox(height: ThemeConstants.cardSpacing),
          DebugPanelWidget(
            systemTolerance: systemTolerance,
            substanceTolerance: substanceTolerance,
            selectedSubstance: selectedSubstance,
            isDark: isDark,
          ),
        ],
      ],
    );
  }
}
