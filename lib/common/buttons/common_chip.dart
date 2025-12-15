import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

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
    final t = context.theme;
    final accentColor = selectedColor ?? t.accent.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.md,
          vertical: t.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withOpacity(t.isDark ? 0.15 : 0.1)
              : (unselectedColor ?? t.colors.surfaceVariant.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          border: Border.all(
            color: isSelected
                ? (selectedBorderColor ?? accentColor)
                : t.colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && showGlow
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 16)),
              SizedBox(width: t.spacing.sm),
            ],
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? t.colors.textPrimary
                    : t.colors.textSecondary,
              ),
              SizedBox(width: t.spacing.sm),
            ],
            Text(
              label,
              style: t.text.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? t.colors.textPrimary
                    : t.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
