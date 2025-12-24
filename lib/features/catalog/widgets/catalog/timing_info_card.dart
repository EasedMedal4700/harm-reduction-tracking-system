// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../constants/theme/app_spacing.dart';

const double _timelineHeight = 40.0;

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
    final th = context.theme;
    if (onset == null && duration == null && afterEffects == null) {
      return const SizedBox.shrink();
    }
    return CommonCard(
      padding: EdgeInsets.all(th.spacing.md),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: accentColor),
              CommonSpacer.horizontal(th.spacing.xs),
              Text(
                'Timing Information',
                style: th.tx.heading3.copyWith(color: th.colors.textPrimary),
              ),
            ],
          ),
          const CommonSpacer.vertical(AppSpacingConstants.xl),
          // Timeline Visualization
          SizedBox(
            height: _timelineHeight,
            child: Row(
              children: [
                if (onset != null)
                  Expanded(
                    flex: AppLayout.flex1,
                    child: _buildTimeBar(
                      th.colors.success,
                      true,
                      duration == null && afterEffects == null,
                    ),
                  ),
                if (duration != null)
                  Expanded(
                    flex: AppLayout.flex3,
                    child: _buildTimeBar(
                      th.colors.info,
                      onset == null,
                      afterEffects == null,
                    ),
                  ),
                if (afterEffects != null)
                  Expanded(
                    flex: AppLayout.flex2,
                    child: _buildTimeBar(
                      th.colors.warning,
                      onset == null && duration == null,
                      true,
                    ),
                  ),
              ],
            ),
          ),
          const CommonSpacer.vertical(24),
          // Legend
          if (onset != null)
            _buildTimeLegend(context, 'Onset', onset!, th.colors.success),
          if (duration != null)
            _buildTimeLegend(context, 'Duration', duration!, th.colors.info),
          if (afterEffects != null)
            _buildTimeLegend(
              context,
              'After Effects',
              afterEffects!,
              th.colors.warning,
            ),
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
    final th = context.theme;
    final tx = context.text;

    return Padding(
      padding: EdgeInsets.only(bottom: th.spacing.md),
      child: Row(
        children: [
          Container(
            width: th.spacing.md,
            height: th.spacing.md,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(th.shapes.radiusXs),
            ),
          ),
          SizedBox(width: th.spacing.sm),
          Column(
            crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
            children: [
              Text(
                label,
                style: th.typography.label.copyWith(
                  color: color,
                  fontWeight: tx.bodyBold.fontWeight,
                ),
              ),
              Text(
                value,
                style: th.typography.body.copyWith(
                  fontWeight: tx.bodyBold.fontWeight,
                  color: th.colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
