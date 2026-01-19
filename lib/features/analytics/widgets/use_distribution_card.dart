// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Presentation-only; receives precomputed counts from providers.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../constants/data/drug_categories.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/text/common_section_header.dart';
import '../../../common/layout/common_spacer.dart';

enum DistributionViewType { category, substance }

class UseDistributionCard extends StatefulWidget {
  final Map<String, int> categoryCounts;
  final Map<String, int> substanceCounts;
  final Map<String, Map<String, int>> substanceCountsByCategory;
  const UseDistributionCard({
    super.key,
    required this.categoryCounts,
    required this.substanceCounts,
    required this.substanceCountsByCategory,
  });
  @override
  State<UseDistributionCard> createState() => _UseDistributionCardState();
}

class _UseDistributionCardState extends State<UseDistributionCard> {
  DistributionViewType _viewType = DistributionViewType.category;
  int _touchedIndex = -1;
  String? _selectedCategory;

  List<MapEntry<String, int>> _orderedEntries(Map<String, int> data) {
    final entries = data.entries.toList(growable: false);
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final data = _viewType == DistributionViewType.category
        ? widget.categoryCounts
        : (_selectedCategory == null
              ? widget.substanceCounts
              : (widget.substanceCountsByCategory[_selectedCategory!] ??
                    const <String, int>{}));
    final total = data.values.fold<int>(0, (sum, v) => sum + v);
    final hasData = total > 0;
    return CommonCard(
      padding: EdgeInsets.all(th.spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          _buildHeader(context),
          if (_selectedCategory != null) ...[
            CommonSpacer.vertical(th.spacing.sm),
            _CategoryBreadcrumb(
              category: _selectedCategory!,
              onClear: _resetToCategoryView,
            ),
          ],
          CommonSpacer.vertical(th.spacing.md),
          if (!hasData)
            const _EmptyChartPlaceholder()
          else
            _buildChartSection(context, data, total),
          CommonSpacer.vertical(th.spacing.md),
          _buildLegend(context, data, total),
        ],
      ),
    );
  }

  // HEADER + TOGGLE -----------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    final isCategoryRoot =
        _viewType == DistributionViewType.category && _selectedCategory == null;
    final isSubstanceRoot =
        _viewType == DistributionViewType.substance &&
        _selectedCategory == null;
    final subtitle = _selectedCategory == null
        ? 'Usage across categories and substances.'
        : 'Substances within ${_selectedCategory!}.';
    return Row(
      children: [
        Expanded(
          child: CommonSectionHeader(
            title: 'Use distribution',
            subtitle: subtitle,
          ),
        ),
        _ViewToggle(
          activeType: _viewType,
          isDrilledDown: _selectedCategory != null,
          isCategory: isCategoryRoot,
          isSubstance: isSubstanceRoot,
          onCategory: _resetToCategoryView,
          onSubstance: _switchToSubstanceView,
        ),
      ],
    );
  }

  void _resetToCategoryView() {
    setState(() {
      _viewType = DistributionViewType.category;
      _selectedCategory = null;
      _touchedIndex = -1;
    });
  }

  void _switchToSubstanceView() {
    setState(() {
      _viewType = DistributionViewType.substance;
      _selectedCategory = null;
      _touchedIndex = -1;
    });
  }

  // CHART ---------------------------------------------------------------------
  Widget _buildChartSection(
    BuildContext context,
    Map<String, int> data,
    int total,
  ) {
    final ordered = _orderedEntries(data);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const radiusScale = 0.22;
        const minRadius = 70.0;
        const maxRadius = 110.0;
        const innerRadiusScale = 0.5;
        const heightScale = 2.1;
        final radiusBase = (width * radiusScale).clamp(minRadius, maxRadius);
        final innerRadius = radiusBase * innerRadiusScale;
        return SizedBox(
          height: radiusBase * heightScale,
          child: Stack(
            alignment: context.shapes.alignmentCenter,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: context.spacing.xs,
                  centerSpaceRadius: innerRadius,
                  sections: _buildSections(ordered, radiusBase),
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
                      if (index < 0 || index >= ordered.length) return;
                      setState(() => _touchedIndex = index);
                      // Drill-down on category slices
                      if (event is FlTapUpEvent &&
                          _viewType == DistributionViewType.category) {
                        final category = ordered[index].key;
                        setState(() {
                          _selectedCategory = category;
                          _viewType = DistributionViewType.substance;
                          _touchedIndex = -1;
                        });
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
    List<MapEntry<String, int>> entries,
    double radiusBase,
  ) {
    final tx = context.text;
    final total = entries.fold<int>(0, (sum, e) => sum + e.value);
    if (total == 0) return [];
    return List.generate(entries.length, (index) {
      final e = entries[index];
      final isTouched = _touchedIndex == index;
      final baseColor = _viewType == DistributionViewType.category
          ? DrugCategoryColors.colorFor(e.key)
          : _colorForSubstance(context, index: index, total: entries.length);
      final color = baseColor.withValues(alpha: isTouched ? 1.0 : 0.85);
      final radius = isTouched ? radiusBase * 1.08 : radiusBase;
      final slicePercent = e.value / total;
      final showLabel = slicePercent > 0.08;
      return PieChartSectionData(
        value: e.value.toDouble(),
        color: color,
        radius: radius,
        title: showLabel ? '${(slicePercent * 100).round()}%' : '',
        titleStyle: tx.bodySmall.copyWith(
          fontWeight: tx.bodyBold.fontWeight,
          color: context.colors.surface,
        ),
      );
    });
  }

  // LEGEND --------------------------------------------------------------------
  Widget _buildLegend(BuildContext context, Map<String, int> data, int total) {
    final th = context.theme;

    final sorted = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          'Breakdown',
          style: th.typography.captionBold.copyWith(
            color: th.colors.textSecondary,
          ),
        ),
        SizedBox(height: th.spacing.sm),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: context.sizes.heightMd),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(sorted.length, (index) {
                final e = sorted[index];
                final baseColor = _viewType == DistributionViewType.category
                    ? DrugCategoryColors.colorFor(e.key)
                    : _colorForSubstance(
                        context,
                        index: index,
                        total: sorted.length,
                      );
                final pct = total == 0
                    ? '0%'
                    : '${(e.value / total * 100).round()}%';
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: th.spacing.xs),
                  child: Row(
                    children: [
                      Container(
                        width: th.spacing.md,
                        height: th.spacing.md,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(th.spacing.xs),
                        ),
                      ),
                      SizedBox(width: th.spacing.sm),
                      Expanded(
                        child: Text(
                          e.key,
                          style: th.typography.bodySmall.copyWith(
                            color: th.colors.textPrimary,
                          ),
                          overflow: AppLayout.textOverflowEllipsis,
                        ),
                      ),
                      SizedBox(width: th.spacing.sm),
                      Text(
                        '$pct · ${e.value}',
                        style: th.typography.caption.copyWith(
                          color: th.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Color _colorForSubstance(
    BuildContext context, {
    required int index,
    required int total,
  }) {
    final base = _selectedCategory == null
        ? context.accent.primary
        : DrugCategoryColors.colorFor(_selectedCategory);
    if (total <= 1) return base;

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
    final th = context.theme;

    final bg = th.colors.surface.withValues(alpha: 0.7);
    final border = th.colors.border.withValues(alpha: 0.25);
    return Container(
      padding: EdgeInsets.all(th.spacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(th.shapes.radiusFull),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: AppLayout.mainAxisSizeMin,
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
    final th = context.theme;

    return InkWell(
      borderRadius: BorderRadius.circular(th.shapes.radiusFull),
      onTap: onTap,
      child: AnimatedContainer(
        duration: th.animations.fast,
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: th.spacing.sm,
          vertical: th.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? th.accent.primary.withValues(alpha: th.opacities.low)
              : th.colors.transparent,
          borderRadius: BorderRadius.circular(th.shapes.radiusFull),
        ),
        child: Text(
          label,
          style: th.typography.caption.copyWith(
            fontWeight: selected
                ? th.typography.bodyBold.fontWeight
                : th.typography.body.fontWeight,
            color: selected ? th.accent.primary : th.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _CategoryBreadcrumb extends StatelessWidget {
  final String category;
  final VoidCallback onClear;
  const _CategoryBreadcrumb({required this.category, required this.onClear});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    return InkWell(
      onTap: onClear,
      borderRadius: BorderRadius.circular(th.shapes.radiusFull),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: th.spacing.sm,
          vertical: th.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: th.accent.primary.withValues(alpha: th.opacities.veryLow),
          borderRadius: BorderRadius.circular(th.shapes.radiusFull),
        ),
        child: Row(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: th.spacing.lg,
              color: th.accent.primary,
            ),
            SizedBox(width: th.spacing.xs),
            Text(
              'Substances in $category',
              style: th.typography.caption.copyWith(
                color: th.accent.primary,
                fontWeight: th.tx.bodyBold.fontWeight,
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
    final th = context.theme;

    final label = switch (mode) {
      DistributionViewType.category => 'categories',
      DistributionViewType.substance => category ?? 'substances',
    };
    return Column(
      mainAxisSize: AppLayout.mainAxisSizeMin,
      children: [
        Text(
          total.toString(),
          style: th.typography.heading4.copyWith(color: th.colors.textPrimary),
        ),
        SizedBox(height: th.spacing.xs),
        Text(
          label,
          style: th.typography.caption.copyWith(color: th.colors.textSecondary),
        ),
      ],
    );
  }
}

class _EmptyChartPlaceholder extends StatelessWidget {
  const _EmptyChartPlaceholder();
  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    return SizedBox(
      height: context.sizes.heightMd,
      child: Center(
        child: Text(
          'No data to visualize yet.\nLog a few entries to see distribution.',
          textAlign: AppLayout.textAlignCenter,
          style: th.typography.bodySmall.copyWith(
            color: th.colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
