import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/time_period.dart';
import '../../constants/drug_categories.dart';
import '../../constants/drug_theme.dart';
import '../../models/log_entry_model.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple;

    // Calculate trend percentage
    final trendPercent = _calculateTrendPercent();

    return Container(
      padding: EdgeInsets.all(ThemeConstants.cardPaddingLarge),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with dropdown
          Row(
            children: [
              Text(
                'Usage Trends',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              const Spacer(),
              // Granularity dropdown
              _buildDropdown(context, isDark, accentColor),
            ],
          ),
          SizedBox(height: ThemeConstants.space12),
          // Trend indicator
          if (trendPercent != null)
            Row(
              children: [
                Icon(
                  trendPercent > 0
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: trendPercent > 0
                      ? UIColors.darkNeonOrange
                      : UIColors.darkNeonEmerald,
                  size: ThemeConstants.iconSmall,
                ),
                SizedBox(width: ThemeConstants.space4),
                Text(
                  '${trendPercent.abs().toStringAsFixed(0)}% ${trendPercent > 0 ? "increase" : "decrease"} this ${_getTrendPeriodLabel()}',
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    fontWeight: ThemeConstants.fontMediumWeight,
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          SizedBox(height: ThemeConstants.space24),
          // Stacked bar chart
          SizedBox(
            height: 220,
            child: _buildBarChart(isDark),
          ),
          SizedBox(height: ThemeConstants.space24),
          // Legend at bottom
          _buildLegend(isDark),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, bool isDark, Color accentColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space12,
        vertical: ThemeConstants.space4,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? UIColors.darkSurfaceLight
            : UIColors.lightBorder.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
          width: ThemeConstants.borderThin,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TrendGranularity>(
          value: _granularity,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            size: ThemeConstants.iconSmall,
          ),
          dropdownColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
          items: const [
            DropdownMenuItem(value: TrendGranularity.daily, child: Text('Daily')),
            DropdownMenuItem(value: TrendGranularity.weekly, child: Text('Weekly')),
            DropdownMenuItem(value: TrendGranularity.monthly, child: Text('Monthly')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _granularity = value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBarChart(bool isDark) {
    final data = _generateTrendData();
    final sortedKeys = _getSortedKeys();

    if (data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            color: isDark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
          ),
        ),
      );
    }

    return BarChart(
      BarChartData(
        barGroups: _buildBarGroups(data),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final label = _getXLabel(value.toInt(), sortedKeys);
                return Padding(
                  padding: EdgeInsets.only(top: ThemeConstants.space4),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
                    ),
                  ),
                );
              },
              interval: 1,
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    color: isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark
                ? UIColors.darkBorder
                : UIColors.lightBorder,
            strokeWidth: 1,
          ),
        ),
        barTouchData: BarTouchData(enabled: true),
      ),
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
      toY: cumulative > 0 ? cumulative : 0.1,
      rodStackItems: stackItems,
      width: 20,
      borderRadius: BorderRadius.circular(ThemeConstants.space4),
    );
  }

  Widget _buildLegend(bool isDark) {
    final data = _generateTrendData();
    final categories = data
        .expand((map) => map.keys)
        .toSet()
        .toList()
      ..sort((a, b) => DrugCategories.categoryPriority.indexOf(a)
          .compareTo(DrugCategories.categoryPriority.indexOf(b)));

    return Wrap(
      spacing: ThemeConstants.space16,
      runSpacing: ThemeConstants.space8,
      children: categories.map((cat) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: DrugCategoryColors.colorFor(cat),
                borderRadius: BorderRadius.circular(ThemeConstants.space4),
              ),
            ),
            SizedBox(width: ThemeConstants.space8),
            Text(
              cat,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight: ThemeConstants.fontMediumWeight,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Map<String, int>> _generateTrendData() {
    final now = DateTime.now();
    Map<DateTime, Map<String, int>> grouped = {};
    List<DateTime> timeUnits = [];

    // Initialize time units based on granularity
    switch (_granularity) {
      case TrendGranularity.daily:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          final key = DateTime(date.year, date.month, date.day);
          timeUnits.add(key);
          grouped[key] = {};
        }
        break;
      case TrendGranularity.weekly:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i * 7));
          final key = DateTime(date.year, date.month, date.day - date.weekday + 1);
          timeUnits.add(key);
          grouped[key] = {};
        }
        break;
      case TrendGranularity.monthly:
        for (int i = 6; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i, 1);
          timeUnits.add(date);
          grouped[date] = {};
        }
        break;
    }

    // Group entries by time and category
    for (final entry in widget.filteredEntries) {
      DateTime key;
      switch (_granularity) {
        case TrendGranularity.monthly:
          key = DateTime(entry.datetime.year, entry.datetime.month, 1);
          break;
        case TrendGranularity.weekly:
          key = DateTime(entry.datetime.year, entry.datetime.month,
              entry.datetime.day - entry.datetime.weekday + 1);
          break;
        case TrendGranularity.daily:
          key = DateTime(entry.datetime.year, entry.datetime.month, entry.datetime.day);
          break;
      }
      if (grouped.containsKey(key)) {
        final category = widget.substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder';
        grouped[key]![category] = (grouped[key]![category] ?? 0) + 1;
      }
    }

    return timeUnits.map((time) => grouped[time]!).toList();
  }

  List<DateTime> _getSortedKeys() {
    final now = DateTime.now();
    List<DateTime> timeUnits = [];

    switch (_granularity) {
      case TrendGranularity.daily:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          timeUnits.add(DateTime(date.year, date.month, date.day));
        }
        break;
      case TrendGranularity.weekly:
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i * 7));
          timeUnits.add(DateTime(date.year, date.month, date.day - date.weekday + 1));
        }
        break;
      case TrendGranularity.monthly:
        for (int i = 6; i >= 0; i--) {
          final date = DateTime(now.year, now.month - i, 1);
          timeUnits.add(date);
        }
        break;
    }
    return timeUnits;
  }

  String _getXLabel(int index, List<DateTime> sortedKeys) {
    if (index >= sortedKeys.length) return '';
    final date = sortedKeys[index];

    switch (_granularity) {
      case TrendGranularity.daily:
        return '${date.day}/${date.month}';
      case TrendGranularity.weekly:
        return 'W${index + 1}';
      case TrendGranularity.monthly:
        return '${date.month}/${date.year % 100}';
    }
  }

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

  double? _calculateTrendPercent() {
    final data = _generateTrendData();
    if (data.length < 2) return null;

    final current = data.last.values.fold<int>(0, (sum, v) => sum + v);
    final previous = data[data.length - 2].values.fold<int>(0, (sum, v) => sum + v);

    if (previous == 0) return null;
    return ((current - previous) / previous) * 100;
  }
}
