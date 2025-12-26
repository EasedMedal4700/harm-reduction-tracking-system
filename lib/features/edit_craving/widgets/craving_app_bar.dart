// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: AppBar for editing cravings. No hardcoded values.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import '../../../common/feedback/common_loader.dart';

class CravingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSaving;
  final VoidCallback onSave;
  const CravingAppBar({
    super.key,
    required this.isSaving,
    required this.onSave,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    final tx = context.text;
    return AppBar(
      title: Text(
        'Edit Craving',
        style: tx.titleLarge.copyWith(color: c.textPrimary),
      ),
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: context.sizes.elevationNone,
      actions: [
        if (isSaving)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
              child: CommonLoader(
                size: context.sizes.iconSm,
                color: ac.primary,
              ),
            ),
          )
        else
          TextButton.icon(
            onPressed: onSave,
            icon: Icon(
              Icons.check,
              color: ac.primary,
              size: context.sizes.iconMd,
            ),
            label: Text(
              'Save',
              style: tx.labelLarge.copyWith(color: ac.primary),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
