
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: AppBar for editing cravings.

import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

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
    final a = context.accent;
    final t = context.text;
    
    return AppBar(
      title: Text('Edit Craving', style: t.titleLarge.copyWith(color: c.textPrimary)),
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      actions: [
        if (isSaving)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(a.primary),
                ),
              ),
            ),
          )
        else
          TextButton.icon(
            onPressed: onSave,
            icon: Icon(Icons.check, color: a.primary),
            label: Text('Save', style: t.labelLarge.copyWith(color: a.primary)),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
