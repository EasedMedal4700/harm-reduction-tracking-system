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
  final Function(String category)? onCategoryTapped;

  const UseDistributionCard({
    super.key,
    required this.categoryCounts,
    required this.substanceCounts,
    required this.filteredEntries,
    required this.substanceToCategory,
    this.onCategoryTapped,
  });

  @override
  State<UseDistributionCard> createState() => _UseDistributionCardState();
}

class _UseDistributionCardState extends State<UseDistributionCard> {
  DistributionViewType _viewType = DistributionViewType.category;
  int _touchedIndex = -1;
  String? _selectedCategory;

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
                _viewType == DistributionViewType.category && _selectedCategory == null,
                () => setState(() {
                  _viewType = DistributionViewType.category;
                  _selectedCategory = null;
                }),
                isDark,
                accentColor,
              ),
              SizedBox(width: ThemeConstants.space8),
              _buildTab(
                context,
                'Substance',
                _viewType == DistributionViewType.substance,
                () => setState(() {
                  _viewType = DistributionViewType.substance;
                  _selectedCategory = null;
                }),
                isDark,
                accentColor,
              ),
            ],
          ),
          // Breadcrumb for filtered category
          if (_selectedCategory != null) ...[
            SizedBox(height: ThemeConstants.space12),
            InkWell(
              onTap: () => setState(() {
                _selectedCategory = null;
                _viewType = DistributionViewType.category;
              }),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space12,
                  vertical: ThemeConstants.space8,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.1 : 0.05),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: ThemeConstants.borderThin,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: ThemeConstants.iconSmall,
                      color: accentColor,
                    ),
                    SizedBox(width: ThemeConstants.space8),
                    Text(
                      'Substances in $_selectedCategory',
                      style: TextStyle(
                        fontSize: ThemeConstants.fontSmall,
                        fontWeight: ThemeConstants.fontMediumWeight,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        : (_selectedCategory != null
            ? _getSubstancesForCategory(_selectedCategory!)
            : widget.substanceCounts);

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
            if (!event.isInterestedForInteractions ||
                response == null ||
                response.touchedSection == null) {
              setState(() {
                _touchedIndex = -1;
              });
              return;
            }

            final touchedIndex = response.touchedSection!.touchedSectionIndex;
            setState(() {
              _touchedIndex = touchedIndex;
            });

            // Handle tap on category to drill down to substances
            if (_viewType == DistributionViewType.category && 
                event is FlTapUpEvent) {
              final tappedCategory = data.keys.toList()[touchedIndex];
              setState(() {
                _selectedCategory = tappedCategory;
                _viewType = DistributionViewType.substance;
                _touchedIndex = -1;
              });
            }
          },
        ),
      ),
    );
  }

  Map<String, int> _getSubstancesForCategory(String category) {
    final substances = <String, int>{};
    for (final entry in widget.filteredEntries) {
      final substanceCategory = widget.substanceToCategory[entry.substance.toLowerCase()] ?? 'Placeholder';
      if (substanceCategory == category) {
        substances[entry.substance] = (substances[entry.substance] ?? 0) + 1;
      }
    }
    return substances;
  }

  Widget _buildLegend(bool isDark) {
    final data = _viewType == DistributionViewType.category
        ? widget.categoryCounts
        : (_selectedCategory != null
            ? _getSubstancesForCategory(_selectedCategory!)
            : widget.substanceCounts);

    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = data.values.fold<int>(0, (sum, count) => sum + count);
    
    // Sort entries by count (descending - most at top)
    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((e) {
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
