// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../constants/emus/time_period.dart';
import '../../constants/theme/app_theme_extension.dart';

class TimePeriodSelector extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;

  const TimePeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final acc = context.accent;
    final text = context.text;

    return Wrap(
      spacing: sp.md,
      runSpacing: sp.sm,
      alignment: WrapAlignment.center,
      children: TimePeriod.values.map((period) {
        final bool isSelected = period == selectedPeriod;

        return GestureDetector(
          onTap: () => onPeriodChanged(period),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: sp.lg,
              vertical: sp.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? acc.primary.withValues(alpha: 0.15)
                  : c.surfaceVariant,
              borderRadius: BorderRadius.circular(sp.sm),
              border: Border.all(
                color: isSelected ? acc.primary : c.border,
                width: isSelected ? 1.8 : 1.2,
              ),
              boxShadow: isSelected ? t.cardShadow : null,
            ),
            child: Text(
              _label(period),
              style: text.bodyBold.copyWith(
                color: isSelected ? acc.primary : c.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _label(TimePeriod period) {
    switch (period) {
      case TimePeriod.all:
        return 'All Time';
      case TimePeriod.last7Days:
        return 'Last 7 Days';
      case TimePeriod.last7Weeks:
        return 'Last 7 Weeks';
      case TimePeriod.last7Months:
        return 'Last 7 Months';
    }
  }
}
