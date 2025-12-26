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
// Notes: Standard outlined button for secondary actions.
class CommonOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? color;
  final Color? borderColor;
  final IconData? icon;
  final double? width;
  final double? height;
  const CommonOutlinedButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.color,
    this.borderColor,
    this.icon,
    this.width,
    this.height,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final effectiveColor = color ?? th.accent.primary;
    final effectiveBorderColor = borderColor ?? effectiveColor;
    return SizedBox(
      width: width,
      height: height ?? context.sizes.buttonHeightLg,
      child: OutlinedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveBorderColor),
          padding: EdgeInsets.symmetric(horizontal: th.spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          ),
          foregroundColor: effectiveColor,
        ),
        child: isLoading
            ? SizedBox(
                height: context.sizes.iconSm,
                width: context.sizes.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: context.borders.medium,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
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
                      color: effectiveColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
