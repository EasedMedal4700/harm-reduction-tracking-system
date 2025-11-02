import 'package:flutter/material.dart';

class AnalyticsSummary extends StatelessWidget {
  final int totalEntries;
  final double avgPerWeek;
  final String mostUsedSubstance;
  final int mostUsedCount;
  final String selectedPeriodText;

  const AnalyticsSummary({
    super.key,
    required this.totalEntries,
    required this.avgPerWeek,
    required this.mostUsedSubstance,
    required this.mostUsedCount,
    required this.selectedPeriodText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Selected Period: $selectedPeriodText'),
        const SizedBox(height: 16),
        Text('Total Entries: $totalEntries'),
        Text('Average per Week: ${avgPerWeek.toStringAsFixed(2)}'),
        Text('Most Used Substance: $mostUsedSubstance ($mostUsedCount times)'),
      ],
    );
  }
}