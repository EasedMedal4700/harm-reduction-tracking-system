
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Structural refactor + CommonCard + caching. No Riverpod.
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';


import '../../../../constants/theme/app_theme_extension.dart';

import '../../../../constants/data/drug_categories.dart';
import '../../../../models/log_entry_model.dart';

import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';

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

/// Internal controller responsible for all data aggregation & caching.
/// This keeps the widget from becoming a god-class.
class _UseDistributionController {
Map<String, int> categoryCounts;
Map<String, int> substanceCounts;
List<LogEntry> filteredEntries;
Map<String, String> substanceToCategory;

// Cache for per-category substance counts
final Map<String, Map<String, int>> _substancesByCategoryCache = {};

_UseDistributionController({
required this.categoryCounts,
required this.substanceCounts,
required this.filteredEntries,
required this.substanceToCategory,
});

void update({
required Map<String, int> categoryCounts,
required Map<String, int> substanceCounts,
required List<LogEntry> filteredEntries,
required Map<String, String> substanceToCategory,
}) {
this.categoryCounts = categoryCounts;
this.substanceCounts = substanceCounts;
this.filteredEntries = filteredEntries;
this.substanceToCategory = substanceToCategory;
_substancesByCategoryCache.clear();
}

/// Active dataset based on view type and optional selected category.
Map<String, int> getActiveData(
DistributionViewType viewType,
String? selectedCategory,
) {
if (viewType == DistributionViewType.category && selectedCategory == null) {
return categoryCounts;
}

if (viewType == DistributionViewType.substance && selectedCategory != null) {
  return getSubstanceCountsForCategory(selectedCategory);
}

return substanceCounts;


}

/// Returns substance counts for a specific category, cached.
Map<String, int> getSubstanceCountsForCategory(String category) {
if (_substancesByCategoryCache.containsKey(category)) {
return _substancesByCategoryCache[category]!;
}

final result = <String, int>{};
for (final entry in filteredEntries) {
  final cat = substanceToCategory[entry.substance.toLowerCase()] ?? 'Other';
  if (cat == category) {
    result[entry.substance] = (result[entry.substance] ?? 0) + 1;
  }
}

_substancesByCategoryCache[category] = result;
return result;


}

Color colorForSubstance(
String substance,
int index,
int total,
) {
final category = substanceToCategory[substance.toLowerCase()] ?? 'Other';
final base = DrugCategoryColors.colorFor(category);

if (total <= 1) return base;

final hsl = HSLColor.fromColor(base);
final ratio = total <= 1 ? 0.5 : index / (total - 1);

final lightness = (hsl.lightness + (ratio - 0.5) * 0.35).clamp(0.25, 0.8);
final sat = (hsl.saturation + (ratio - 0.5) * 0.25).clamp(0.5, 1.0);

return hsl.withLightness(lightness).withSaturation(sat).toColor();


}
}

class _UseDistributionCardState extends State<UseDistributionCard> {
late final _controller = _UseDistributionController(
categoryCounts: widget.categoryCounts,
substanceCounts: widget.substanceCounts,
filteredEntries: widget.filteredEntries,
substanceToCategory: widget.substanceToCategory,
);

DistributionViewType _viewType = DistributionViewType.category;
int _touchedIndex = -1;
String? _selectedCategory;

@override
void didUpdateWidget(covariant UseDistributionCard oldWidget) {
super.didUpdateWidget(oldWidget);

// Keep controller data in sync when parent updates props
if (oldWidget.categoryCounts != widget.categoryCounts ||
    oldWidget.substanceCounts != widget.substanceCounts ||
    oldWidget.filteredEntries != widget.filteredEntries ||
    oldWidget.substanceToCategory != widget.substanceToCategory) {
  _controller.update(
    categoryCounts: widget.categoryCounts,
    substanceCounts: widget.substanceCounts,
    filteredEntries: widget.filteredEntries,
    substanceToCategory: widget.substanceToCategory,
  );
}


}

@override
Widget build(BuildContext context) {
final t = context.theme;

final data = _controller.getActiveData(_viewType, _selectedCategory);
final total = data.values.fold<int>(0, (sum, v) => sum + v);
final hasData = total > 0;

return CommonCard(
  padding: EdgeInsets.all(t.spacing.lg),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeader(context),
      if (_selectedCategory != null) ...[
        CommonSpacer.vertical(t.spacing.sm),
        _CategoryBreadcrumb(
          category: _selectedCategory!,
          onClear: _resetToCategoryView,
        ),
      ],
      CommonSpacer.vertical(t.spacing.md),

      if (!hasData)
        const _EmptyChartPlaceholder()
      else
        _buildChartSection(context, data, total),

      CommonSpacer.vertical(t.spacing.md),
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
_viewType == DistributionViewType.substance && _selectedCategory == null;

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

                  // Drill-down on category slices
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
      : _controller.colorForSubstance(e.key, index, entries.length);

    final color = baseColor.withValues(alpha: isTouched ? 1.0 : 0.85);
    final radius = isTouched ? radiusBase * 1.08 : radiusBase;

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

  Widget _buildLegend(BuildContext context, Map<String, int> data, int total) {
    final t = context.theme;
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
            final baseColor =
                _viewType == DistributionViewType.category
                    ? DrugCategoryColors.colorFor(e.key)
                    : _controller.colorForSubstance(
                        e.key,
                        index,
                        sorted.length,
                      );

            final pct = total == 0
                ? '0%'
                : '${(e.value / total * 100).round()}%';

            return Padding(
              padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
              child: Row(
                children: [
                  Container(
                    width: t.spacing.md,
                    height: t.spacing.md,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(t.spacing.xs),
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
    final bg = t.colors.surface.withValues(alpha: 0.7);
    final border = t.colors.border.withValues(alpha: 0.25);

    return Container(
      padding: EdgeInsets.all(t.spacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(t.shapes.radiusFull),
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

    return InkWell(
      borderRadius: BorderRadius.circular(t.shapes.radiusFull),
      onTap: onTap,
  child: AnimatedContainer(
    duration: t.animations.fast,
    curve: Curves.easeOut,
    padding: EdgeInsets.symmetric(
      horizontal: t.spacing.sm,
      vertical: t.spacing.xs,
    ),
    decoration: BoxDecoration(
      color: selected
          ? t.accent.primary.withValues(alpha: t.opacities.low)
          : t.colors.transparent,
      borderRadius: BorderRadius.circular(t.shapes.radiusFull),
    ),
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
      borderRadius: BorderRadius.circular(t.shapes.radiusFull),
      child: Container(
    padding: EdgeInsets.symmetric(
      horizontal: t.spacing.sm,
      vertical: t.spacing.xs,
    ),
    decoration: BoxDecoration(
      color: t.accent.primary.withValues(alpha: t.opacities.veryLow),
      borderRadius: BorderRadius.circular(t.shapes.radiusFull),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.arrow_back_ios_new_rounded,
          size: t.spacing.lg,
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
const _EmptyChartPlaceholder();

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

