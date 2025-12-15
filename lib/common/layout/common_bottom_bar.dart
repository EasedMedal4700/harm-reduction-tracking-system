import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

/// Sticky bottom bar for action buttons
/// Provides consistent styling across the app for bottom-placed CTAs
class CommonBottomBar extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CommonBottomBar({
    required this.child,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    
    return Container(
      padding: padding ?? EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        border: Border(
          top: BorderSide(
            color: t.colors.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: child,
    );
  }
}
