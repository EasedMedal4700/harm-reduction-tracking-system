// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    final defaultBgColor = th.accent.primary;
    final defaultTextColor = th.colors.textInverse;
    return SizedBox(
      width: width,
      height: height ?? context.sizes.buttonHeightLg,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBgColor,
          foregroundColor: textColor ?? defaultTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          ),
          elevation: 2,
          padding: EdgeInsets.symmetric(
            horizontal: th.spacing.xl,
            vertical: th.spacing.lg,
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
                    SizedBox(width: th.spacing.sm),
                  ],
                  Text(
                    label,
                    style: th.text.bodyLarge.copyWith(
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
