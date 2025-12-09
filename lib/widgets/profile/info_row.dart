
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppTheme. Removed deprecated colors.

import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final spacing = t.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: t.colors.textSecondary,
          ),

          SizedBox(width: spacing.lg),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  label,
                  style: t.typography.caption,
                ),

                SizedBox(height: spacing.xs),

                // Value
                Text(
                  value,
                  style: t.typography.bodyBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
