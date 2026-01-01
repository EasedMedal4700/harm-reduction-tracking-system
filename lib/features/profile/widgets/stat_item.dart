// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppTheme system. No deprecated constants remain.
import 'package:flutter/material.dart';
import '../../../common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  const StatItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(th.spacing.md),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(th.spacing.md),
          ),
          child: Icon(icon, color: accent, size: th.sizes.iconLg),
        ),
        CommonSpacer.vertical(th.spacing.sm),
        Text(value, style: th.typography.heading3.copyWith(color: accent)),
        CommonSpacer.vertical(th.spacing.xs),
        Text(
          label,
          style: th.typography.bodySmall.copyWith(
            color: th.colors.textSecondary,
          ),
          textAlign: AppLayout.textAlignCenter,
        ),
      ],
    );
  }
}
