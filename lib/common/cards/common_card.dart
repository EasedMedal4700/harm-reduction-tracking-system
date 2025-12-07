import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: padding ?? const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: child,
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    final defaultBorderColor = isDark 
        ? const Color(0x14FFFFFF) 
        : UIColors.lightBorder;
    
    if (isDark) {
      return BoxDecoration(
        color: backgroundColor ?? const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.cardRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ?? defaultBorderColor,
                width: 1,
              )
            : null,
      );
    } else {
      return BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.cardRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ?? defaultBorderColor,
                width: 1,
              )
            : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      );
    }
  }
}
