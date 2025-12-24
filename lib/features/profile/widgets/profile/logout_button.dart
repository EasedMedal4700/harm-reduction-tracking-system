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
    final th = context.theme;
    final spacing = th.spacing;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout),
        label: Text('Logout', style: th.typography.button),
        style: ElevatedButton.styleFrom(
          backgroundColor: th.colors.error,
          foregroundColor: th.colors.textInverse,
          padding: EdgeInsets.symmetric(vertical: spacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          ),
          elevation: context.sizes.elevationNone,
        ),
      ),
    );
  }
}
