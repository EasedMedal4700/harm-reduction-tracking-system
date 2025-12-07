import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBgColor = isDark 
        ? UIColors.darkNeonCyan
        : UIColors.lightAccentBlue;
    final defaultTextColor = isDark 
        ? UIColors.darkBackground
        : Colors.white;
    
    return SizedBox(
      width: width,
      height: height ?? 56.0,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? defaultBgColor,
          foregroundColor: textColor ?? defaultTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space24,
            vertical: ThemeConstants.space16,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
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
                    Icon(icon, size: 20),
                    const SizedBox(width: ThemeConstants.space8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontLarge,
                      fontWeight: ThemeConstants.fontSemiBold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
