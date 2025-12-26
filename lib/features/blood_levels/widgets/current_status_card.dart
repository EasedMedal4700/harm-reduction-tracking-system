// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../services/pharmacokinetics_service.dart';
import 'dose_tier_theme_color.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';

class CurrentStatusCard extends StatelessWidget {
  final String substanceName;
  final DoseTier currentTier;
  final double currentPercentage;
  final double? timeToNextTier; // hours
  final Color substanceColor;
  const CurrentStatusCard({
    super.key,
    required this.substanceName,
    required this.currentTier,
    required this.currentPercentage,
    this.timeToNextTier,
    required this.substanceColor,
  });
  String _formatTime(double hours) {
    if (hours < 1) {
      return '${(hours * 60).toStringAsFixed(0)}m';
    } else if (hours < 24) {
      return '${hours.toStringAsFixed(1)}h';
    } else {
      final days = hours / 24;
      return '${days.toStringAsFixed(1)}d';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final ac = context.accent;
    final tierColor = currentTier.themeColor(context);
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(sp.sm),
                decoration: BoxDecoration(
                  color: substanceColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(sh.radiusSm),
                ),
                child: Icon(
                  Icons.monitor_heart,
                  color: substanceColor,
                  size: context.sizes.iconSm,
                ),
              ),
              SizedBox(width: sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    Text(substanceName, style: tx.heading4),
                    Text('Current Status', style: tx.caption),
                  ],
                ),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.xl),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  context,
                  'Current Level',
                  '${currentPercentage.toStringAsFixed(1)}%',
                  tierColor,
                ),
              ),
              SizedBox(width: sp.md),
              Expanded(
                child: _buildInfoBox(
                  context,
                  'Dose Tier',
                  PharmacokineticsService.getTierName(currentTier),
                  tierColor,
                ),
              ),
            ],
          ),
          if (timeToNextTier != null) ...[
            SizedBox(height: sp.md),
            _buildInfoBox(
              context,
              'Time to Next Tier',
              _formatTime(timeToNextTier!),
              ac.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBox(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.opacities.veryLow),
        borderRadius: BorderRadius.circular(sh.radiusSm),
        border: Border.all(
          color: color.withValues(alpha: context.opacities.medium),
          width: context.borders.thin,
        ),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(label, style: tx.caption),
          SizedBox(height: sp.xs),
          Text(value, style: tx.heading3.copyWith(color: color)),
        ],
      ),
    );
  }
}
