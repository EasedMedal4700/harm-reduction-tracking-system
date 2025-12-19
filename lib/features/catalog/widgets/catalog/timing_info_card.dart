// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

/// Widget for displaying timing information (onset, duration, after-effects)
class TimingInfoCard extends StatelessWidget {
  final String? onset;
  final String? duration;
  final String? afterEffects;
  final Color accentColor;

  const TimingInfoCard({
    super.key,
    required this.onset,
    required this.duration,
    required this.afterEffects,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    if (onset == null && duration == null && afterEffects == null) {
      return const SizedBox.shrink();
    }

    return CommonCard(
      padding: EdgeInsets.all(t.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: accentColor),
              CommonSpacer.horizontal(t.spacing.xs),
              Text(
                'Timing Information',
                style: t.text.heading3.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),
          const CommonSpacer.vertical(24),

          // Timeline Visualization
          SizedBox(
            height: 40,
            child: Row(
              children: [
                if (onset != null)
                  Expanded(
                    flex: 1,
                    child: _buildTimeBar(
                      t.colors.success,
                      true,
                      duration == null && afterEffects == null,
                    ),
                  ),
                if (duration != null)
                  Expanded(
                    flex: 3,
                    child: _buildTimeBar(
                      t.colors.info,
                      onset == null,
                      afterEffects == null,
                    ),
                  ),
                if (afterEffects != null)
                  Expanded(
                    flex: 2,
                    child: _buildTimeBar(
                      t.colors.warning,
                      onset == null && duration == null,
                      true,
                    ),
                  ),
              ],
            ),
          ),
          const CommonSpacer.vertical(24),

          // Legend
          if (onset != null) _buildTimeLegend(context, 'Onset', onset!, t.colors.success),
          if (duration != null)
            _buildTimeLegend(context, 'Duration', duration!, t.colors.info),
          if (afterEffects != null)
            _buildTimeLegend(context, 'After Effects', afterEffects!, t.colors.warning),
        ],
      ),
    );
  }

  Widget _buildTimeBar(Color color, bool isFirst, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? const Radius.circular(20) : Radius.zero,
          right: isLast ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildTimeLegend(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final t = context.theme;
    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.md),
      child: Row(
        children: [
          Container(
            width: t.spacing.md,
            height: t.spacing.md,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(t.shapes.radiusXs),
            ),
          ),
          SizedBox(width: t.spacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: t.typography.label.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: t.typography.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
