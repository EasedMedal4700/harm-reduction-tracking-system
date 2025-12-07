import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/deprecated/drug_theme.dart';
import '../../models/log_entry_model.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<String, int> categoryCounts;
  final List<LogEntry> filteredEntries;
  final Map<String, String> substanceToCategory;

  const CategoryPieChart({
    super.key, 
    required this.categoryCounts, 
    required this.filteredEntries, 
    required this.substanceToCategory
  });

  @override
  _CategoryPieChartState createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Category Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 350,
          child: PieChart(
            PieChartData(
              sections: widget.categoryCounts.entries.map((e) {
                final index = widget.categoryCounts.keys.toList().indexOf(e.key);

                final screenWidth = MediaQuery.of(context).size.width;

                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: '${e.key}\n${e.value}',
                  color: DrugCategoryColors.colorFor(e.key),
                  radius: touchedIndex == index
                      ? screenWidth * 0.25
                      : screenWidth * 0.20,
                  titleStyle: TextStyle(
                    fontSize: touchedIndex == index ? 16 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    final section = pieTouchResponse?.touchedSection;

                    if (section == null) {
                      touchedIndex = -1;
                      selectedCategory = null;
                      return;
                    }

                    touchedIndex = section.touchedSectionIndex;
                    selectedCategory =
                        widget.categoryCounts.keys.elementAt(touchedIndex);
                  });
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),
        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          children: widget.categoryCounts.entries.map((e) => Row(
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
        if (selectedCategory != null) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => selectedCategory = null),
                icon: const Icon(Icons.arrow_back),
              ),
              Text('$selectedCategory Substances', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: _getSubstanceCounts(selectedCategory!).entries.toList().asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.value.toDouble(),
                      color: DrugCategoryColors.colorFor(selectedCategory!),
                      width: 20,
                    ),
                  ],
                )).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        _getSubstanceCounts(selectedCategory!).keys.elementAt(value.toInt()),
                        style: const TextStyle(fontSize: 10),
                      ),
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                ),
                borderData: FlBorderData(show: true),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Map<String, int> _getSubstanceCounts(String category) {
    final counts = <String, int>{};
    for (final entry in widget.filteredEntries) {
      final cat = widget.substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder';
      if (cat == category) {
        counts[entry.substance] = (counts[entry.substance] ?? 0) + 1;
      }
    }
    return counts;
  }
}