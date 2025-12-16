import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
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

  const CommonCard({
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.showBorder = true,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(context.spacing.cardPadding),
      decoration: _buildDecoration(context),
      child: child,
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: backgroundColor ?? context.colors.surface,
      borderRadius: BorderRadius.circular(
        borderRadius ?? context.shapes.radiusLg,
      ),
      border: showBorder
          ? Border.all(
              color: borderColor ?? context.colors.border,
              width: 1,
            )
          : null,
      boxShadow: context.cardShadow,
    );
  }
}
