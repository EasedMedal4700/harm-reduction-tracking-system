import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';

/// Icon button with consistent styling
class CommonIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;

  const CommonIconButton({
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.tooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark 
        ? UIColors.darkText 
        : UIColors.lightText;
    
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
