import 'package:flutter/material.dart';

/// Card displaying current tolerance percentage and visual indicator
class ToleranceSummaryCard extends StatelessWidget {
  final double currentTolerance;

  const ToleranceSummaryCard({
    required this.currentTolerance,
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
            Text(
              'Current tolerance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${currentTolerance.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (currentTolerance / 100).clamp(0.0, 1.0),
            ),
            const SizedBox(height: 8),
            Text(
              _toleranceLabel(currentTolerance),
              style: Theme.of(context).textTheme.bodyMedium,
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
}
