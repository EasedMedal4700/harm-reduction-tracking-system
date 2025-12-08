import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme.dart';
import '../../constants/emus/time_period.dart';
import '../../constants/data/drug_categories.dart';
import '../../models/log_entry_model.dart';
import '../../constants/data/drug_categories.dart';


enum TrendGranularity { daily, weekly, monthly }



class UsageTrendsCard extends StatefulWidget {
  final List<LogEntry> filteredEntries;
  final TimePeriod period;
  final Map<String, String> substanceToCategory;

  const UsageTrendsCard({
    super.key,
    required this.filteredEntries,
    required this.period,
    required this.substanceToCategory,
  });

  @override
  State<UsageTrendsCard> createState() => _UsageTrendsCardState();
}

class _UsageTrendsCardState extends State<UsageTrendsCard> {
  TrendGranularity _granularity = TrendGranularity.daily;

  String _getTrendPeriodLabel() {
  switch (_granularity) {
    case TrendGranularity.daily:
      return 'week';
    case TrendGranularity.weekly:
      return 'period';
    case TrendGranularity.monthly:
      return 'period';
  }
}


  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final accent = t.colors.success;

    final trendData = _generateTrendData();
    final sortedKeys = _getSortedKeys();
    final trendPercent = _calculateTrendPercent(trendData);

