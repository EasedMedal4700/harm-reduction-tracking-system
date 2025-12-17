import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';




class TimeOfDayIndicator extends StatelessWidget {
  final String currentTimeOfDay;

  const TimeOfDayIndicator({
    super.key,
    required this.currentTimeOfDay,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sh = context.shapes;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          _TimeSegment(label: 'Morning', isActive: currentTimeOfDay == 'morning'),
          Container(width: 1, color: c.border),
          _TimeSegment(label: 'Afternoon', isActive: currentTimeOfDay == 'afternoon'),
          Container(width: 1, color: c.border),
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
    final c = context.colors;
    final acc = context.accent;
    final text = context.text;

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: isActive
            ? BoxDecoration(color: acc.primary.withValues(alpha: 0.15))
            : null,
        child: Text(
          label,
          style: text.bodySmall.copyWith(
            color: isActive ? acc.primary : c.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}


