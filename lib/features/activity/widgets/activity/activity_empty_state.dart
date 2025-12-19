
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Empty state widget. Fully theme-compliant.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

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
    final text = context.text;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.xl2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: sp.xl3 * 2.5,
              color: c.textSecondary.withValues(alpha: 0.5),
            ),

            CommonSpacer(height: sp.xl),

            Text(
              title,
              style: text.heading3.copyWith(color: c.textPrimary),
              textAlign: TextAlign.center,
            ),

            CommonSpacer(height: sp.sm),

            Text(
              subtitle,
              style: text.bodySmall.copyWith(color: c.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
