import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme.dart';

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
    final t = context.theme;
    
    return Container(
      padding: padding ?? EdgeInsets.all(t.spacing.cardPadding),
      decoration: _buildDecoration(t),
      child: child,
    );
  }

  BoxDecoration _buildDecoration(AppTheme t) {
    final defaultBorderColor = t.colors.border;
    
    return BoxDecoration(
      color: backgroundColor ?? t.colors.surface,
      borderRadius: BorderRadius.circular(borderRadius ?? t.shapes.radiusLg),
      border: showBorder
          ? Border.all(
              color: borderColor ?? defaultBorderColor,
              width: 1,
            )
          : null,
      boxShadow: t.cardShadow,
    );
  }
}
