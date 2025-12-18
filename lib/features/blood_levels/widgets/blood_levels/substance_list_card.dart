// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to new AppTheme system. No deprecated theme usage.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class SubstanceListCard extends StatelessWidget {
  final List<SubstanceInfo> substances;
  final Map<String, Color> substanceColors;

  const SubstanceListCard({
    super.key,
    required this.substances,
    required this.substanceColors,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final acc = context.accent;

    final accentColor = acc.primary;

    // --------------------------
    // EMPTY STATE
    // --------------------------
    if (substances.isEmpty) {
      return Container(
        padding: EdgeInsets.all(sp.xl),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusLg),
          border: Border.all(color: c.border, width: 1),
          boxShadow: t.cardShadow,
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.medical_information_outlined,
                size: 48,
                color: c.textTertiary,
              ),
              SizedBox(height: sp.md),
              Text(
                'No substances in timeframe',
                style: text.body.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // --------------------------
    // SUBSTANCE LIST CARD
    // --------------------------
    return Container(
      padding: EdgeInsets.all(sp.lg),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        border: Border.all(color: c.border, width: 1),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sp.sm),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                ),
                child: Icon(
                  Icons.medication,
                  size: 20,
                  color: accentColor,
                ),
              ),
              SizedBox(width: sp.md),
              Text(
                'Active Substances (${substances.length})',
                style: text.heading4.copyWith(color: c.textPrimary),
              ),
            ],
          ),

          SizedBox(height: sp.lg),

          // SUBSTANCE ITEMS
          ...substances.map((substance) {
            final color =
                substanceColors[substance.name] ?? acc.primary;

            return Padding(
              padding: EdgeInsets.only(bottom: sp.md),
              child: Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  border: Border.all(color: color.withValues(alpha: 0.45)),
                ),
                child: Row(
                  children: [
                    // LEFT BAR
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: sp.md),

                    // MAIN CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            substance.name,
                            style: text.bodyBold.copyWith(
                              color: c.textPrimary,
                            ),
                          ),
                          SizedBox(height: sp.xs),
                          Row(
                            children: [
                              _buildChip(
                                context,
                                substance.roa,
                                color,
                              ),
                              SizedBox(width: sp.sm),
                              _buildChip(
                                context,
                                '${substance.dose.toStringAsFixed(1)}mg',
                                color,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // TIME AGO
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTimeDiff(substance.timeSinceUse),
                          style: text.captionBold.copyWith(color: color),
                        ),
                        Text(
                          'ago',
                          style: text.caption.copyWith(color: c.textTertiary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sp.sm,
        vertical: sp.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(sh.radiusSm),
      ),
      child: Text(
        label,
        style: text.captionBold.copyWith(
          color: color,
        ),
      ),
    );
  }

  String _formatTimeDiff(Duration duration) {
    if (duration.inMinutes < 60) {
      return '${duration.inMinutes}m';
    } else if (duration.inHours < 24) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inDays}d';
    }
  }
}

class SubstanceInfo {
  final String name;
  final String roa;
  final double dose;
  final Duration timeSinceUse;

  SubstanceInfo({
    required this.name,
    required this.roa,
    required this.dose,
    required this.timeSinceUse,
  });
}
