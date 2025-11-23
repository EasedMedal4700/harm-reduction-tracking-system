import 'package:flutter/material.dart';
import '../../models/tolerance_model.dart';

/// Card displaying key tolerance metrics and statistics
class ToleranceStatsCard extends StatelessWidget {
  final ToleranceModel toleranceModel;
  final double daysUntilBaseline;
  final int recentUseCount;

  const ToleranceStatsCard({
    required this.toleranceModel,
    required this.daysUntilBaseline,
    required this.recentUseCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              'Key metrics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildMetricRow(
              context,
              'Half-life',
              '${toleranceModel.halfLifeHours} h',
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildMetricRow(
              context,
              'Tolerance decay',
              '${toleranceModel.toleranceDecayDays} days',
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildMetricRow(
              context,
              'Days until baseline',
              daysUntilBaseline.toStringAsFixed(1),
            ),
            const Divider(height: 24, thickness: 0.5),
            _buildMetricRow(
              context,
              'Recent uses (30 d)',
              recentUseCount.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
