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
/// Reusable card container with consistent styling
/// Used across all form sections: Substance, Dosage, ROA, Feelings, etc.
class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool showBorder;
  final Color? borderColor;
  final VoidCallback? onTap;
  const CommonCard({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.showBorder = true,
    this.borderColor,
    this.onTap,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? context.shapes.radiusLg;
    // If no tap handler, use simple Container
    if (onTap == null) {
      return Container(
        padding: padding ?? EdgeInsets.all(context.spacing.cardPadding),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.colors.surface,
          borderRadius: BorderRadius.circular(radius),
          border: showBorder
              ? Border.all(
                  color: borderColor ?? context.colors.border,
                  width: 1,
                )
              : null,
          boxShadow: context.cardShadow,
        ),
        child: child,
      );
    }
    // If tappable, use Material+InkWell
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: context.cardShadow,
      ),
      child: Material(
        color: backgroundColor ?? context.colors.surface,
        shape: showBorder
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: BorderSide(
                  color: borderColor ?? context.colors.border,
                  width: 1,
                ),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? EdgeInsets.all(context.spacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
