import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class TimeOfDayIndicator extends StatelessWidget {
  final String currentTimeOfDay;

  const TimeOfDayIndicator({
    super.key,
    required this.currentTimeOfDay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _TimeSegment(label: 'Morning', isActive: currentTimeOfDay == 'morning'),
          Container(width: 1, color: borderColor),
          _TimeSegment(label: 'Afternoon', isActive: currentTimeOfDay == 'afternoon'),
          Container(width: 1, color: borderColor),
          _TimeSegment(label: 'Evening', isActive: currentTimeOfDay == 'evening'),
        ],
      ),
    );
  }
}

class _TimeSegment extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TimeSegment({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? UIColors.darkNeonCyan
        : UIColors.lightAccentBlue;
    final inactiveTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: isActive
            ? BoxDecoration(color: activeColor.withOpacity(0.15))
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? activeColor : inactiveTextColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: ThemeConstants.fontSmall,
          ),
        ),
      ),
    );
  }
}
