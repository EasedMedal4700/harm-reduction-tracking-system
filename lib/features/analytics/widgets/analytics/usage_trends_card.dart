// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSectionHeader. No Riverpod.
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/enums/time_period.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../models/log_entry_model.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';

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
      case TrendGranularity.monthly:
        return 'period';
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    final trendData = _generateTrendData();
    final sortedKeys = _getSortedKeys();
    final trendPercent = _calculateTrendPercent(trendData);

    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              const Expanded(
                child: CommonSectionHeader(title: 'Usage trends'),
              ),
              _buildGranularityDropdown(context),
            ],
          ),
          CommonSpacer.vertical(sp.sm),

          /// TREND LABEL
          if (trendPercent != null) ...[
            Row(
              children: [
                Icon(
                  trendPercent > 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: 16,
                  color: trendPercent > 0
                      ? c.warning
                      : c.success,
                ),
                CommonSpacer.horizontal(sp.xs),
                Text(
                  '${trendPercent.abs().toStringAsFixed(0)}% '
                  '${trendPercent > 0 ? "increase" : "decrease"} '
                  'this ${_getTrendPeriodLabel()}',
                  style: text.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
            CommonSpacer.vertical(sp.md),
          ] else
            CommonSpacer.vertical(sp.md),

          /// BAR CHART
          SizedBox(
            height: 220,
            child: trendData.isEmpty
                ? Center(
                    child: Text(
                      'No data available for this period',
                      style: text.bodySmall.copyWith(color: c.textSecondary),
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
                                padding: EdgeInsets.only(right: sp.xs),
                                child: Text(
                                  value.toInt().toString(),
                                  style: text.caption.copyWith(
                                    color: c.textTertiary,
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
                                padding: EdgeInsets.only(top: sp.xs),
                                child: Text(
                                  label,
                                  style: text.caption.copyWith(
                                    color: c.textTertiary,
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
                          color: c.border.withValues(alpha: 0.5),
                          strokeWidth: 1,
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final total = rod.toY.toInt();
                            final label =
                                _getXLabel(group.x, sortedKeys).isEmpty
                                    ? 'Period ${group.x + 1}'
                                    : _getXLabel(group.x, sortedKeys);

                            return BarTooltipItem(
                              '$label\n',
                              text.bodySmall.copyWith(
                                color: c.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: '$total uses',
                                  style: text.caption.copyWith(
                                    color: c.textSecondary,
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

          SizedBox(height: sp.lg),

          /// LEGEND
          _buildLegend(context, trendData),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Granularity dropdown
  // ---------------------------------------------------------------------------
  Widget _buildGranularityDropdown(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: sp.sm, vertical: sp.xs),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(sp.sm),
        border: Border.all(color: c.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TrendGranularity>(
          value: _granularity,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: c.textSecondary,
          ),
          onChanged: (value) {
            if (value != null) setState(() => _granularity = value);
          },
          items: const [
            DropdownMenuItem(value: TrendGranularity.daily, child: Text('Daily')),
            DropdownMenuItem(value: TrendGranularity.weekly, child: Text('Weekly')),
            DropdownMenuItem(value: TrendGranularity.monthly, child: Text('Monthly')),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Chart building
  // ---------------------------------------------------------------------------
  List<BarChartGroupData> _buildBarGroups(List<Map<String, int>> data) {
    return data.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [_buildBarRod(entry.value)],
      );
    }).toList();
  }

  BarChartRodData _buildBarRod(Map<String, int> categoryCounts) {
    final sortedCats = categoryCounts.keys.toList()
      ..sort((a, b) => DrugCategories.categoryPriority
          .indexOf(a)
          .compareTo(DrugCategories.categoryPriority.indexOf(b)));

    double cumulative = 0;
    final items = <BarChartRodStackItem>[];

    for (final cat in sortedCats) {
      final count = categoryCounts[cat] ?? 0;
      if (count <= 0) continue;

      items.add(
        BarChartRodStackItem(
          cumulative,
          cumulative + count,
          DrugCategoryColors.colorFor(cat),
        ),
      );
      cumulative += count;
    }

    return BarChartRodData(
      toY: cumulative == 0 ? 0.1 : cumulative,
      rodStackItems: items,
      width: 18,
      borderRadius: BorderRadius.circular(4),
    );
  }

  // ---------------------------------------------------------------------------
  // Legend
  // ---------------------------------------------------------------------------
  Widget _buildLegend(BuildContext context, List<Map<String, int>> data) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    final totals = <String, int>{};
    for (final bucket in data) {
      bucket.forEach((cat, count) {
        totals[cat] = (totals[cat] ?? 0) + count;
      });
    }

    if (totals.isEmpty) return const SizedBox.shrink();

    final sum = totals.values.fold<int>(0, (s, v) => s + v);
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category breakdown',
          style: text.bodySmall.copyWith(
            color: c.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: sp.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: Column(
              children: sorted.map((e) {
                final color = DrugCategoryColors.colorFor(e.key);
                final pct = sum == 0
                    ? '0%'
                    : '${((e.value / sum) * 100).round()}%';

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: sp.xs / 2),
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
                      SizedBox(width: sp.sm),
                      Expanded(
                        child: Text(
                          e.key,
                          style: text.bodySmall.copyWith(color: c.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: sp.sm),
                      Text(
                        '$pct · ${e.value}',
                        style: text.caption.copyWith(color: c.textSecondary),
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

  // ---------------------------------------------------------------------------
  // Trend data
  // ---------------------------------------------------------------------------
  List<Map<String, int>> _generateTrendData() {
    final now = DateTime.now();
    final grouped = <DateTime, Map<String, int>>{};
    final units = <DateTime>[];

    switch (_granularity) {
      case TrendGranularity.daily:
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i));
          final key = DateTime(d.year, d.month, d.day);
          units.add(key);
          grouped[key] = {};
        }
        break;

      case TrendGranularity.weekly:
        for (int i = 6; i >= 0; i--) {
          final d = now.subtract(Duration(days: i * 7));
          final monday = d.subtract(Duration(days: d.weekday - 1));
          final key = DateTime(monday.year, monday.month, monday.day);
          units.add(key);
          grouped[key] = {};
        }
        break;

      case TrendGranularity.monthly:
        for (int i = 6; i >= 0; i--) {
          final d = DateTime(now.year, now.month - i, 1);
          units.add(d);
          grouped[d] = {};
        }
        break;
    }

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

      final cat =
          widget.substanceToCategory[entry.substance.toLowerCase()] ?? 'Other';

      grouped[key]![cat] = (grouped[key]![cat] ?? 0) + 1;
    }

    return units.map((d) => grouped[d] ?? {}).toList();
  }

  // ---------------------------------------------------------------------------
  // X labels
  // ---------------------------------------------------------------------------
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

  String _getXLabel(int index, List<DateTime> keys) {
    if (index < 0 || index >= keys.length) return '';
    final d = keys[index];

    switch (_granularity) {
      case TrendGranularity.daily:
        return '${d.day}/${d.month}';
      case TrendGranularity.weekly:
        return 'W${index + 1}';
      case TrendGranularity.monthly:
        return '${d.month}/${d.year % 100}';
    }
  }

  // ---------------------------------------------------------------------------
  // Trend %
  // ---------------------------------------------------------------------------
  double? _calculateTrendPercent(List<Map<String, int>> data) {
    if (data.length < 2) return null;

    int sumAt(int i) =>
        data[i].values.fold<int>(0, (s, v) => s + v);

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

    final lines = 8;
    double step = (maxVal / lines).ceilToDouble();

    if (step <= 1) return 1;
    if (step <= 2) return 2;
    if (step <= 5) return 5;
    if (step <= 10) return 10;
    if (step <= 20) return 20;
    if (step <= 50) return 50;

    return (step / 10).ceil() * 10;
  }
}

