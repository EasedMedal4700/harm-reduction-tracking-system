import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Widget for displaying timing information (onset, duration, after-effects)
class TimingInfoCard extends StatelessWidget {
  final String? onset;
  final String? duration;
  final String? afterEffects;
  final bool isDark;
  final Color accentColor;

  const TimingInfoCard({
    super.key,
    required this.onset,
    required this.duration,
    required this.afterEffects,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (onset == null && duration == null && afterEffects == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, color: accentColor),
              const SizedBox(width: 8),
              Text(
                'Timing Information',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

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
          const SizedBox(height: 24),

          // Legend
          if (onset != null) _buildTimeLegend('Onset', onset!, Colors.green),
          if (duration != null)
            _buildTimeLegend('Duration', duration!, Colors.blue),
          if (afterEffects != null)
            _buildTimeLegend('After Effects', afterEffects!, Colors.orange),
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

  Widget _buildTimeLegend(String label, String value, Color color) {
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
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
