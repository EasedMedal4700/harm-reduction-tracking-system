// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Empty state widget. Fully theme-compliant.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../constants/layout/app_layout.dart';
import '../../../common/layout/common_spacer.dart';

class ActivityEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const ActivityEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl2),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            Icon(
              icon,
              size: sp.xl3 * 2.5,
              color: c.textSecondary.withValues(alpha: 0.5),
            ),
            CommonSpacer.vertical(sp.xl),
            Text(
              title,
              style: tx.heading3.copyWith(color: c.textPrimary),
              textAlign: AppLayout.textAlignCenter,
            ),
            CommonSpacer.vertical(sp.sm),
            Text(
              subtitle,
              style: tx.bodySmall.copyWith(color: c.textSecondary),
              textAlign: AppLayout.textAlignCenter,
            ),
          ],
        ),
      ),
    );
  }
}
