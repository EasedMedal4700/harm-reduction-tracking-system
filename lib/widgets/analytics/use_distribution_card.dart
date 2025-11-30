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
                'Distribution',
                style: TextStyle(
                  fontSize: ThemeConstants.fontXLarge,
                  fontWeight: ThemeConstants.fontBold,
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
                      size: ThemeConstants.iconMedium,
                      color: accentColor,
                    ),
                    SizedBox(width: ThemeConstants.space8),
                    Text(
                      'Substances in $_selectedCategory',
                      style: TextStyle(
                        fontSize: ThemeConstants.fontMedium,
                        fontWeight: ThemeConstants.fontSemiBold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: _selectedCategory != null ? ThemeConstants.space16 : ThemeConstants.space24),
          // Donut chart with responsive sizing
          LayoutBuilder(
            builder: (context, constraints) {
              // Adjust chart size based on available width
              final chartSize = constraints.maxWidth > 400 ? 330.0 : constraints.maxWidth * 0.85;
              return SizedBox(
                height: chartSize.clamp(260.0, 330.0),
                child: Center(
                  child: _buildDonutChart(isDark, constraints.maxWidth),
                ),
              );
            },
          ),
          SizedBox(height: ThemeConstants.space16),
          // Legend with responsive sizing
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
                fontSize: ThemeConstants.fontMedium,
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

  Widget _buildDonutChart(bool isDark, double screenWidth) {
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

    // Calculate responsive radius based on screen width
    final touchedRadius = (screenWidth * 0.20).clamp(65.0, 100.0);
    final normalRadius = (screenWidth * 0.17).clamp(55.0, 85.0);

    return PieChart(
      PieChartData(
        sections: data.entries.map((e) {
          final index = data.keys.toList().indexOf(e.key);
          final isTouched = _touchedIndex == index;
          final color = _viewType == DistributionViewType.category
              ? DrugCategoryColors.colorFor(e.key)
              : _getUniqueColorForSubstance(e.key, index, data.length);

          return PieChartSectionData(
            value: e.value.toDouble(),
            title: '',
            color: color,
            radius: isTouched ? touchedRadius : normalRadius,
            titleStyle: const TextStyle(fontSize: 0),
            badgeWidget: Text(
              '${e.value}',
              style: TextStyle(
                fontSize: isTouched ? 14 : 13,
                fontWeight: FontWeight.bold,
                color: color,
                shadows: [
                  Shadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.8),
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            badgePositionPercentageOffset: 1.3,
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (event, response) {
            final section = response?.touchedSection;
            
            if (section == null) {
              setState(() {
                _touchedIndex = -1;
              });
              return;
            }

            final touchedIndex = section.touchedSectionIndex;
            
            setState(() {
              _touchedIndex = touchedIndex;
            });

            // Handle touch on category to drill down to substances
            if (_viewType == DistributionViewType.category) {
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

  /// Generates a unique color for each substance by creating a gradient within the category color
  Color _getUniqueColorForSubstance(String substance, int index, int totalSubstances) {
    final category = widget.substanceToCategory[substance.toLowerCase()] ?? 'Placeholder';
    final baseColor = DrugCategoryColors.colorFor(category);
    
    if (totalSubstances == 1) {
      return baseColor;
    }
    
    // Create gradient from lighter to darker within the base color
    // Use HSL to create smooth gradients
    final hslColor = HSLColor.fromColor(baseColor);
    
    // Vary lightness and saturation to create distinct shades
    // Range: from 20% lighter to 20% darker
    final lightnessOffset = (index / (totalSubstances - 1) * 0.4) - 0.2;
    final saturationOffset = (index / (totalSubstances - 1) * 0.2) - 0.1;
    
    final newLightness = (hslColor.lightness + lightnessOffset).clamp(0.3, 0.8);
    final newSaturation = (hslColor.saturation + saturationOffset).clamp(0.5, 1.0);
    
    return hslColor.withLightness(newLightness).withSaturation(newSaturation).toColor();
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust max height based on available width
        final maxHeight = constraints.maxWidth > 400 ? 300.0 : 250.0;
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: SingleChildScrollView(
            child: Column(
              children: sortedEntries.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            final color = _viewType == DistributionViewType.category
                ? DrugCategoryColors.colorFor(e.key)
                : _getUniqueColorForSubstance(e.key, index, sortedEntries.length);
            final percentage = total > 0 ? (e.value / total * 100).toStringAsFixed(1) : '0';

            return Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  // Color indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(width: ThemeConstants.space8),
                  // Name
                  Expanded(
                    child: Text(
                      e.key,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: ThemeConstants.fontMediumWeight,
                        color: isDark ? UIColors.darkText : UIColors.lightText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: ThemeConstants.space4),
                  // Count and percentage
                  Text(
                    '$percentage% (${e.value})',
                    style: TextStyle(
                      fontSize: 12,
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
            ),
          ),
        );
      },
    );
  }
}
