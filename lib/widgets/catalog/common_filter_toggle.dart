import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class CommonFilterToggle extends StatelessWidget {
  final bool showCommonOnly;
  final bool isDark;
  final Color accentColor;
  final ValueChanged<bool> onChanged;

  const CommonFilterToggle({
    super.key,
    required this.showCommonOnly,
    required this.isDark,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space16,
        vertical: ThemeConstants.space12,
      ),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.radiusMedium,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(
                ThemeConstants.radiusMedium,
              ),
              border: Border.all(color: UIColors.lightBorder),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            color: showCommonOnly
                ? accentColor
                : (isDark
                      ? UIColors.darkTextSecondary
                      : UIColors.lightTextSecondary),
            size: ThemeConstants.iconSmall,
          ),
          SizedBox(width: ThemeConstants.space12),
          Expanded(
            child: Text(
              'Common Only',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontSemiBold,
                color: showCommonOnly
                    ? accentColor
                    : (isDark ? UIColors.darkText : UIColors.lightText),
              ),
            ),
          ),
          Switch(
            value: showCommonOnly,
            onChanged: onChanged,
            activeThumbColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
