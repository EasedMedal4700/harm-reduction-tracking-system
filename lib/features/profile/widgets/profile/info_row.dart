// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppTheme. Removed deprecated colors.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

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
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Icon(icon, size: t.sizes.iconSm, color: t.colors.textSecondary),

          CommonSpacer.horizontal(spacing.lg),

          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                // Label
                Text(label, style: t.typography.caption),

                SizedBox(height: spacing.xs),

                // Value
                Text(value, style: t.typography.bodyBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
