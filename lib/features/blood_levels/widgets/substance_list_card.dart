// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';

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
    final c = context.colors;
    final th = context.theme;
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final ac = context.accent;
    final accentColor = ac.primary;
    // --------------------------
    // EMPTY STATE
    // --------------------------
    if (substances.isEmpty) {
      return CommonCard(
        padding: EdgeInsets.all(sp.xl),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.medical_information_outlined,
                size: th.sizes.iconXl,
                color: c.textTertiary,
              ),
              const CommonSpacer.vertical(16),
              Text(
                'No substances in timeframe',
                style: tx.body.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      );
    }
    // --------------------------
    // SUBSTANCE LIST CARD
    // --------------------------
    return CommonCard(
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
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
                  size: th.sizes.iconSm,
                  color: accentColor,
                ),
              ),
              const CommonSpacer.horizontal(16),
              Text(
                'Active Substances (${substances.length})',
                style: tx.heading4.copyWith(color: c.textPrimary),
              ),
            ],
          ),
          const CommonSpacer.vertical(24),
          // SUBSTANCE ITEMS
          ...substances.map((substance) {
            final color = substanceColors[substance.name] ?? ac.primary;
            return Padding(
              padding: EdgeInsets.only(bottom: sp.md),
              child: Container(
                padding: EdgeInsets.all(sp.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                  border: Border.all(
                    color: color.withValues(alpha: th.opacities.border),
                  ),
                ),
                child: Row(
                  children: [
                    // LEFT BAR
                    Container(
                      width: sp.xs,
                      height: sp.xl2,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(sh.radiusXs),
                      ),
                    ),
                    SizedBox(width: sp.md),
                    // MAIN CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                        children: [
                          Text(
                            substance.name,
                            style: tx.bodyBold.copyWith(color: c.textPrimary),
                          ),
                          SizedBox(height: sp.xs),
                          Row(
                            children: [
                              _buildChip(context, substance.roa, color),
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
                      crossAxisAlignment: AppLayout.crossAxisAlignmentEnd,
                      children: [
                        Text(
                          _formatTimeDiff(substance.timeSinceUse),
                          style: tx.captionBold.copyWith(color: color),
                        ),
                        Text(
                          'ago',
                          style: tx.caption.copyWith(color: c.textTertiary),
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
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(sh.radiusSm),
      ),
      child: Text(label, style: tx.captionBold.copyWith(color: color)),
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
