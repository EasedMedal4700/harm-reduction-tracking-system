import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/emus/time_period.dart';
import '../../models/log_entry_model.dart'; // Add this import for LogEntry
import '../../constants/data/drug_categories.dart';
import '../../constants/deprecated/drug_theme.dart';

class UsageTrendChart extends StatelessWidget {
  final List<LogEntry> filteredEntries;
  final TimePeriod period;
  final Map<String, String> substanceToCategory;

  const UsageTrendChart({
    super.key, 
    required this.filteredEntries, 
    required this.period, 
    required this.substanceToCategory
  });

  @override
  Widget build(BuildContext context) {
    final data = _generateTrendData();
    final title = _getTitle();
    final sortedKeys = _getSortedKeys();

    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: _buildBarGroups(data),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(_getXLabel(value.toInt(), sortedKeys)),
                    interval: period == TimePeriod.all ? 3 : 1,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 40),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 0.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16.0,
          runSpacing: 8.0,
          children: DrugCategories.categoryPriority
              .where((cat) => data.any((map) => map.containsKey(cat)))
              .map((cat) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: DrugCategoryColors.colorFor(cat),
                  ),
                  const SizedBox(width: 8),
                  Text(cat),
                ],
              )).toList(),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<Map<String, int>> data) {
    return data.asMap().entries.map((e) => BarChartGroupData(
      x: e.key,
      barRods: [_buildBarRod(e.value)],
    )).toList();
  }

  BarChartRodData _buildBarRod(Map<String, int> categoryCounts) {
    final sortedCategories = categoryCounts.keys.toList()
      ..sort((a, b) => DrugCategories.categoryPriority.indexOf(a)
          .compareTo(DrugCategories.categoryPriority.indexOf(b)));
    
    double cumulative = 0;
    final stackItems = <BarChartRodStackItem>[];
    
    for (final category in sortedCategories) {
      final count = categoryCounts[category]!;
      if (count > 0) {
        stackItems.add(
          BarChartRodStackItem(
            cumulative,
            cumulative + count,
            DrugCategoryColors.colorFor(category),
          ),
        );
        cumulative += count;
      }
    }
    
    return BarChartRodData(
      toY: cumulative,
      rodStackItems: stackItems,
      width: 16,
      borderRadius: BorderRadius.zero,
    );
  }

  List<Map<String, int>> _generateTrendData() {
    final now = DateTime.now();
    Map<DateTime, Map<String, int>> grouped = {};

    // Initialize time units
    List<DateTime> timeUnits = [];
    switch (period) {
      case TimePeriod.all:
        if (filteredEntries.isEmpty) return [];
        final minDate = filteredEntries.map((e) => e.datetime).reduce((a, b) => a.isBefore(b) ? a : b);
        for (DateTime date = DateTime(minDate.year, minDate.month, 1); date.isBefore(now) || date.isAtSameMomentAs(DateTime(now.year, now.month, 1)); date = DateTime(date.year, date.month + 1, 1)) {
          timeUnits.add(date);
          grouped[date] = {};
        }
        break;
      case TimePeriod.last7Days:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final key = DateTime(date.year, date.month, date.day);
          timeUnits.add(key);
          grouped[key] = {};
        }
        break;
      case TimePeriod.last7Weeks:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i * 7));
          final key = DateTime(date.year, date.month, date.day - date.weekday + 1);
          timeUnits.add(key);
          grouped[key] = {};
        }
        break;
      case TimePeriod.last7Months:
        for (int i = 6; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i, 1);
          timeUnits.add(date);
          grouped[date] = {};
        }
        break;
    }

    // Group entries by time and category
    for (final entry in filteredEntries) {
      DateTime key;
      switch (period) {
        case TimePeriod.all:
        case TimePeriod.last7Months:
          key = DateTime(entry.datetime.year, entry.datetime.month, 1);
          break;
        case TimePeriod.last7Weeks:
          key = DateTime(entry.datetime.year, entry.datetime.month, entry.datetime.day - entry.datetime.weekday + 1);
          break;
        case TimePeriod.last7Days:
          key = DateTime(entry.datetime.year, entry.datetime.month, entry.datetime.day);
          break;
      }
      if (grouped.containsKey(key)) {
        final category = substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder';
        grouped[key]![category] = (grouped[key]![category] ?? 0) + 1;
      }
    }

    return timeUnits.map((time) => grouped[time]!).toList();
  }

  List<DateTime> _getSortedKeys() {
    final now = DateTime.now();
    List<DateTime> timeUnits = [];
    switch (period) {
      case TimePeriod.all:
        if (filteredEntries.isEmpty) return [];
        final minDate = filteredEntries.map((e) => e.datetime).reduce((a, b) => a.isBefore(b) ? a : b);
        for (DateTime date = DateTime(minDate.year, minDate.month, 1); date.isBefore(now) || date.isAtSameMomentAs(DateTime(now.year, now.month, 1)); date = DateTime(date.year, date.month + 1, 1)) {
          timeUnits.add(date);
        }
        break;
      case TimePeriod.last7Days:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          timeUnits.add(DateTime(date.year, date.month, date.day));
        }
        break;
      case TimePeriod.last7Weeks:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i * 7));
          timeUnits.add(DateTime(date.year, date.month, date.day - date.weekday + 1));
        }
        break;
      case TimePeriod.last7Months:
        for (int i = 6; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i, 1);
          timeUnits.add(date);
        }
        break;
    }
    return timeUnits;
  }

  String _getTitle() {
    switch (period) {
      case TimePeriod.all:
        return 'Usage Trend (All Time)';
      case TimePeriod.last7Days:
        return 'Usage Trend (Last 7 Days)';
      case TimePeriod.last7Weeks:
        return 'Usage Trend (Last 7 Weeks)';
      case TimePeriod.last7Months:
        return 'Usage Trend (Last 7 Months)';
    }
  }

  String _getXLabel(int index, List<DateTime> sortedKeys) {
    switch (period) {
      case TimePeriod.all:
        if (index < sortedKeys.length) {
          final date = sortedKeys[index];
          return '${date.month}/${date.year % 100}';
        }
        return '';
      case TimePeriod.last7Days:
        return '${index + 1}';
      case TimePeriod.last7Weeks:
        return 'W${index + 1}';
      case TimePeriod.last7Months:
        return 'M${index + 1}';
    }
  }
}