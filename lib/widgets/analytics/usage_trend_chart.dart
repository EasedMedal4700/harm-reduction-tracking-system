import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/emus/time_period.dart';
import '../../models/log_entry_model.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme.dart';
import '../../constants/data/drug_categories.dart';


/// Themed usage trend chart (stacked bar chart)
class UsageTrendChart extends StatelessWidget {
  final List<LogEntry> filteredEntries;
  final TimePeriod period;
  final Map<String, String> substanceToCategory;

  const UsageTrendChart({
    super.key,
    required this.filteredEntries,
    required this.period,
    required this.substanceToCategory,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final data = _buildTrendData();
    final timeKeys = data.keys.toList()..sort();
    final mapped = timeKeys.map((k) => data[k]!).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _title(period),
          style: t.typography.heading4.copyWith(
            color: t.colors.textPrimary,
          ),
        ),
        SizedBox(height: t.spacing.md),

        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(
                show: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: t.colors.border.withOpacity(0.3),
                  strokeWidth: 1,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              barGroups: _buildBars(mapped, t),
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, _) => Text(
                      value.toInt().toString(),
                      style: t.typography.captionBold.copyWith(color: t.colors.textSecondary),
                    ),
                  ),
                ),

                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _interval(period).toDouble(),
                    getTitlesWidget: (value, _) => Padding(
                      padding: EdgeInsets.only(top: t.spacing.xs),
                      child: Text(
                        _labelForIndex(value.toInt(), timeKeys),
                        style: t.typography.captionBold.copyWith(color: t.colors.textSecondary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: t.spacing.lg),

        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: _uniqueCategories(mapped).map((cat) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: DrugCategoryColors.colorFor(cat),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 6),
                Text(cat, style: t.typography.captionBold),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  //---------------------------------------------------------------------------
  // DATA TRANSFORM
  //---------------------------------------------------------------------------

  /// Returns map: timeBucket → {category → count}
  Map<DateTime, Map<String, int>> _buildTrendData() {
    final now = DateTime.now();
    final buckets = <DateTime, Map<String, int>>{};

    List<DateTime> timeUnits = switch (period) {
      TimePeriod.all => _monthsRange(),
      TimePeriod.last7Days => List.generate(7, (i) {
          final d = now.subtract(Duration(days: 6 - i));
          return DateTime(d.year, d.month, d.day);
        }),
      TimePeriod.last7Weeks => List.generate(7, (i) {
          final d = now.subtract(Duration(days: (6 - i) * 7));
          return DateTime(d.year, d.month, d.day - d.weekday + 1);
        }),
      TimePeriod.last7Months => List.generate(7, (i) {
          final d = DateTime(now.year, now.month - (6 - i), 1);
          return d;
        }),
    };

    for (final t in timeUnits) {
      buckets[t] = {};
    }

    for (final entry in filteredEntries) {
      final key = switch (period) {
        TimePeriod.all || TimePeriod.last7Months =>
          DateTime(entry.datetime.year, entry.datetime.month, 1),
        TimePeriod.last7Weeks =>
          DateTime(entry.datetime.year, entry.datetime.month,
              entry.datetime.day - entry.datetime.weekday + 1),
        TimePeriod.last7Days =>
          DateTime(entry.datetime.year, entry.datetime.month, entry.datetime.day),
      };

      if (buckets.containsKey(key)) {
        final cat = substanceToCategory[entry.substance.toLowerCase()] ?? 'Other';
        buckets[key]![cat] = (buckets[key]![cat] ?? 0) + 1;
      }
    }

    return buckets;
  }

  //---------------------------------------------------------------------------
  // CHART HELPERS
  //---------------------------------------------------------------------------

  List<BarChartGroupData> _buildBars(
      List<Map<String, int>> data, AppTheme theme) {
    return data.asMap().entries.map((entry) {
      final x = entry.key;
      final categoryCounts = entry.value;

      double cumulative = 0;
      final stacks = <BarChartRodStackItem>[];

      final sortedCats = categoryCounts.keys.toList()..sort();

      for (final cat in sortedCats) {
        final count = categoryCounts[cat]!;
        final next = cumulative + count;

        stacks.add(
          BarChartRodStackItem(
            cumulative,
            next,
            DrugCategoryColors.colorFor(cat),
          ),
        );

        cumulative = next;
      }

      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: cumulative,
            rodStackItems: stacks,
            width: 18,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();
  }

  //---------------------------------------------------------------------------
  // HELPERS
  //---------------------------------------------------------------------------

  List<String> _uniqueCategories(List<Map<String, int>> list) {
    final set = <String>{};
    for (final m in list) {
      set.addAll(m.keys);
    }
    return set.toList()..sort();
  }

  int _interval(TimePeriod p) => p == TimePeriod.all ? 2 : 1;

  List<DateTime> _monthsRange() {
    if (filteredEntries.isEmpty) return [];
    final minDate = filteredEntries
        .map((e) => e.datetime)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final now = DateTime.now();
    final start = DateTime(minDate.year, minDate.month, 1);
    final end = DateTime(now.year, now.month, 1);

    final list = <DateTime>[];
    for (var d = start; !d.isAfter(end); d = DateTime(d.year, d.month + 1, 1)) {
      list.add(d);
    }
    return list;
  }

  String _labelForIndex(int index, List<DateTime> keys) {
    if (index < 0 || index >= keys.length) return '';
    final d = keys[index];

    return switch (period) {
      TimePeriod.all => '${d.month}/${d.year % 100}',
      TimePeriod.last7Days => '${d.day}',
      TimePeriod.last7Weeks => 'W${index + 1}',
      TimePeriod.last7Months => '${d.month}',
    };
  }

  String _title(TimePeriod p) => switch (p) {
        TimePeriod.all => 'Usage Trend (All Time)',
        TimePeriod.last7Days => 'Usage Trend (Last 7 Days)',
        TimePeriod.last7Weeks => 'Usage Trend (Last 7 Weeks)',
        TimePeriod.last7Months => 'Usage Trend (Last 7 Months)',
      };
}
