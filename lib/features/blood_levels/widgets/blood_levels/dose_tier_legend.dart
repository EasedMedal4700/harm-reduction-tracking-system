// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../services/pharmacokinetics_service.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

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
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;
    final acc = context.accent; // <-- NEW

    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Dose Ranges', style: text.heading4),
          CommonSpacer.vertical(sp.lg),

          ...substanceTiers.entries.map((entry) {
            final substance = entry.key;
            final tiers = entry.value;

            // Substance color fallback uses accent.primary
            final substanceColor = substanceColors[substance] ?? acc.primary;

            return Padding(
              padding: EdgeInsets.only(bottom: sp.md),
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  // Substance name + colored square
                  Row(
                    children: [
                      Container(
                        width: sp.lg,
                        height: sp.lg,
                        decoration: BoxDecoration(
                          color: substanceColor,
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                        ),
                      ),
                      SizedBox(width: sp.sm),
                      Text(substance, style: text.bodyBold),
                    ],
                  ),
                  CommonSpacer.vertical(sp.sm),

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
                          color: tierColor.withValues(
                            alpha: context.opacities.low,
                          ),
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                          border: Border.all(
                            color: tierColor.withValues(
                              alpha: context.opacities.border,
                            ),
                            width: context.borders.thin,
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
