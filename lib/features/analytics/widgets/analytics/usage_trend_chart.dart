// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Converted to CommonCard layout + cleaned architecture. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../constants/enums/time_period.dart';
import '../../../../models/log_entry_model.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/data/drug_categories.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';

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
    final th = context.theme;
    final trend = _buildTrendData();
    final keys = trend.keys.toList()..sort();
    final values = keys.map((k) => trend[k]!).toList();
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          CommonSectionHeader(title: _title(period)),
          CommonSpacer.vertical(th.spacing.md),
          SizedBox(
            height: context.sizes.heightMd,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: th.colors.border.withValues(
                      alpha: th.opacities.medium,
                    ),
                    strokeWidth: th.borders.thin,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBars(context, values),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, _) => Text(
                        value.toInt().toString(),
                        style: th.typography.caption.copyWith(
                          color: th.colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _interval(period).toDouble(),
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        return Padding(
                          padding: EdgeInsets.only(top: th.spacing.xs),
                          child: Text(
                            _labelForIndex(idx, keys),
                            style: th.typography.captionBold.copyWith(
                              color: th.colors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          CommonSpacer.vertical(th.spacing.xl),

          /// Legend
          Wrap(
            spacing: th.spacing.lg,
            runSpacing: th.spacing.sm,
            children: _uniqueCategories(values).map((cat) {
              return Row(
                mainAxisSize: AppLayout.mainAxisSizeMin,
                children: [
                  Container(
                    width: th.spacing.md,
                    height: th.spacing.md,
                    decoration: BoxDecoration(
                      color: DrugCategoryColors.colorFor(cat),
                      borderRadius: BorderRadius.circular(th.spacing.xs),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    cat,
                    style: th.typography.captionBold.copyWith(
                      color: th.colors.textPrimary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CHART DATA
  // ---------------------------------------------------------------------------
  Map<DateTime, Map<String, int>> _buildTrendData() {
    final now = DateTime.now();
    final buckets = <DateTime, Map<String, int>>{};
    final timeUnits = switch (period) {
      TimePeriod.all => _monthsRange(),
      TimePeriod.last7Days => List.generate(7, (i) {
        final d = now.subtract(Duration(days: 6 - i));
        return DateTime(d.year, d.month, d.day);
      }),
      TimePeriod.last7Weeks => List.generate(7, (i) {
        final base = now.subtract(Duration(days: (6 - i) * 7));
        return DateTime(base.year, base.month, base.day - base.weekday + 1);
      }),
      TimePeriod.last7Months => List.generate(7, (i) {
        final d = DateTime(now.year, now.month - (6 - i), 1);
        return d;
      }),
    };
    for (final t in timeUnits) {
      buckets[t] = {};
    }
    for (final e in filteredEntries) {
      final bucketKey = switch (period) {
        TimePeriod.all || TimePeriod.last7Months => DateTime(
          e.datetime.year,
          e.datetime.month,
          1,
        ),
        TimePeriod.last7Weeks => DateTime(
          e.datetime.year,
          e.datetime.month,
          e.datetime.day - e.datetime.weekday + 1,
        ),
        TimePeriod.last7Days => DateTime(
          e.datetime.year,
          e.datetime.month,
          e.datetime.day,
        ),
      };
      if (!buckets.containsKey(bucketKey)) continue;
      final cat = substanceToCategory[e.substance.toLowerCase()] ?? 'Other';
      buckets[bucketKey]![cat] = (buckets[bucketKey]![cat] ?? 0) + 1;
    }
    return buckets;
  }

  // ---------------------------------------------------------------------------
  // BAR BUILDER
  // ---------------------------------------------------------------------------
  List<BarChartGroupData> _buildBars(
    BuildContext context,
    List<Map<String, int>> data,
  ) {
    final barWidth = context.sizes.iconSm;
    return data.asMap().entries.map((e) {
      final x = e.key;
      final map = e.value;
      double total = 0;
      final stacks = <BarChartRodStackItem>[];
      final sorted = map.keys.toList()..sort();
      for (final cat in sorted) {
        final count = map[cat]!;
        final next = total + count;
        stacks.add(
          BarChartRodStackItem(total, next, DrugCategoryColors.colorFor(cat)),
        );
        total = next;
      }
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: total,
            rodStackItems: stacks,
            width: barWidth,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
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
    for (
      DateTime d = start;
      !d.isAfter(end);
      d = DateTime(d.year, d.month + 1, 1)
    ) {
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
