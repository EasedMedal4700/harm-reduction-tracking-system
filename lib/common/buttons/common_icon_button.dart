import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

/// Icon button with consistent styling
class CommonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;

  const CommonIconButton({
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.tooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final defaultColor = t.colors.textPrimary;
    
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: color ?? defaultColor,
      iconSize: size ?? 24,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
      ),
    );
  }
}
