// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to AppTheme. Removed deprecated color usage.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final spacing = t.spacing;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout),
        label: Text('Logout', style: t.typography.button),
        style: ElevatedButton.styleFrom(
          backgroundColor: t.colors.error,
          foregroundColor: t.colors.textInverse,
          padding: EdgeInsets.symmetric(vertical: spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          ),
          elevation: context.sizes.elevationNone,
        ),
      ),
    );
  }
}
