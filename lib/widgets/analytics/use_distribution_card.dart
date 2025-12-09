// MIGRATION
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../constants/theme/app_theme_extension.dart';
import '../../constants/data/drug_categories.dart';
import '../../models/log_entry_model.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/theme/app_theme.dart';
import '../../constants/data/drug_categories.dart';







enum DistributionViewType { category, substance }

class UseDistributionCard extends StatefulWidget {
  final Map<String, int> categoryCounts;
  final Map<String, int> substanceCounts;
  final List<LogEntry> filteredEntries;
  final Map<String, String> substanceToCategory;
  final void Function(String category)? onCategoryTapped;

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
    final t = context.theme;

    final data = _activeData;
    final total = data.values.fold<int>(0, (sum, v) => sum + v);
    final hasData = total > 0;

    return Container(
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
        border: Border.all(
          color: t.colors.border.withOpacity(0.25),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: t.colors.border.withOpacity(0.18),
            blurRadius: 18,
            spreadRadius: -6,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(t),
          if (_selectedCategory != null) ...[
            SizedBox(height: t.spacing.sm),
            _CategoryBreadcrumb(
              category: _selectedCategory!,
              onClear: () {
                setState(() {
                  _selectedCategory = null;
                  _viewType = DistributionViewType.category;
                  _touchedIndex = -1;
                });
              },
            ),
          ],
          SizedBox(height: t.spacing.lg),
          if (!hasData)
            _EmptyChartPlaceholder()
          else
            _buildChartSection(t, data, total),
          SizedBox(height: t.spacing.lg),
          _buildLegend(t, data, total),
        ],
      ),
    );
  }

  // HEADER + TOGGLE -----------------------------------------------------------

  Widget _buildHeader(AppTheme t) {
    final isCategory =
        _viewType == DistributionViewType.category && _selectedCategory == null;
    final isSubstance = _viewType == DistributionViewType.substance;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Use distribution',
                style: t.typography.heading4.copyWith(
                  color: t.colors.textPrimary,
                ),
              ),
              SizedBox(height: t.spacing.xs),
              Text(
                _selectedCategory == null
                    ? 'Overview of usage across categories and substances.'
                    : 'Substances within ${_selectedCategory!}.',
                style: t.typography.bodySmall.copyWith(
                  color: t.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _ViewToggle(
          activeType: _viewType,
          isDrilledDown: _selectedCategory != null,
          onCategory: () {
            setState(() {
              _viewType = DistributionViewType.category;
              _selectedCategory = null;
              _touchedIndex = -1;
            });
          },
          onSubstance: () {
            setState(() {
              _viewType = DistributionViewType.substance;
              _selectedCategory = null;
              _touchedIndex = -1;
            });
          },
          isCategory: isCategory,
          isSubstance: isSubstance,
        ),
      ],
    );
  }

  // CHART ---------------------------------------------------------------------

  Widget _buildChartSection(
    AppTheme t,
    Map<String, int> data,
    int total,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final radiusBase = (width * 0.22).clamp(70.0, 110.0);
        final innerRadius = radiusBase * 0.5;

        return SizedBox(
          height: radiusBase * 2.1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: innerRadius,
                  sections: _buildSections(data, radiusBase),
                  pieTouchData: PieTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      if (!event.isInterestedForInteractions ||
                          response?.touchedSection == null) {
                        setState(() => _touchedIndex = -1);
                        return;
                      }

                      final index =
                          response!.touchedSection!.touchedSectionIndex;
                      final keys = data.keys.toList();

                      if (index < 0 || index >= keys.length) return;

                      setState(() => _touchedIndex = index);

                      // Drill-down tap on category slices
                      if (event is FlTapUpEvent &&
                          _viewType == DistributionViewType.category) {
                        final category = keys[index];
                        setState(() {
                          _selectedCategory = category;
                          _viewType = DistributionViewType.substance;
                          _touchedIndex = -1;
                        });
                        widget.onCategoryTapped?.call(category);
                      }
                    },
                  ),
                ),
              ),
              _ChartCenterLabel(
                total: total,
                mode: _viewType,
                category: _selectedCategory,
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(
    Map<String, int> data,
    double radiusBase,
  ) {
    final entries = data.entries.toList();
    final total = data.values.fold<int>(0, (sum, v) => sum + v);

    if (total == 0) return [];

    return List.generate(entries.length, (index) {
      final e = entries[index];
      final isTouched = _touchedIndex == index;

      final baseColor = _viewType == DistributionViewType.category
          ? DrugCategoryColors.colorFor(e.key)
          : _colorForSubstance(e.key, index, entries.length);

      final color = baseColor.withOpacity(isTouched ? 1.0 : 0.85);
      final radius = isTouched ? radiusBase * 1.08 : radiusBase;

      // Hide micro-slices visually but keep them clickable
      final slicePercent = e.value / total;
      final showLabel = slicePercent > 0.08;

      return PieChartSectionData(
        value: e.value.toDouble(),
        color: color,
        radius: radius,
        title: showLabel ? '${(slicePercent * 100).round()}%' : '',
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    });
  }

  // LEGEND --------------------------------------------------------------------

  Widget _buildLegend(AppTheme t, Map<String, int> data, int total) {
    final sorted = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Breakdown',
          style: t.typography.captionBold.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
        SizedBox(height: t.spacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 220),
          child: SingleChildScrollView(
            child: Column(
              children: sorted.map((e) {
                final index = sorted.indexOf(e);
                final baseColor = _viewType == DistributionViewType.category
                    ? DrugCategoryColors.colorFor(e.key)
                    : _colorForSubstance(e.key, index, sorted.length);

                final pct =
                    total == 0 ? '0%' : '${(e.value / total * 100).round()}%';

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: baseColor,
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

  // DATA HELPERS --------------------------------------------------------------

  Map<String, int> get _activeData {
    if (_viewType == DistributionViewType.category) {
      return widget.categoryCounts;
    }

    if (_selectedCategory != null) {
      return _substanceCountsForCategory(_selectedCategory!);
    }

    return widget.substanceCounts;
  }

  Map<String, int> _substanceCountsForCategory(String category) {
    final result = <String, int>{};
    for (final entry in widget.filteredEntries) {
      final cat =
          widget.substanceToCategory[entry.substance.toLowerCase()] ??
              'Other';
      if (cat == category) {
        result[entry.substance] = (result[entry.substance] ?? 0) + 1;
      }
    }
    return result;
  }

  Color _colorForSubstance(String substance, int index, int total) {
    final category =
        widget.substanceToCategory[substance.toLowerCase()] ?? 'Other';
    final base = DrugCategoryColors.colorFor(category);

    if (total <= 1) return base;

    // Simple HSL-based neon-ish gradient variations per substance
    final hsl = HSLColor.fromColor(base);
    final ratio = total <= 1 ? 0.5 : index / (total - 1);

    final lightness = (hsl.lightness + (ratio - 0.5) * 0.35).clamp(0.25, 0.8);
    final sat = (hsl.saturation + (ratio - 0.5) * 0.25).clamp(0.5, 1.0);

    return hsl.withLightness(lightness).withSaturation(sat).toColor();
  }
}

// SUBWIDGETS ------------------------------------------------------------------

class _ViewToggle extends StatelessWidget {
  final DistributionViewType activeType;
  final bool isDrilledDown;
  final VoidCallback onCategory;
  final VoidCallback onSubstance;
  final bool isCategory;
  final bool isSubstance;

  const _ViewToggle({
    required this.activeType,
    required this.isDrilledDown,
    required this.onCategory,
    required this.onSubstance,
    required this.isCategory,
    required this.isSubstance,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final bg = t.colors.surface.withOpacity(0.7);
    final border = t.colors.border.withOpacity(0.25);

    return Container(
      padding: EdgeInsets.all(t.spacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pill(
            context,
            label: 'Category',
            selected: isCategory,
            onTap: onCategory,
          ),
          _pill(
            context,
            label: 'Substance',
            selected: isSubstance,
            onTap: onSubstance,
          ),
        ],
      ),
    );
  }

  Widget _pill(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final t = context.theme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.sm,
        vertical: t.spacing.xs,
      ),
      decoration: BoxDecoration(
        color: selected
            ? t.accent.primary.withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
        onTap: onTap,
        child: Text(
          label,
          style: t.typography.caption.copyWith(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? t.accent.primary : t.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _CategoryBreadcrumb extends StatelessWidget {
  final String category;
  final VoidCallback onClear;

  const _CategoryBreadcrumb({
    required this.category,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return InkWell(
      onTap: onClear,
      borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: t.spacing.sm,
          vertical: t.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: t.accent.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppThemeConstants.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: t.accent.primary,
            ),
            SizedBox(width: t.spacing.xs),
            Text(
              'Substances in $category',
              style: t.typography.caption.copyWith(
                color: t.accent.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCenterLabel extends StatelessWidget {
  final int total;
  final DistributionViewType mode;
  final String? category;

  const _ChartCenterLabel({
    required this.total,
    required this.mode,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    final label = switch (mode) {
      DistributionViewType.category => 'categories',
      DistributionViewType.substance => category ?? 'substances',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          total.toString(),
          style: t.typography.heading4.copyWith(
            color: t.colors.textPrimary,
          ),
        ),
        SizedBox(height: t.spacing.xs),
        Text(
          label,
          style: t.typography.caption.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _EmptyChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return SizedBox(
      height: 180,
      child: Center(
        child: Text(
          'No data to visualize yet.\nLog a few entries to see distribution.',
          textAlign: TextAlign.center,
          style: t.typography.bodySmall.copyWith(
            color: t.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
