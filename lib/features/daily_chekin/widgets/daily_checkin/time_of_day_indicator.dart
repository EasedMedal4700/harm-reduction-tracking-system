import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard.
import 'package:flutter/material.dart';
import '../../../../common/cards/common_card.dart';

class TimeOfDayIndicator extends StatelessWidget {
  final String currentTimeOfDay;
  const TimeOfDayIndicator({super.key, required this.currentTimeOfDay});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CommonCard(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: context.sizes.heightXs,
        child: Row(
          children: [
            _TimeSegment(
              label: 'Morning',
              isActive: currentTimeOfDay == 'morning',
            ),
            VerticalDivider(width: context.sizes.borderThin, color: c.border),
            _TimeSegment(
              label: 'Afternoon',
              isActive: currentTimeOfDay == 'afternoon',
            ),
            VerticalDivider(width: context.sizes.borderThin, color: c.border),
            _TimeSegment(
              label: 'Evening',
              isActive: currentTimeOfDay == 'evening',
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSegment extends StatelessWidget {
  final String label;
  final bool isActive;
  const _TimeSegment({required this.label, required this.isActive});
  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final ac = context.accent;
    final tx = context.text;
    return Expanded(
      child: Container(
        alignment: context.shapes.alignmentCenter,
        decoration: isActive
            ? BoxDecoration(color: ac.primary.withValues(alpha: 0.15))
            : null,
        child: Text(
          label,
          style: tx.bodySmall.copyWith(
            color: isActive ? ac.primary : c.textSecondary,
            fontWeight: isActive ? tx.bodyBold.fontWeight : tx.body.fontWeight,
          ),
        ),
      ),
    );
  }
}
