// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import 'level_card.dart';
import 'system_overview_card.dart';
import 'risk_assessment_card.dart';
import 'blood_levels_timeline_section.dart';

/// Main content area showing all level cards and overview
class BloodLevelsContent extends StatelessWidget {
  final Map<String, DrugLevel> filteredLevels;
  final Map<String, DrugLevel> allLevels;
  final bool showTimeline;
  final int chartHoursBack;
  final int chartHoursForward;
  final bool chartAdaptiveScale;
  final DateTime referenceTime;
  final ValueChanged<int> onHoursBackChanged;
  final ValueChanged<int> onHoursForwardChanged;
  final ValueChanged<bool> onAdaptiveScaleChanged;
  final void Function(int back, int forward) onPresetSelected;

  const BloodLevelsContent({
    super.key,
    required this.filteredLevels,
    required this.allLevels,
    required this.showTimeline,
    required this.chartHoursBack,
    required this.chartHoursForward,
    required this.chartAdaptiveScale,
    required this.referenceTime,
    required this.onHoursBackChanged,
    required this.onHoursForwardChanged,
    required this.onAdaptiveScaleChanged,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = filteredLevels.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    return ListView(
      children: [
        SystemOverviewCard(levels: filteredLevels, allLevels: allLevels),
        RiskAssessmentCard(levels: filteredLevels),
        const SizedBox(height: 16),
        
        // Metabolism Timeline section
        if (showTimeline) ...[
          BloodLevelsTimelineSection(
            levels: filteredLevels,
            hoursBack: chartHoursBack,
            hoursForward: chartHoursForward,
            adaptiveScale: chartAdaptiveScale,
            referenceTime: referenceTime,
            onHoursBackChanged: onHoursBackChanged,
            onHoursForwardChanged: onHoursForwardChanged,
            onAdaptiveScaleChanged: onAdaptiveScaleChanged,
            onPresetSelected: onPresetSelected,
          ),
          const SizedBox(height: 16),
        ],
        
        ...sorted.map((level) => LevelCard(level: level)),
        const SizedBox(height: 16),
      ],
    );
  }
}
