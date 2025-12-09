// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/colors/app_colors_dark.dart';
import '../../constants/colors/app_colors_light.dart';

/// Switch tile with consistent styling for toggles
/// Used for medical purpose, notifications, settings, etc.
class CommonSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final bool highlighted;

  const CommonSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
    this.highlighted = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? AppColorsDark.accentPrimary : AppColorsLight.accentPrimary;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0x08FFFFFF) : const Color(0xFFF3F4F8),
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
        border: Border.all(
          color: highlighted
              ? accentColor
              : (isDark ? const Color(0x14FFFFFF) : AppColorsLight.border),
          width: highlighted ? 2 : 1,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            color: isDark ? AppColorsDark.textPrimary : AppColorsLight.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColorsDark.textSecondary : AppColorsLight.textSecondary,
                ),
              )
            : null,
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: accentColor,
      ),
    );
  }
}
