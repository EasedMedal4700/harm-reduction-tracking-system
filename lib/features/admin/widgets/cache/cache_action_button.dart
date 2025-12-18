
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-based. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-based. No hardcoded values.
/// Action button for cache management operations
class CacheActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CacheActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    return ElevatedButton.icon(
      onPressed: onPressed,

      icon: Icon(
        icon,
        size: context.sizes.iconSm,
        color: color, // stays as user accent color
      ),

      label: Text(
        label,
        style: text.button.copyWith(color: color),
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: context.opacities.veryLow),
        foregroundColor: color,
        shadowColor: c.overlayHeavy,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: sp.lg,
          vertical: sp.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sp.sm),
          side: BorderSide(
            color: color.withValues(alpha: context.opacities.border),
            width: context.borders.thin,
          ),
        ),
      ),
    );
  }
}
