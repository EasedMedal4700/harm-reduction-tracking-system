// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Theme compliant.
import 'package:flutter/material.dart';
import '../../../constants/enums/time_period.dart';
import '../../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final ac = context.accent;
    final tx = context.text;
    return Wrap(
      spacing: sp.md,
      runSpacing: sp.sm,
      alignment: WrapAlignment.center,
      children: TimePeriod.values.map((period) {
        final bool isSelected = period == selectedPeriod;
        return GestureDetector(
          onTap: () => onPeriodChanged(period),
          child: AnimatedContainer(
            duration: th.animations.fast,
            padding: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? ac.primary.withValues(alpha: th.opacities.low)
                  : c.surfaceVariant,
              borderRadius: BorderRadius.circular(sp.sm),
              border: Border.all(
                color: isSelected ? ac.primary : c.border,
                width: isSelected ? th.borders.medium : th.borders.thin,
              ),
              boxShadow: isSelected ? th.cardShadow : null,
            ),
            child: Text(
              _label(period),
              style: tx.bodyBold.copyWith(
                color: isSelected ? ac.primary : c.textPrimary,
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
