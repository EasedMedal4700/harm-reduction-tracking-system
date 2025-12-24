// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant.
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
    final tx = context.text;
    final c = context.colors;
    final sp = context.spacing;
    return Column(
      children: [
        Icon(icon, color: color, size: context.sizes.iconLg),
        SizedBox(height: sp.sm),
        Text(value, style: tx.heading3.copyWith(color: c.textPrimary)),
        Text(label, style: tx.caption.copyWith(color: c.textSecondary)),
      ],
    );
  }
}
