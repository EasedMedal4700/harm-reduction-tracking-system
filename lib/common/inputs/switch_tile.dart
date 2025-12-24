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
    final th = context.theme;
    final accentColor = th.accent.primary;
    return Container(
      decoration: BoxDecoration(
        color: th.colors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(th.shapes.radiusMd),
        border: Border.all(
          color: highlighted ? accentColor : th.colors.border,
          width: highlighted ? 2 : 1,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: th.text.body.copyWith(
            fontWeight: value ? FontWeight.w600 : FontWeight.w400,
            color: th.colors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: th.text.bodySmall.copyWith(
                  color: th.colors.textSecondary,
                ),
              )
            : null,
        value: value,
        onChanged: enabled ? onChanged : null,
        activeThumbColor: accentColor,
      ),
    );
  }
}
