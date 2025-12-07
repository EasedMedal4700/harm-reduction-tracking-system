import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;

    return Container(
      padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dose Ranges',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space12),
          ...substanceTiers.entries.map((entry) {
            final substance = entry.key;
            final tiers = entry.value;
            final color = substanceColors[substance] ?? Colors.blue;

            return Padding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space12),
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
                      SizedBox(width: ThemeConstants.space8),
                      Text(
                        substance,
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSmall,
                          fontWeight: ThemeConstants.fontSemiBold,
                          color: isDark ? UIColors.darkText : UIColors.lightText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeConstants.space8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: DoseTier.values.map((tier) {
                      final range = tiers[tier];
                      if (range == null) return const SizedBox.shrink();

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space8,
                          vertical: ThemeConstants.space4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(PharmacokineticsService.getTierColorValue(tier))
                              .withValues(alpha: isDark ? 0.2 : 0.15),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                          border: Border.all(
                            color: Color(PharmacokineticsService.getTierColorValue(tier))
                                .withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${PharmacokineticsService.getTierName(tier)}: ${range.min.toStringAsFixed(0)}-${range.max.toStringAsFixed(0)}mg',
                          style: TextStyle(
                            fontSize: ThemeConstants.fontXSmall,
                            fontWeight: ThemeConstants.fontMediumWeight,
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
