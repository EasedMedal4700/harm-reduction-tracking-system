// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppTheme system. No deprecated constants remain.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../common/widgets/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(t.spacing.md),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(t.spacing.md),
          ),
          child: Icon(icon, color: accent, size: t.sizes.iconLg),
        ),
        CommonSpacer.vertical(t.spacing.sm),
        Text(
          value,
          style: t.typography.heading3.copyWith(color: accent),
        ),
        CommonSpacer.vertical(t.spacing.xs),
        Text(
          label,
          style: t.typography.bodySmall.copyWith(
            color: t.colors.textSecondary,
          ),
          textAlign: AppLayout.textAlignCenter,
        ),
      ],
    );
  }
}
