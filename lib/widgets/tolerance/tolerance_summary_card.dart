import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';

/// Card displaying current tolerance percentage and visual indicator
class ToleranceSummaryCard extends StatelessWidget {
  final double currentTolerance;

  const ToleranceSummaryCard({required this.currentTolerance, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = _toleranceLabel(currentTolerance);
    final color = _toleranceColor(currentTolerance);

    final backgroundColor = isDark ? UIColors.darkSurface : Colors.white;
    final borderColor = isDark
        ? UIColors.darkBorder
        : Colors.black.withOpacity(0.05);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusExtraLarge),
        side: BorderSide(color: borderColor),
      ),
      color: backgroundColor,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.cardPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current tolerance',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontSemiBold,
                color: isDark
                    ? UIColors.darkTextSecondary
                    : UIColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: ThemeConstants.space12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${currentTolerance.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: ThemeConstants.font4XLarge,
                    fontWeight: ThemeConstants.fontExtraBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                    height: 1.0,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.space24),

            // Thicker, rounded progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              child: LinearProgressIndicator(
                value: (currentTolerance / 100).clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: ThemeConstants.space12),

            // Status label below bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontBold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _toleranceLabel(double tolerance) {
    if (tolerance < 10) return 'Baseline';
    if (tolerance < 30) return 'Low';
    if (tolerance < 50) return 'Moderate';
    if (tolerance < 70) return 'High';
    return 'Very high';
  }

  Color _toleranceColor(double tolerance) {
    if (tolerance < 10) return Colors.green;
    if (tolerance < 30) return Colors.blue;
    if (tolerance < 50) return Colors.orange;
    if (tolerance < 70) return Colors.deepOrange;
    return Colors.red;
  }
}
