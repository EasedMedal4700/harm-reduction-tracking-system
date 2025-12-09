// MIGRATION
// Theme: PARTIAL
// Common: TODO
// Riverpod: TODO
// Notes: Uses context.theme and legacy patterns; needs review for full migration to AppTheme/context extensions.
import 'package:flutter/material.dart';
import '../../utils/tolerance_calculator.dart';
import '../tolerance/bucket_detail_section.dart';

class BucketDetailsWidget extends StatelessWidget {
  final String? selectedBucket;
  final ToleranceResult? systemTolerance;
  final Map<String, Map<String, double>> substanceContributions;
  final Map<String, bool> substanceActiveStates;
  final String? selectedSubstance;
  final void Function(String) onSubstanceSelected;
  final GlobalKey bucketDetailKey;

  const BucketDetailsWidget({
    super.key,
    required this.selectedBucket,
    required this.systemTolerance,
    required this.substanceContributions,
    required this.substanceActiveStates,
    required this.selectedSubstance,
    required this.onSubstanceSelected,
    required this.bucketDetailKey,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedBucket == null || systemTolerance == null) {
      return const SizedBox.shrink();
    }
    
    final bucketType = selectedBucket!;
    final systemData = systemTolerance!;
    final systemTolerancePercent = (systemData.bucketPercents[bucketType] ?? 0.0).clamp(0.0, 100.0);
    final state = ToleranceCalculator.classifyState(systemTolerancePercent);
    final contributions = substanceContributions[bucketType] ?? {};
    
    return Container(
      key: bucketDetailKey,
      child: BucketDetailSection(
        bucketType: bucketType,
        systemTolerancePercent: systemTolerancePercent,
        state: state,
        substanceContributions: contributions,
        substanceActiveStates: substanceActiveStates,
        selectedSubstance: selectedSubstance,
        onSubstanceSelected: onSubstanceSelected,
      ),
    );
  }
}
