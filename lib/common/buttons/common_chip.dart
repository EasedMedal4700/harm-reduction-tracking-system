import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Selectable chip component for emotions, triggers, body signals
class CommonChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final String? emoji;
  final IconData? icon;
  final bool showGlow;

  const CommonChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.emoji,
    this.icon,
    this.showGlow = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = selectedColor ??
        (isDark ? UIColors.darkNeonViolet : UIColors.lightAccentPurple);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ThemeConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space12,
          vertical: ThemeConstants.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? accentColor.withOpacity(0.15) : accentColor.withOpacity(0.1))
              : (unselectedColor ??
                  (isDark ? const Color(0x08FFFFFF) : Colors.grey.shade100)),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          border: Border.all(
            color: isSelected
                ? (selectedBorderColor ?? accentColor)
                : (isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && showGlow
              ? UIColors.createNeonGlow(accentColor, intensity: 0.15)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: ThemeConstants.space8),
            ],
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? (isDark ? UIColors.darkText : UIColors.lightText)
                    : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
              ),
              const SizedBox(width: ThemeConstants.space8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight:
                    isSelected ? ThemeConstants.fontMediumWeight : ThemeConstants.fontRegular,
                color: isSelected
                    ? (isDark ? UIColors.darkText : UIColors.lightText)
                    : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
