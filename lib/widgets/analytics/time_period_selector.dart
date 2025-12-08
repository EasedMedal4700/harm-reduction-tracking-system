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

    return Wrap(
      spacing: t.spacing.md,
      runSpacing: t.spacing.sm,
      alignment: WrapAlignment.center,
      children: TimePeriod.values.map((period) {
        final bool isSelected = period == selectedPeriod;

        return GestureDetector(
          onTap: () => onPeriodChanged(period),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.lg,
              vertical: t.spacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? t.accent.primary.withOpacity(0.15)
                  : t.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(t.spacing.sm),
              border: Border.all(
                color: isSelected
                    ? t.accent.primary
                    : t.colors.border,
                width: isSelected ? 1.8 : 1.2,
              ),
              boxShadow: isSelected ? t.cardShadow : null,
            ),
            child: Text(
              _label(period),
              style: t.typography.bodyBold.copyWith(
                color: isSelected
                    ? t.accent.primary
                    : t.colors.textPrimary,
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
