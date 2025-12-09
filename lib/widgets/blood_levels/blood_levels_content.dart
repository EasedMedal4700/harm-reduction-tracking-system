// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: This file now uses theme spacing and colors, but child widgets are not migrated yet.

import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import 'level_card.dart';
import 'system_overview_card.dart';
import 'risk_assessment_card.dart';
import 'blood_levels_timeline_section.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final sp = context.spacing;

    final sorted = filteredLevels.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    return ListView(
      padding: EdgeInsets.all(sp.lg),
      children: [
        SystemOverviewCard(
          levels: filteredLevels,
          allLevels: allLevels,
        ),

        SizedBox(height: sp.lg),

        RiskAssessmentCard(levels: filteredLevels),

        SizedBox(height: sp.lg),

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
          ),
          SizedBox(height: sp.lg),
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
