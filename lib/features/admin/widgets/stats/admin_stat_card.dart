
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-compliant. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Stat card widget for admin dashboard
class AdminStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const AdminStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    final t = context.theme;
    final sh = context.shapes;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        boxShadow: t.cardShadow,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ICON
            Icon(icon, size: context.sizes.iconXl, color: color),

            SizedBox(height: sp.sm),

            // VALUE
            Text(
              value,
              style: text.heading3.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: sp.xs),

            // TITLE
            Text(
              title,
              style: text.caption.copyWith(
                color: c.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            if (subtitle != null) ...[
              SizedBox(height: sp.xs),

              Text(
                subtitle!,
                style: text.caption.copyWith(
                  color: c.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }
}
