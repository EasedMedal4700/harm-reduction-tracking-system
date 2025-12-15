import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

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
    final t = context.theme;
    final accentColor = t.accent.primary;
    
    return Container(
      decoration: BoxDecoration(
        color: t.colors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(
          color: highlighted
              ? accentColor
              : t.colors.border,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: t.text.body.copyWith(
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            color: t.colors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: t.text.bodySmall.copyWith(
                  color: t.colors.textSecondary,
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
