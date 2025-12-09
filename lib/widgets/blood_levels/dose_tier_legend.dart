// MIGRATION
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

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.border,
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dose Ranges',
            style: text.heading4,
          ),
          SizedBox(height: sp.md),
          ...substanceTiers.entries.map((entry) {
            final substance = entry.key;
            final tiers = entry.value;
            final color = substanceColors[substance] ?? Colors.blue;

            return Padding(
              padding: EdgeInsets.only(bottom: sp.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: sp.sm),
                      Text(
                        substance,
                        style: text.bodyBold,
                      ),
                    ],
                  ),
                  SizedBox(height: sp.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: DoseTier.values.map((tier) {
                      final range = tiers[tier];
                      if (range == null) return const SizedBox.shrink();

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: sp.sm,
                          vertical: sp.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Color(PharmacokineticsService.getTierColorValue(tier))
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(sh.radiusSm),
                          border: Border.all(
                            color: Color(PharmacokineticsService.getTierColorValue(tier))
                                .withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${PharmacokineticsService.getTierName(tier)}: ${range.min.toStringAsFixed(0)}-${range.max.toStringAsFixed(0)}mg',
                          style: text.caption.copyWith(
                            color: Color(PharmacokineticsService.getTierColorValue(tier)),
                          ),
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