    return Container(
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.lg),
        border: Border.all(
          color: accent.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.18),
            blurRadius: 22,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------
          // HEADER
          // ------------------------------------------------------------
          Row(
            children: [
              Text(
                'Usage trends',
                style: t.typography.heading3.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
              const Spacer(),
              _buildGranularityDropdown(t),
            ],
          ),
          SizedBox(height: t.spacing.xs),

          // ------------------------------------------------------------
          // TREND CHANGE LABEL
          // ------------------------------------------------------------
          if (trendPercent != null) ...[
            Row(
              children: [
                Icon(
                  trendPercent > 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 16,
                  color: trendPercent > 0
                      ? Colors.orangeAccent
                      : Colors.tealAccent,
                ),
                SizedBox(width: t.spacing.xs),
                Text(
                  '${trendPercent.abs().toStringAsFixed(0)}% '
                  '${trendPercent > 0 ? "increase" : "decrease"} '
                  'this ${_getTrendPeriodLabel()}',
                  style: t.typography.caption.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: t.spacing.sm),
          ] else
            SizedBox(height: t.spacing.sm),

          // ------------------------------------------------------------
          // BAR CHART
          // ------------------------------------------------------------
          SizedBox(
            height: 220,
            child: trendData.isEmpty
                ? Center(
                    child: Text(
                      'No data available for this period',
                      style: t.typography.bodySmall.copyWith(
                        color: t.colors.textSecondary,
                      ),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      barGroups: _buildBarGroups(trendData),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 34,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: EdgeInsets.only(right: t.spacing.xs),
                                child: Text(
                                  value.toInt().toString(),
                                  style: t.typography.caption.copyWith(
                                    color: t.colors.textTertiary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) {
                              final label =
                                  _getXLabel(value.toInt(), sortedKeys);
                              return Padding(
                                padding: EdgeInsets.only(top: t.spacing.xs),
                                child: Text(
                                  label,
                                  style: t.typography.caption.copyWith(
                                    color: t.colors.textTertiary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval:
                            _calculateGridInterval(trendData).toDouble(),
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: t.colors.border.withOpacity(0.5),
                          strokeWidth: 1,
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final total = rod.toY.toInt();
                            final label = _getXLabel(group.x, sortedKeys).isEmpty
                                ? 'Period ${group.x + 1}'
                                : _getXLabel(group.x, sortedKeys);

                            return BarTooltipItem(
                              '$label\n',
                              t.typography.bodySmall.copyWith(
                                color: t.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: '$total uses',
                                  style: t.typography.caption.copyWith(
                                    color: t.colors.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),

          SizedBox(height: t.spacing.lg),

          // ------------------------------------------------------------
          // LEGEND
          // ------------------------------------------------------------
          _buildLegend(t, trendData),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // GRANULARITY DROPDOWN
  // ------------------------------------------------------------
  Widget _buildGranularityDropdown(AppTheme t) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.sm,
        vertical: t.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: t.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(t.spacing.sm),
        border: Border.all(color: t.colors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TrendGranularity>(
          value: _granularity,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: t.colors.textSecondary,
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() => _granularity = value);
            }
          },
          items: const [
            DropdownMenuItem(
              value: TrendGranularity.daily,
              child: Text('Daily'),
            ),
            DropdownMenuItem(
              value: TrendGranularity.weekly,
              child: Text('Weekly'),
            ),
            DropdownMenuItem(
              value: TrendGranularity.monthly,
              child: Text('Monthly'),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BAR RODS + GROUPS
  // ------------------------------------------------------------
  List<BarChartGroupData> _buildBarGroups(List<Map<String, int>> data) {
    return data.asMap().entries.map((entry) {
      final x = entry.key;
      final counts = entry.value;
      return BarChartGroupData(
        x: x,
        barRods: [_buildBarRod(counts)],
      );
    }).toList();
  }

  BarChartRodData _buildBarRod(Map<String, int> categoryCounts) {
    final sortedCategories = categoryCounts.keys.toList()
      ..sort((a, b) => DrugCategories.categoryPriority
          .indexOf(a)
          .compareTo(DrugCategories.categoryPriority.indexOf(b)));

    double cumulative = 0;
    final stackItems = <BarChartRodStackItem>[];

    for (final category in sortedCategories) {
      final count = categoryCounts[category] ?? 0;
      if (count <= 0) continue;

      stackItems.add(
        BarChartRodStackItem(
          cumulative,
          cumulative + count,
          DrugCategoryColors.colorFor(category),
        ),
      );
      cumulative += count;
    }

    return BarChartRodData(
      toY: cumulative > 0 ? cumulative : 0.1,
      rodStackItems: stackItems,
      width: 18,
      borderRadius: BorderRadius.circular(4),
    );
  }

  // ------------------------------------------------------------
  // LEGEND
  // ------------------------------------------------------------
  Widget _buildLegend(AppTheme t, List<Map<String, int>> data) {
    // sum all categories across buckets
    final totals = <String, int>{};
    for (final bucket in data) {
      bucket.forEach((category, count) {
        if (count <= 0) return;
        totals[category] = (totals[category] ?? 0) + count;
      });
    }

    if (totals.isEmpty) return const SizedBox.shrink();

    final totalSum =
        totals.values.fold<int>(0, (sum, v) => sum + v);

    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category breakdown',
          style: t.typography.bodySmall.copyWith(
            color: t.colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: t.spacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Column(
              children: sorted.map((e) {
                final color = DrugCategoryColors.colorFor(e.key);
                final pct =
                    totalSum == 0 ? '0%' : '${(e.value / totalSum * 100).round()}%';

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: t.spacing.xs / 2),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      SizedBox(width: t.spacing.sm),
                      Expanded(
                        child: Text(
                          e.key,
                          style: t.typography.bodySmall.copyWith(
                            color: t.colors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: t.spacing.sm),
                      Text(
                        '$pct · ${e.value}',
                        style: t.typography.caption.copyWith(
                          color: t.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // TREND DATA GENERATION
  // ------------------------------------------------------------
  List<Map<String, int>> _generateTrendData() {
    final now = DateTime.now();
    final grouped = <DateTime, Map<String, int>>{};
    final timeUnits = <DateTime>[];

    // Create buckets
    switch (_granularity) {
      case TrendGranularity.daily:
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i));
          final key = DateTime(d.year, d.month, d.day);
          grouped[key] = {};
          timeUnits.add(key);
        }
        break;

      case TrendGranularity.weekly:
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i * 7));
          final monday = d.subtract(Duration(days: d.weekday - 1));
          final key = DateTime(monday.year, monday.month, monday.day);
          grouped[key] = {};
          timeUnits.add(key);
        }
        break;

      case TrendGranularity.monthly:
        for (int i = 6; i >= 0; i--) {
          final d = DateTime(now.year, now.month - i, 1);
          grouped[d] = {};
          timeUnits.add(d);
        }
        break;
    }

    // Fill buckets
    for (final entry in widget.filteredEntries) {
      final dt = entry.datetime;
      late DateTime key;

      switch (_granularity) {
        case TrendGranularity.daily:
          key = DateTime(dt.year, dt.month, dt.day);
          break;

        case TrendGranularity.weekly:
          final monday = dt.subtract(Duration(days: dt.weekday - 1));
          key = DateTime(monday.year, monday.month, monday.day);
          break;

        case TrendGranularity.monthly:
          key = DateTime(dt.year, dt.month, 1);
          break;
      }

      if (!grouped.containsKey(key)) continue;

      final map = grouped[key]!;
      final category =
          widget.substanceToCategory[entry.substance.toLowerCase()] ??
              'Other';
      map[category] = (map[category] ?? 0) + 1;
    }

    return timeUnits.map((d) => grouped[d] ?? {}).toList();
  }

  // ------------------------------------------------------------
  // X-AXIS LABELS
  // ------------------------------------------------------------
  List<DateTime> _getSortedKeys() {
    final now = DateTime.now();
    final list = <DateTime>[];

    switch (_granularity) {
      case TrendGranularity.daily:
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i));
          list.add(DateTime(d.year, d.month, d.day));
        }
        break;

      case TrendGranularity.weekly:
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i * 7));
          final mon = d.subtract(Duration(days: d.weekday - 1));
          list.add(DateTime(mon.year, mon.month, mon.day));
        }
        break;

      case TrendGranularity.monthly:
        for (int i = 6; i >= 0; i--) {
          list.add(DateTime(now.year, now.month - i, 1));
        }
        break;
    }

    return list;
  }

  String _getXLabel(int index, List<DateTime> sorted) {
    if (index < 0 || index >= sorted.length) return '';
    final d = sorted[index];

    switch (_granularity) {
      case TrendGranularity.daily:
        return '${d.day}/${d.month}';
      case TrendGranularity.weekly:
        return 'W${index + 1}';
      case TrendGranularity.monthly:
        return '${d.month}/${d.year % 100}';
    }
  }

  // ------------------------------------------------------------
  // TREND % CALCULATION
  // ------------------------------------------------------------
  double? _calculateTrendPercent(List<Map<String, int>> data) {
    if (data.length < 2) return null;

    int sumAt(int i) => data[i].values.fold(0, (s, v) => s + v);

    final prev = sumAt(data.length - 2);
    final curr = sumAt(data.length - 1);

    if (prev == 0) return null;

    return ((curr - prev) / prev) * 100;
  }

  double _calculateGridInterval(List<Map<String, int>> data) {
    if (data.isEmpty) return 1;
    double maxVal = 0;

    for (final bucket in data) {
      final s = bucket.values.fold<double>(0, (sum, v) => sum + v);
      if (s > maxVal) maxVal = s;
    }

    if (maxVal <= 0) return 1;

    final targetLines = 8;
    double step = (maxVal / targetLines).ceilToDouble();

    if (step <= 1) return 1;
    if (step <= 2) return 2;
    if (step <= 5) return 5;
    if (step <= 10) return 10;
    if (step <= 20) return 20;
    if (step <= 50) return 50;

    return (step / 10).ceil() * 10;
  }
}
