import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final colors = t.colors;
    final spacing = t.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: colors.textSecondary.withOpacity(0.5),
            ),

            SizedBox(height: spacing.xl),

            Text(
              title,
              style: t.typography.heading3.copyWith(
                color: colors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: spacing.sm),

            Text(
              subtitle,
              style: t.typography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
