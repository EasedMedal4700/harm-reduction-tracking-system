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
    final th = context.theme;
    final effectiveAccentColor = accentColor ?? th.accent.primary;
    return Container(
      margin:
          margin ??
          EdgeInsets.only(
            bottom: th.spacing.lg,
            left: th.spacing.lg,
            right: th.spacing.lg,
          ),
      decoration: th.isDark
          ? BoxDecoration(
              color: th.colors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(th.shapes.radiusLg),
              border: Border.all(
                color: th.colors.border.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: th.cardShadow,
            )
          : BoxDecoration(
              color: th.colors.surface,
              borderRadius: BorderRadius.circular(th.shapes.radiusLg),
              border: Border.all(color: th.colors.border),
              boxShadow: th.cardShadow,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || icon != null)
            Container(
              padding: EdgeInsets.all(th.spacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: th.colors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(th.spacing.sm),
                      decoration: BoxDecoration(
                        color: effectiveAccentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
                      ),
                      child: Icon(icon, size: 20, color: effectiveAccentColor),
                    ),
                    SizedBox(width: th.spacing.md),
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: th.text.heading4.copyWith(
                          fontWeight: FontWeight.w600,
                          color: th.colors.textPrimary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: padding ?? EdgeInsets.all(th.spacing.lg),
            child: child,
          ),
        ],
      ),
    );
  }
}
