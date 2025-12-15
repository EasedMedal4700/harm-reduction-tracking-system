import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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

    return Container(
      padding: EdgeInsets.all(t.spacing.md),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.radiusMd),
        border: Border.all(
          color: t.colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: accentColor),
              SizedBox(width: t.spacing.xs),
              Text(
                'Timing Information',
                style: t.typography.heading3.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: t.spacing.lg),

          // Timeline Visualization
          SizedBox(
            height: 40,
            child: Row(
              children: [
                if (onset != null)
                  Expanded(
                    flex: 1,
                    child: _buildTimeBar(
                      Colors.green,
                      true,
                      duration == null && afterEffects == null,
                    ),
                  ),
                if (duration != null)
                  Expanded(
                    flex: 3,
                    child: _buildTimeBar(
                      Colors.blue,
                      onset == null,
                      afterEffects == null,
                    ),
                  ),
                if (afterEffects != null)
                  Expanded(
                    flex: 2,
                    child: _buildTimeBar(
                      Colors.orange,
                      onset == null && duration == null,
                      true,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: t.spacing.lg),

          // Legend
          if (onset != null) _buildTimeLegend(context, 'Onset', onset!, Colors.green),
          if (duration != null)
            _buildTimeLegend(context, 'Duration', duration!, Colors.blue),
          if (afterEffects != null)
            _buildTimeLegend(context, 'After Effects', afterEffects!, Colors.orange),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
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
                  fontWeight: FontWeight.w600,
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
