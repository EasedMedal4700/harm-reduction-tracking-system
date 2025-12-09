// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import 'blood_levels_time_display.dart';

/// App bar for blood levels page with all action buttons
class BloodLevelsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime selectedTime;
  final VoidCallback onTimeMachinePressed;
  final VoidCallback onFilterPressed;
  final VoidCallback onTimelinePressed;
  final VoidCallback onRefreshPressed;
  final int filterCount;
  final bool timelineVisible;

  const BloodLevelsAppBar({
    super.key,
    required this.selectedTime,
    required this.onTimeMachinePressed,
    required this.onFilterPressed,
    required this.onTimelinePressed,
    required this.onRefreshPressed,
    required this.filterCount,
    required this.timelineVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BloodLevelsTimeDisplay(selectedTime: selectedTime),
      actions: [
        // Time machine button
        IconButton(
          icon: Icon(selectedTime.difference(DateTime.now()).abs().inMinutes < 5 
            ? Icons.access_time 
            : Icons.history),
          tooltip: 'Time Machine',
          onPressed: onTimeMachinePressed,
        ),
        // Filter button
        IconButton(
          icon: Badge(
            label: Text('$filterCount'),
            isLabelVisible: filterCount > 0,
            child: const Icon(Icons.filter_list),
          ),
          tooltip: 'Filters',
          onPressed: onFilterPressed,
        ),
        // Timeline button
        IconButton(
          icon: Icon(timelineVisible ? Icons.timeline : Icons.timeline_outlined),
          tooltip: 'Metabolism Timeline',
          onPressed: onTimelinePressed,
        ),
        // Refresh button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefreshPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
