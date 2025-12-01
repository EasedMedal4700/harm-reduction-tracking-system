import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/drug_theme.dart';
import '../../models/log_entry_model.dart';
import 'dart:developer' as developer;

enum DistributionViewType { category, substance }

/// Debug mode flag for chart diagnostics
const bool _kDebugChartMode = true;

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
  bool _chartReady = false;
  String? _chartError;

  @override
  void initState() {
    super.initState();
    // Delay chart rendering to ensure layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _chartReady = true;
        });
        if (_kDebugChartMode) {
          developer.log('Chart ready after first frame', name: 'UseDistributionCard');
        }
      }
    });
  }

  void _logDebug(String message) {
    if (_kDebugChartMode) {
      developer.log(message, name: 'UseDistributionCard');
    }
  }

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
          // Donut chart with responsive sizing - wrapped in error boundary
          _buildChartWithErrorHandling(isDark),
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

  /// Builds the chart with error handling and loading state
  Widget _buildChartWithErrorHandling(bool isDark) {
    // Show loading placeholder until first frame completes
    if (!_chartReady) {
      _logDebug('Chart not ready yet, showing placeholder');
      return SizedBox(
        height: 280,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
          ),
        ),
      );
    }

    // Show error state if chart failed
    if (_chartError != null) {
      _logDebug('Chart error: $_chartError');
      return Container(
        height: 280,
        padding: EdgeInsets.all(ThemeConstants.space16),
        decoration: BoxDecoration(
          color: (isDark ? Colors.red : Colors.red.shade50).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: ThemeConstants.space8),
            Text(
              'Chart Error',
              style: TextStyle(
                fontSize: ThemeConstants.fontLarge,
                fontWeight: ThemeConstants.fontBold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: ThemeConstants.space4),
            Text(
              _chartError!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
            SizedBox(height: ThemeConstants.space12),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _chartError = null;
                  _chartReady = false;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _chartReady = true);
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Build actual chart with error catching
    return LayoutBuilder(
      builder: (context, constraints) {
        _logDebug('Chart LayoutBuilder: maxWidth=${constraints.maxWidth}, maxHeight=${constraints.maxHeight}');
        
        // Ensure we have valid constraints
        if (constraints.maxWidth <= 0 || !constraints.maxWidth.isFinite) {
          _logDebug('Invalid width constraints: ${constraints.maxWidth}');
          return SizedBox(
            height: 280,
            child: Center(
              child: Text(
                'Invalid layout constraints',
                style: TextStyle(color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
              ),
            ),
          );
        }

        final chartSize = constraints.maxWidth > 400 ? 330.0 : constraints.maxWidth * 0.85;
        final height = chartSize.clamp(260.0, 330.0);
        
        return RepaintBoundary(
          child: SizedBox(
            height: height,
            width: constraints.maxWidth,
            child: Center(
              child: _buildDonutChartSafe(isDark, constraints.maxWidth),
            ),
          ),
        );
      },
    );
  }

  /// Safe wrapper for donut chart that catches errors
  Widget _buildDonutChartSafe(bool isDark, double screenWidth) {
    try {
      return _buildDonutChart(isDark, screenWidth);
    } catch (e, stack) {
      _logDebug('Chart build error: $e');
      developer.log('Chart build error', name: 'UseDistributionCard', error: e, stackTrace: stack);
      
      // Schedule error state update after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _chartError = e.toString();
          });
        }
      });
      
      return Center(
        child: Text(
          'Error building chart',
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  Widget _buildDonutChart(bool isDark, double screenWidth) {
    _logDebug('Building donut chart: viewType=$_viewType, selectedCategory=$_selectedCategory');
    
    final data = _viewType == DistributionViewType.category
        ? widget.categoryCounts
        : (_selectedCategory != null
            ? _getSubstancesForCategory(_selectedCategory!)
            : widget.substanceCounts);

    _logDebug('Chart data: ${data.length} entries, keys=${data.keys.join(", ")}');

    if (data.isEmpty) {
      _logDebug('No data available for chart');
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
    
    _logDebug('Chart radii: touched=$touchedRadius, normal=$normalRadius');

    // Build sections list first to validate
    final sections = <PieChartSectionData>[];
    final dataList = data.entries.toList();
    
    for (int index = 0; index < dataList.length; index++) {
      final e = dataList[index];
      final isTouched = _touchedIndex == index;
      final color = _viewType == DistributionViewType.category
          ? DrugCategoryColors.colorFor(e.key)
          : _getUniqueColorForSubstance(e.key, index, data.length);

      sections.add(PieChartSectionData(
        value: e.value.toDouble(),
        title: '',
        color: color,
        radius: isTouched ? touchedRadius : normalRadius,
        titleStyle: const TextStyle(fontSize: 0),
        // Remove badgeWidget to prevent hit-test issues with Text
        showTitle: false,
      ));
    }

    _logDebug('Built ${sections.length} chart sections');

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 50,
        pieTouchData: PieTouchData(
          enabled: true,
          touchCallback: (event, response) {
            _handleChartTouch(event, response, data);
          },
        ),
      ),
    );
  }

  /// Handle chart touch events safely
  void _handleChartTouch(FlTouchEvent event, PieTouchResponse? response, Map<String, int> data) {
    try {
      final section = response?.touchedSection;
      
      if (section == null) {
        if (_touchedIndex != -1) {
          setState(() {
            _touchedIndex = -1;
          });
        }
        return;
      }

      final touchedIndex = section.touchedSectionIndex;
      
      // Validate index is within bounds
      if (touchedIndex < 0 || touchedIndex >= data.length) {
        _logDebug('Invalid touch index: $touchedIndex (data length: ${data.length})');
        if (_touchedIndex != -1) {
          setState(() {
            _touchedIndex = -1;
          });
        }
        return;
      }
      
      // Only update state if index actually changed
      if (_touchedIndex != touchedIndex) {
        setState(() {
          _touchedIndex = touchedIndex;
        });
      }

      // Handle tap (not hover) on category to drill down to substances
      if (event is FlTapUpEvent && _viewType == DistributionViewType.category) {
        final tappedCategory = data.keys.toList()[touchedIndex];
        _logDebug('Category tapped: $tappedCategory');
        setState(() {
          _selectedCategory = tappedCategory;
          _viewType = DistributionViewType.substance;
          _touchedIndex = -1;
        });
      }
    } catch (e, stack) {
      _logDebug('Touch handler error: $e');
      developer.log('Touch handler error', name: 'UseDistributionCard', error: e, stackTrace: stack);
    }
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
