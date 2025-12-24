// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: READY
// Notes: Legend widget for timeline chart. Displays substance names, colors, and half-lives.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

/// Legend widget displaying substance names, colors, and half-lives
class TimelineLegend extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const TimelineLegend({required this.items, super.key});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;
    final tx = context.text;
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: sp.md,
      runSpacing: sp.sm,
      children: items.map((item) {
        final name = item['name'] as String;
        final color = item['color'] as Color;
        final halfLife = item['halfLife'] as double;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(sp.xs),
            border: Border.all(
              color: color.withValues(alpha: th.opacities.border),
            ),
          ),
          child: Row(
            mainAxisSize: AppLayout.mainAxisSizeMin,
            children: [
              Container(
                width: sp.md,
                height: sp.md,
                decoration: BoxDecoration(
                  color: color,
                  shape: context.shapes.boxShapeCircle,
                ),
              ),
              const CommonSpacer.horizontal(4),
              Text(
                '$name (t½: ${halfLife}h)',
                style: tx.caption.copyWith(
                  color: color,
                  fontWeight: tx.bodyBold.fontWeight,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
