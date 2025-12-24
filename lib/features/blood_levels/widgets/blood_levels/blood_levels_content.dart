// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to use CommonSpacer.
import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import 'level_card.dart';
import 'system_overview_card.dart';
import 'risk_assessment_card.dart';
import 'blood_levels_timeline_section.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

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
  final BloodLevelsService? service;
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
    this.service,
  });
  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    final sorted = filteredLevels.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));
    return ListView(
      padding: EdgeInsets.all(sp.lg),
      children: [
        SystemOverviewCard(levels: filteredLevels, allLevels: allLevels),
        const CommonSpacer.vertical(24),
        RiskAssessmentCard(levels: filteredLevels),
        const CommonSpacer.vertical(24),
        // Metabolism Timeline
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
            service: service,
          ),
          const CommonSpacer.vertical(24),
        ],
        // Level cards
        ...sorted.map(
          (level) => Padding(
            padding: EdgeInsets.only(bottom: sp.lg),
            child: LevelCard(level: level),
          ),
        ),
      ],
    );
  }
}
