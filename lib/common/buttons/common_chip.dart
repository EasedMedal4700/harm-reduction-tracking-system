// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    final accentColor = selectedColor ?? th.accent.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: th.spacing.md,
          vertical: th.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: th.isDark ? 0.15 : 0.1)
              : (unselectedColor ??
                    th.colors.surfaceVariant.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          border: Border.all(
            color: isSelected
                ? (selectedBorderColor ?? accentColor)
                : th.colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected && showGlow
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 16)),
              SizedBox(width: th.spacing.sm),
            ],
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? th.colors.textPrimary
                    : th.colors.textSecondary,
              ),
              SizedBox(width: th.spacing.sm),
            ],
            Text(
              label,
              style: th.text.bodySmall.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? th.colors.textPrimary
                    : th.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
