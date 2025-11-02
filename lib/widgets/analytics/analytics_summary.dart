import 'package:flutter/material.dart';

class AnalyticsSummary extends StatelessWidget {
  final int totalEntries;
  final double avgPerWeek;
  final String mostUsedCategory;
  final int mostUsedCount;
  final String selectedPeriodText;
  final String mostUsedSubstance;
  final int mostUsedSubstanceCount;
  final int topCategoryPercent;

  const AnalyticsSummary({
    super.key,
    required this.totalEntries,
    required this.avgPerWeek,
    required this.mostUsedCategory,
    required this.mostUsedCount,
    required this.selectedPeriodText,
    required this.mostUsedSubstance,
    required this.mostUsedSubstanceCount,
    required this.topCategoryPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Summary ($selectedPeriodText)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total Entries: $totalEntries'),
            Text('Average per Week: ${avgPerWeek.toStringAsFixed(1)}'),
            Text('Most Used Substance: $mostUsedSubstance ($mostUsedSubstanceCount)'),
            Text('Main Category: $mostUsedCategory ($topCategoryPercent%)'),
          ],
        ),
      ),
    );
  }
}