// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../models/log_entry_model.dart';

class CategoryPieChart extends StatefulWidget {
  final Map<String, int> categoryCounts;
  final List<LogEntry> filteredEntries;
  final Map<String, String> substanceToCategory;

  const CategoryPieChart({
    super.key,
    required this.categoryCounts,
    required this.filteredEntries,
    required this.substanceToCategory,
  });

  @override
  _CategoryPieChartState createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    final categories = widget.categoryCounts.keys.toList();

    return Column(
      children: [
        // ---- TITLE ----
        Text(
          'Category Distribution',
          style: t.typography.heading3.copyWith(
            color: t.colors.textPrimary,
          ),
        ),

        SizedBox(height: t.spacing.lg),

        // ---- PIE CHART ----
        SizedBox(
          height: 350,
          child: PieChart(
            PieChartData(
              sections: List.generate(categories.length, (index) {
                final category = categories[index];
                final count = widget.categoryCounts[category] ?? 0;

                final screenWidth = MediaQuery.of(context).size.width;
                final baseOpacity = (0.4 + index * 0.1).clamp(0.4, 0.8);

                return PieChartSectionData(
                  value: count.toDouble(),
                  title: '$category\n$count',
                  color: t.accent.primary.withOpacity(baseOpacity),
                  radius: touchedIndex == index
                      ? screenWidth * 0.25
                      : screenWidth * 0.20,
                  titleStyle: t.typography.bodySmall.copyWith(
                    fontSize: touchedIndex == index ? 16 : 12,
                    fontWeight: FontWeight.bold,
                    color: t.colors.textPrimary,
                  ),
                );
              }),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              pieTouchData: PieTouchData(
                enabled: true,
                touchCallback: (event, response) {
                  setState(() {
                    final section = response?.touchedSection;

                    if (section == null) {
                      touchedIndex = -1;
                      selectedCategory = null;
                      return;
                    }

                    touchedIndex = section.touchedSectionIndex;
                    selectedCategory = categories[touchedIndex];
                  });
                },
              ),
            ),
          ),
        ),

        SizedBox(height: t.spacing.lg),

        // ---- LEGEND ----
        Wrap(
          spacing: t.spacing.lg,
          runSpacing: t.spacing.sm,
          children: List.generate(categories.length, (index) {
            final category = categories[index];
            final count = widget.categoryCounts[category] ?? 0;

            final color = t.accent.primary.withOpacity(
              (0.4 + index * 0.1).clamp(0.4, 0.8),
            );

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: t.spacing.sm),
                Text(
                  '$category ($count)',
                  style: t.typography.body.copyWith(
                    color: t.colors.textPrimary,
                  ),
                ),
              ],
            );
          }),
        ),

        // ---- SUBSTANCE BREAKDOWN ----
        if (selectedCategory != null) ...[
          SizedBox(height: t.spacing.lg),

          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => selectedCategory = null),
                icon: Icon(Icons.arrow_back, color: t.colors.textPrimary),
              ),
              Text(
                '$selectedCategory Substances',
                style: t.typography.heading3.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: t.spacing.lg),

          // ---- BAR CHART ----
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: _getSubstanceCounts(selectedCategory!)
                    .entries
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final name = entry.value.key;
                  final count = entry.value.value;

                  final barColor = t.accent.primary.withOpacity(
                    (0.4 + index * 0.15).clamp(0.4, 1.0),
                  );

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: count.toDouble(),
                        color: barColor,
                        width: 18,
                      ),
                    ],
                  );
                }).toList(),

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        final names =
                            _getSubstanceCounts(selectedCategory!).keys.toList();
                        if (value.toInt() >= names.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          names[value.toInt()],
                          style: t.typography.caption.copyWith(
                            color: t.colors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),

                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: t.colors.border),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Build map of substance → count for selected category
  Map<String, int> _getSubstanceCounts(String category) {
    final counts = <String, int>{};

    for (final entry in widget.filteredEntries) {
      final substance = entry.substance;
      final normalized = substance.toLowerCase();

      final cat =
          widget.substanceToCategory[normalized] ?? 'Unknown';

      if (cat == category) {
        counts[substance] = (counts[substance] ?? 0) + 1;
      }
    }

    return counts;
  }
}
