// MIGRATION COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/layout/common_spacer.dart';
import 'blood_levels_time_display.dart';

/// App bar for blood levels page with all action buttons.
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
    final c = context.colors; // palette colors
    final text = context.text; // typography
    final sp = context.spacing; // spacing
    final acc = context.accent; // accent colors
    return AppBar(
      backgroundColor: c.surface,
      surfaceTintColor: c.transparent,
      elevation: context.sizes.elevationNone,
      shadowColor: c.transparent,
      titleSpacing: sp.md,
      title: BloodLevelsTimeDisplay(selectedTime: selectedTime),
      actionsIconTheme: IconThemeData(
        color: c.textPrimary,
        size: context.sizes.iconMd,
      ),
      actions: [
        // Time machine button
        IconButton(
          icon: Icon(
            selectedTime.difference(DateTime.now()).abs().inMinutes < 5
                ? Icons.access_time
                : Icons.history,
          ),
          tooltip: 'Time Machine',
          onPressed: onTimeMachinePressed,
        ),
        // Filter button + badge
        IconButton(
          icon: Badge(
            label: Text(
              '$filterCount',
              style: text.captionBold.copyWith(color: c.textInverse),
            ),
            isLabelVisible: filterCount > 0,
            backgroundColor: acc.primary,
            child: Icon(Icons.filter_list),
          ),
          tooltip: 'Filters',
          onPressed: onFilterPressed,
        ),
        // Timeline button
        IconButton(
          icon: Icon(
            timelineVisible ? Icons.timeline : Icons.timeline_outlined,
          ),
          tooltip: 'Metabolism Timeline',
          onPressed: onTimelinePressed,
        ),
        // Refresh button
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
          onPressed: onRefreshPressed,
        ),
        const CommonSpacer.horizontal(8), // breathing space at end
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
