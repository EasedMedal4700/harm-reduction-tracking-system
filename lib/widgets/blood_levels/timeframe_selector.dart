import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

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
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: accentColor,
                size: 20,
              ),
              SizedBox(width: ThemeConstants.space8),
              Text(
                'Timeframe',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: BloodLevelTimeframe.values.map((timeframe) {
              final isSelected = timeframe == selectedTimeframe;
              return InkWell(
                onTap: () => onChanged(timeframe),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                child: AnimatedContainer(
                  duration: ThemeConstants.animationFast,
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space12,
                    vertical: ThemeConstants.space8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: isDark ? 0.2 : 0.15)
                        : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    timeframe.label,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: isSelected
                          ? ThemeConstants.fontSemiBold
                          : ThemeConstants.fontMediumWeight,
                      color: isSelected
                          ? accentColor
                          : (isDark ? UIColors.darkText : UIColors.lightText),
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
