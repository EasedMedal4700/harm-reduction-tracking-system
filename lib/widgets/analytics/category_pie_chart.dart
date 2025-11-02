import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/drug_theme.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, int> categoryCounts;

  const CategoryPieChart({super.key, required this.categoryCounts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Category Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: categoryCounts.entries.map((e) => PieChartSectionData(
                value: e.value.toDouble(),
                title: '${e.key}\n${e.value}',
                color: DrugCategoryColors.colorFor(e.key),
                radius: 50,
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap( // Custom legend
          spacing: 16.0,
          runSpacing: 8.0,
          children: categoryCounts.entries.map((e) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                color: DrugCategoryColors.colorFor(e.key),
              ),
              const SizedBox(width: 8),
              Text('${e.key} (${e.value})'),
            ],
          )).toList(),
        ),
      ],
    );
  }
}