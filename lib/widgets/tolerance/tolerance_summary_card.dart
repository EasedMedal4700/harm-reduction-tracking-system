import 'package:flutter/material.dart';

/// Card displaying current tolerance percentage and visual indicator
class ToleranceSummaryCard extends StatelessWidget {
  final double currentTolerance;

  const ToleranceSummaryCard({required this.currentTolerance, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final label = _toleranceLabel(currentTolerance);
    final color = _toleranceColor(currentTolerance);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
        ),
      ),
      color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current tolerance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${currentTolerance.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (currentTolerance / 100).clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
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
