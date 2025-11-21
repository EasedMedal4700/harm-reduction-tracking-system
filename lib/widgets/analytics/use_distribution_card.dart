import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/drug_theme.dart';
import '../../models/log_entry_model.dart';

enum DistributionViewType { category, substance }

class UseDistributionCard extends StatefulWidget {
  final Map<String, int> categoryCounts;
  final Map<String, int> substanceCounts;
  final List<LogEntry> filteredEntries;
  final Map<String, String> substanceToCategory;

  const UseDistributionCard({
    super.key,
    required this.categoryCounts,
    required this.substanceCounts,
    required this.filteredEntries,
    required this.substanceToCategory,
  });

  @override
  State<UseDistributionCard> createState() => _UseDistributionCardState();
}

class _UseDistributionCardState extends State<UseDistributionCard> {
  DistributionViewType _viewType = DistributionViewType.category;
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

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
          // Header with tabs
          Row(
            children: [
              Text(
                'Use Distribution',
                style: TextStyle(
                  fontSize: ThemeConstants.fontLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              const Spacer(),
              // Tabs
              _buildTab(
                context,
                'Category',
                _viewType == DistributionViewType.category,
                () => setState(() => _viewType = DistributionViewType.category),
                isDark,
                accentColor,
              ),
              SizedBox(width: ThemeConstants.space8),
              _buildTab(
                context,
                'Substance',
                _viewType == DistributionViewType.substance,
                () => setState(() => _viewType = DistributionViewType.substance),
                isDark,
                accentColor,
              ),
            ],
          ),
          SizedBox(height: ThemeConstants.space24),
          // Donut chart
          SizedBox(
            height: 280,
            child: _buildDonutChart(isDark),
          ),
          SizedBox(height: ThemeConstants.space24),
          // Legend
          _buildLegend(isDark),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
    Color accentColor,
  ) {
    return AnimatedContainer(
      duration: ThemeConstants.animationNormal,
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withValues(alpha: isDark ? 0.2 : 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
        border: Border.all(
          color: isSelected
              ? accentColor
              : isDark
                  ? UIColors.darkBorder
                  : UIColors.lightBorder,
          width: ThemeConstants.borderThin,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space16,
              vertical: ThemeConstants.space8,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight: isSelected
                    ? ThemeConstants.fontSemiBold
                    : ThemeConstants.fontMediumWeight,
                color: isSelected
                    ? accentColor
                    : isDark
                        ? UIColors.darkTextSecondary
                        : UIColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDonutChart(bool isDark) {
    final data = _viewType == DistributionViewType.category
        ? widget.categoryCounts
        : widget.substanceCounts;

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

    return PieChart(
      PieChartData(
        sections: data.entries.map((e) {
          final index = data.keys.toList().indexOf(e.key);
          final isTouched = _touchedIndex == index;
          final color = _viewType == DistributionViewType.category
              ? DrugCategoryColors.colorFor(e.key)
              : DrugCategoryColors.colorFor(
                  widget.substanceToCategory[e.key.toLowerCase()] ?? 'Placeholder',
                );

          return PieChartSectionData(
            value: e.value.toDouble(),
            title: isTouched ? '${e.value}' : '',
            color: color,
            radius: isTouched ? 120 : 100,
            titleStyle: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontBold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response == null ||
                  response.touchedSection == null) {
                _touchedIndex = -1;
              } else {
                _touchedIndex = response.touchedSection!.touchedSectionIndex;
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildLegend(bool isDark) {
    final data = _viewType == DistributionViewType.category
        ? widget.categoryCounts
        : widget.substanceCounts;

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = data.values.fold<int>(0, (sum, count) => sum + count);

    return Column(
      children: data.entries.map((e) {
        final color = _viewType == DistributionViewType.category
            ? DrugCategoryColors.colorFor(e.key)
            : DrugCategoryColors.colorFor(
                widget.substanceToCategory[e.key.toLowerCase()] ?? 'Placeholder',
              );
        final percentage = total > 0 ? (e.value / total * 100).toStringAsFixed(1) : '0';

        return Padding(
          padding: EdgeInsets.only(bottom: ThemeConstants.space8),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(ThemeConstants.space4),
                ),
              ),
              SizedBox(width: ThemeConstants.space12),
              // Name
              Expanded(
                child: Text(
                  e.key,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    fontWeight: ThemeConstants.fontMediumWeight,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
              ),
              // Count and percentage
              Text(
                '$percentage% (${e.value})',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark
                      ? UIColors.darkTextSecondary
                      : UIColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
