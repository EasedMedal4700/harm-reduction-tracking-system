import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class SubstanceListCard extends StatelessWidget {
  final List<SubstanceInfo> substances;
  final Map<String, Color> substanceColors;

  const SubstanceListCard({
    super.key,
    required this.substances,
    required this.substanceColors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonTeal : UIColors.lightAccentRed;

    if (substances.isEmpty) {
      return Container(
        padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
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
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.medical_information_outlined,
                size: 48,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              SizedBox(height: ThemeConstants.space12),
              Text(
                'No substances in timeframe',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ThemeConstants.space8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                ),
                child: Icon(
                  Icons.medication,
                  color: accentColor,
                  size: 20,
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              Text(
                'Active Substances (${substances.length})',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space16),
          ...substances.map((substance) {
            final color = substanceColors[substance.name] ?? Colors.blue;
            return Padding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space12),
              child: Container(
                padding: EdgeInsets.all(ThemeConstants.space12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.1 : 0.08),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            substance.name,
                            style: TextStyle(
                              fontSize: ThemeConstants.fontSmall,
                              fontWeight: ThemeConstants.fontSemiBold,
                              color: isDark ? UIColors.darkText : UIColors.lightText,
                            ),
                          ),
                          SizedBox(height: ThemeConstants.space4),
                          Row(
                            children: [
                              _buildChip(
                                substance.roa,
                                color,
                                isDark,
                              ),
                              SizedBox(width: ThemeConstants.space8),
                              _buildChip(
                                '${substance.dose.toStringAsFixed(1)}mg',
                                color,
                                isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTimeDiff(substance.timeSinceUse),
                          style: TextStyle(
                            fontSize: ThemeConstants.fontXSmall,
                            fontWeight: ThemeConstants.fontSemiBold,
                            color: color,
                          ),
                        ),
                        Text(
                          'ago',
                          style: TextStyle(
                            fontSize: ThemeConstants.fontXSmall,
                            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space8,
        vertical: ThemeConstants.space4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.12),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: ThemeConstants.fontXSmall,
          fontWeight: ThemeConstants.fontMediumWeight,
          color: color,
        ),
      ),
    );
  }

  String _formatTimeDiff(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inDays}d';
    }
  }
}

class SubstanceInfo {
  final String name;
  final String roa;
  final double dose;
  final Duration timeSinceUse;

  SubstanceInfo({
    required this.name,
    required this.roa,
    required this.dose,
    required this.timeSinceUse,
  });
}
