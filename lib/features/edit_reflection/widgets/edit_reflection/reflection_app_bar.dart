
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: AppBar for editing reflections. No hardcoded values.

import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

class ReflectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSaving;
  final VoidCallback onSave;

  const ReflectionAppBar({
    super.key,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final a = context.accent;
    final t = context.text;

    return AppBar(
      title: Text('Edit Reflection', style: t.titleLarge.copyWith(color: c.textPrimary)),
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      actions: [
        if (isSaving)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.space16),
              child: SizedBox(
                width: AppThemeConstants.iconSm,
                height: AppThemeConstants.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: AppThemeConstants.borderMedium,
                  valueColor: AlwaysStoppedAnimation<Color>(a.primary),
                ),
              ),
            ),
          )
        else
          TextButton(
            onPressed: onSave,
            child: Text('Save', style: t.labelLarge.copyWith(color: a.primary)),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
