// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return Column(
      children: [
        Icon(icon, color: color, size: 28),

        SizedBox(height: sp.sm),

        Text(
          value,
          style: text.heading3.copyWith(
            color: c.textPrimary,
          ),
        ),

        Text(
          label,
          style: text.caption.copyWith(
            color: c.textSecondary,
          ),
        ),
      ],
    );
  }
}
