// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/colors/app_colors_dark.dart';
import '../../constants/colors/app_colors_light.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: padding ?? const EdgeInsets.all(AppThemeConstants.spaceLg),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColorsLight.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColorsDark.border : AppColorsLight.border,
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
