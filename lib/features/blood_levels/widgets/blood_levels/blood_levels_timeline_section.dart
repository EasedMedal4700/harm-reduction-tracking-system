// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';
import 'metabolism_timeline_card.dart';
import 'metabolism_timeline_controls.dart';

/// Complete timeline section with controls and chart
class BloodLevelsTimelineSection extends StatelessWidget {
  final Map<String, DrugLevel> levels;
  final int hoursBack;
  final int hoursForward;
  final bool adaptiveScale;
  final DateTime referenceTime;
  final ValueChanged<int> onHoursBackChanged;
  final ValueChanged<int> onHoursForwardChanged;
  final ValueChanged<bool> onAdaptiveScaleChanged;
  final void Function(int back, int forward) onPresetSelected;
  final BloodLevelsService? service;

  const BloodLevelsTimelineSection({
    super.key,
    required this.levels,
    required this.hoursBack,
    required this.hoursForward,
    required this.adaptiveScale,
    required this.referenceTime,
    required this.onHoursBackChanged,
    required this.onHoursForwardChanged,
    required this.onAdaptiveScaleChanged,
    required this.onPresetSelected,
    this.service,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    // Empty state
    if (levels.isEmpty) {
      return CommonCard(
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.timeline_outlined,
                size: context.sizes.iconXl,
                color: c.textSecondary,
              ),
              CommonSpacer.vertical(sp.lg),
              Text(
                'Select a substance to view metabolism timeline',
                style: text.body.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // Show ALL drugs to draw multiple PK curves
    final allDrugs = levels.values.toList();

    return Column(
      children: [
        // Timeline controls
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sp.lg),
          child: MetabolismTimelineControls(
            hoursBack: hoursBack,
            hoursForward: hoursForward,
            adaptiveScale: adaptiveScale,
            onHoursBackChanged: onHoursBackChanged,
            onHoursForwardChanged: onHoursForwardChanged,
            onAdaptiveScaleChanged: onAdaptiveScaleChanged,
            onPresetSelected: onPresetSelected,
          ),
        ),
        const CommonSpacer.vertical(24),

        // Timeline graph
        MetabolismTimelineCard(
          drugLevels: allDrugs,
          hoursBack: hoursBack,
          hoursForward: hoursForward,
          adaptiveScale: adaptiveScale,
          referenceTime: referenceTime,
          service: service,
        ),
      ],
    );
  }
}
