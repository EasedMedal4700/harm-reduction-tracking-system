// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../services/blood_levels_service.dart';
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
    if (levels.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.timeline_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Select a substance to view metabolism timeline',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
    
    // Pass ALL filtered drugs to show multiple lines on the graph
    final allDrugs = levels.values.toList();
    
    return Column(
      children: [
        // Timeline controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
        const SizedBox(height: 16),
        
        // Timeline graph - now showing ALL drugs
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
