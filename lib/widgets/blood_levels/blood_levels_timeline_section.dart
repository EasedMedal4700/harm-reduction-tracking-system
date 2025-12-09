// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: All deprecated colors removed. Now uses full AppTheme system with neon/wellness UI.

import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
import '../../constants/theme/app_theme_extension.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.theme;
    final sp = context.spacing;
    final text = context.text;

    // Empty state
    if (levels.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: sp.lg),
        padding: EdgeInsets.all(sp.xl),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(t.shapes.radiusLg),
          border: Border.all(color: c.border),
          boxShadow: t.cardShadow,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.timeline_outlined,
                  size: 48, color: c.textSecondary),
              SizedBox(height: sp.md),
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
        SizedBox(height: sp.lg),

        // Timeline graph
        MetabolismTimelineCard(
          drugLevels: allDrugs,
          hoursBack: hoursBack,
          hoursForward: hoursForward,
          adaptiveScale: adaptiveScale,
          referenceTime: referenceTime,
        ),
      ],
    );
  }
}
