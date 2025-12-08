import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;

    return Container(
      decoration: t.cardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: t.spacing.sm),
            Text(
              value,
              style: t.typography.heading3.copyWith(
                color: color,
              ),
            ),
            SizedBox(height: t.spacing.xs),
            Text(
              title,
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle != null) ...[
              SizedBox(height: t.spacing.xs),
              Text(
                subtitle!,
                style: t.typography.caption.copyWith(
                  color: t.colors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

}
