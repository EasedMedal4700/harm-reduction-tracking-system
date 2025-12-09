import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme.dart';

/// Card displaying current tolerance percentage & color indicator
class ToleranceSummaryCard extends StatelessWidget {
  final double currentTolerance;

  const ToleranceSummaryCard({
    required this.currentTolerance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    final label = _toleranceLabel(currentTolerance);
    final color = _toleranceColor(currentTolerance, t);

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        border: Border.all(color: t.colors.border),
        boxShadow: t.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.xl),
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current tolerance',
            style: t.typography.bodySmall.copyWith(
              color: t.colors.textSecondary,
            ),
          ),

          SizedBox(height: t.spacing.md),

          // Big % number
          Text(
            '${currentTolerance.toStringAsFixed(1)}%',
            style: t.typography.heading1.copyWith(
              color: t.colors.textPrimary,
              height: 1.0,
              letterSpacing: -1.0,
            ),
          ),

          SizedBox(height: t.spacing.xl),

          // Thick rounded progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(t.shapes.radiusSm),
            child: LinearProgressIndicator(
              value: (currentTolerance / 100).clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: t.colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),

          SizedBox(height: t.spacing.md),

          // Status label chip
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.sm,
              vertical: t.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(t.shapes.radiusSm),
            ),
            child: Text(
              label,
              style: t.typography.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LABEL LOGIC
  // ---------------------------------------------------------------------------

  String _toleranceLabel(double tolerance) {
    if (tolerance < 10) return 'Baseline';
    if (tolerance < 30) return 'Low';
    if (tolerance < 50) return 'Moderate';
    if (tolerance < 70) return 'High';
    return 'Very high';
  }

  // ---------------------------------------------------------------------------
  // THEMED COLOR LOGIC
  // ---------------------------------------------------------------------------

  Color _toleranceColor(double tolerance, AppTheme t) {
    if (tolerance < 10) return t.colors.success;
    if (tolerance < 30) return t.colors.info;
    if (tolerance < 50) return t.colors.warning;
    if (tolerance < 70) return Colors.deepOrange;
    return t.colors.error;
  }
}
