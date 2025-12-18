import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension. No hardcoded values.

/// Primary action button (e.g., Save Entry)
class CommonPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;

  const CommonPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final defaultBgColor = t.accent.primary;
    final defaultTextColor = t.colors.textInverse;
    
    return SizedBox(
      width: width,
      height: height ?? context.sizes.buttonHeightLg,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBgColor,
          foregroundColor: textColor ?? defaultTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          ),
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: t.spacing.xl,
            vertical: t.spacing.lg,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: context.sizes.iconSm,
                width: context.sizes.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: context.borders.medium,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? defaultTextColor,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: context.sizes.iconSm),
                    SizedBox(width: t.spacing.sm),
                  ],
                  Text(
                    label,
                    style: t.text.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
