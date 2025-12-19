import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Replaces old_common/modern_form_card.dart. Fully aligned with AppThemeExtension.

/// Modern card widget for form sections with glassmorphism effect
class CommonFormCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? accentColor;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CommonFormCard({
    super.key,
    this.title,
    this.icon,
    this.accentColor,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final effectiveAccentColor = accentColor ?? t.accent.primary;

    return Container(
      margin: margin ??
          EdgeInsets.only(
            bottom: t.spacing.lg,
            left: t.spacing.lg,
            right: t.spacing.lg,
          ),
      decoration: t.isDark
          ? BoxDecoration(
              color: t.colors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(t.shapes.radiusLg),
              border: Border.all(
                color: t.colors.border.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: t.cardShadow,
            )
          : BoxDecoration(
              color: t.colors.surface,
              borderRadius: BorderRadius.circular(t.shapes.radiusLg),
              border: Border.all(color: t.colors.border),
              boxShadow: t.cardShadow,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || icon != null)
            Container(
              padding: EdgeInsets.all(t.spacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: t.colors.border,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(t.spacing.sm),
                      decoration: BoxDecoration(
                        color: effectiveAccentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: effectiveAccentColor,
                      ),
                    ),
                    SizedBox(width: t.spacing.md),
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: t.text.heading4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: t.colors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: padding ?? EdgeInsets.all(t.spacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}
