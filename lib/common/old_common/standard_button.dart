import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  
  const StandardButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary 
            ? t.accent.primary 
            : t.colors.surfaceVariant,
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.xl,
          vertical: t.spacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        ),
      ),
      child: Text(
        text,
        style: t.text.body.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}