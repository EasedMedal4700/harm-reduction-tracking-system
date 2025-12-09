// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../services/pharmacokinetics_service.dart';

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
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final t = context.theme;
    final acc = context.accent;
    final tierColor = Color(PharmacokineticsService.getTierColorValue(currentTier));

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.border,
          width: 1,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  size: 20,
                ),
              ),
              SizedBox(width: sp.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      substanceName,
                      style: context.text.heading4,
                    ),
                    Text(
                      'Current Status',
                      style: context.text.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: sp.lg),
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
              acc.primary,
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
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;
    
    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(sh.radiusSm),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: text.caption,
          ),
          SizedBox(height: sp.xs),
          Text(
            value,
            style: text.heading3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
