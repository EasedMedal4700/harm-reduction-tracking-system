import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Individual cache statistic display widget
class CacheStatWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const CacheStatWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Column(
      children: [
        Icon(icon, color: color, size: 28),

        SizedBox(height: t.spacing.sm),

        Text(
          value,
          style: t.typography.heading3.copyWith(
            color: t.colors.textPrimary,
          ),
        ),

        Text(
          label,
          style: t.typography.caption.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
