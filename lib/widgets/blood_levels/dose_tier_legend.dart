// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to new AppTheme system. All deprecated constants removed.

import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../services/pharmacokinetics_service.dart';

class DoseTierLegend extends StatelessWidget {
  final Map<String, Map<DoseTier, DoseRange>> substanceTiers;
  final Map<String, Color> substanceColors;

  const DoseTierLegend({
    super.key,
    required this.substanceTiers,
    required this.substanceColors,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.theme;
    final text = context.text;
    final acc = context.accent;        // <-- NEW

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dose Ranges', style: text.heading4),
          SizedBox(height: sp.md),

          ...substanceTiers.entries.map((entry) {
            final substance = entry.key;
            final tiers = entry.value;

            // Substance color fallback uses accent.primary
            final substanceColor =
                substanceColors[substance] ?? acc.primary;

            return Padding(
              padding: EdgeInsets.only(bottom: sp.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Substance name + colored square
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: substanceColor,
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                        ),
                      ),
                      SizedBox(width: sp.sm),
                      Text(substance, style: text.bodyBold),
                    ],
                  ),
                  SizedBox(height: sp.sm),

                  // Tier badges
                  Wrap(
                    spacing: sp.sm,
                    runSpacing: sp.sm,
                    children: DoseTier.values.map((tier) {
                      final range = tiers[tier];
                      if (range == null) return const SizedBox.shrink();

                      final tierColor = Color(
                        PharmacokineticsService.getTierColorValue(tier),
                      );

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sp.sm,
                          vertical: sp.xs,
                        ),
                        decoration: BoxDecoration(
                          color: tierColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                          border: Border.all(
                            color: tierColor.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${PharmacokineticsService.getTierName(tier)}: '
                          '${range.min.toStringAsFixed(0)}–${range.max.toStringAsFixed(0)} mg',
                          style: text.caption.copyWith(color: tierColor),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
