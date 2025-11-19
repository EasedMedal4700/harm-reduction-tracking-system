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
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Key metrics', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildMetricRow('Half-life', '${toleranceModel.halfLifeHours} h'),
            _buildMetricRow('Tolerance decay', '${toleranceModel.toleranceDecayDays} days'),
            _buildMetricRow('Days until baseline', daysUntilBaseline.toStringAsFixed(1)),
            _buildMetricRow('Recent uses (30 d)', recentUseCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
