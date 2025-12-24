// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

enum BloodLevelTimeframe {
  hours6('6 Hours', Duration(hours: 6)),
  hours12('12 Hours', Duration(hours: 12)),
  hours24('24 Hours', Duration(hours: 24)),
  hours48('48 Hours', Duration(hours: 48)),
  days3('3 Days', Duration(days: 3)),
  week('1 Week', Duration(days: 7));

  const BloodLevelTimeframe(this.label, this.duration);
  final String label;
  final Duration duration;
}

class TimeframeSelector extends StatelessWidget {
  final BloodLevelTimeframe selectedTimeframe;
  final ValueChanged<BloodLevelTimeframe> onChanged;
  const TimeframeSelector({
    super.key,
    required this.selectedTimeframe,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final ac = context.accent;
    return CommonCard(
      padding: EdgeInsets.all(sp.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sp.xs),
                decoration: BoxDecoration(
                  color: ac.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                ),
                child: Icon(
                  Icons.schedule,
                  color: ac.primary,
                  size: th.sizes.iconSm,
                ),
              ),
              const CommonSpacer.horizontal(8),
              Text('Timeframe', style: tx.heading4),
            ],
          ),
          const CommonSpacer.vertical(16),
          // Chips
          Wrap(
            spacing: sp.sm,
            runSpacing: sp.sm,
            children: BloodLevelTimeframe.values.map((timeframe) {
              final isSelected = timeframe == selectedTimeframe;
              return InkWell(
                onTap: () => onChanged(timeframe),
                borderRadius: BorderRadius.circular(sh.radiusSm),
                child: AnimatedContainer(
                  duration: th.animations.fast,
                  padding: EdgeInsets.symmetric(
                    horizontal: sp.md,
                    vertical: sp.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ac.primary.withValues(alpha: 0.18)
                        : c.surfaceVariant,
                    borderRadius: BorderRadius.circular(sh.radiusSm),
                    border: Border.all(
                      color: isSelected
                          ? ac.primary
                          : c.border.withValues(alpha: 0.4),
                      width: isSelected ? 1.8 : 1.2,
                    ),
                    boxShadow: isSelected ? th.cardShadow : null,
                  ),
                  child: Text(
                    timeframe.label,
                    style: tx.bodyBold.copyWith(
                      color: isSelected ? ac.primary : c.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
