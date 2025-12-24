// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE (local, autoDispose)
// Notes:
// - FULL INSTRUMENTATION VERSION
// - Tracks input data, provider lifecycle, derived data, and UI intent
// - DO NOT KEEP THIS VERSION LONG-TERM
// - Use ONLY to locate analytics bugs

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/layout/app_layout.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/text/common_section_header.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../models/log_entry_model.dart';
import '../../../../common/logging/app_log.dart';

/// ---------------------------------------------------------------------------
/// LOCAL BRIDGE PROVIDERS (inputs overridden by parent ProviderScope)
/// ---------------------------------------------------------------------------

final _entriesProvider = Provider.autoDispose<List<LogEntry>>(
  (_) => throw UnimplementedError(),
);

final _mappingProvider = Provider.autoDispose<Map<String, String>>(
  (_) => throw UnimplementedError(),
);

/// ---------------------------------------------------------------------------
/// UI STATE
/// ---------------------------------------------------------------------------

final selectedCategoryProvider = StateProvider.autoDispose<String?>((ref) {
  AppLog.i('[STATE] selectedCategoryProvider CREATED');

  ref.listenSelf((prev, next) {
    AppLog.i('[STATE] selectedCategory changed: $prev → $next');
  });

  ref.onDispose(() {
    AppLog.i('[STATE] selectedCategoryProvider DISPOSED');
  });

  return null;
});

final touchedIndexProvider = StateProvider.autoDispose<int>((ref) {
  AppLog.i('[STATE] touchedIndexProvider CREATED');

  ref.listenSelf((prev, next) {
    AppLog.d('[STATE] touchedIndex changed: $prev → $next');
  });

  ref.onDispose(() {
    AppLog.i('[STATE] touchedIndexProvider DISPOSED');
  });

  return -1;
});

/// ---------------------------------------------------------------------------
/// DERIVED DATA
/// ---------------------------------------------------------------------------

final allCategoryCountsProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final entries = ref.watch(_entriesProvider);
  final mapping = ref.watch(_mappingProvider);

  AppLog.d(
    '[DATA] allCategoryCounts recompute '
    '(entries=${entries.length})',
  );

  final counts = <String, int>{};

  for (final entry in entries) {
    final normalized = entry.substance.toLowerCase().trim();
    final category = mapping[normalized] ?? 'Unknown';
    counts[category] = (counts[category] ?? 0) + 1;
  }

  AppLog.d('[DATA] allCategoryCounts result=$counts');

  if (counts.isEmpty) {
    AppLog.w('[DATA] allCategoryCounts EMPTY');
  }

  return counts;
});

final pieChartDataProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final selected = ref.watch(selectedCategoryProvider);
  final all = ref.watch(allCategoryCountsProvider);

  AppLog.d(
    '[DATA] pieChartData recompute '
    'selected=$selected '
    'available=${all.keys.toList()}',
  );

  if (selected == null) {
    return all;
  }

  if (!all.containsKey(selected)) {
    AppLog.w('[DATA] selectedCategory "$selected" NOT IN allCategoryCounts');
  }

  return {selected: all[selected] ?? 0};
});

final substanceCountsProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final selected = ref.watch(selectedCategoryProvider);

  if (selected == null) {
    AppLog.d('[DATA] substanceCounts skipped (no selection)');
    return const {};
  }

  final entries = ref.watch(_entriesProvider);
  final mapping = ref.watch(_mappingProvider);

  AppLog.d(
    '[DATA] substanceCounts recompute '
    '(category=$selected, entries=${entries.length})',
  );

  final counts = <String, int>{};

  for (final entry in entries) {
    final normalized = entry.substance.toLowerCase().trim();
    final category = mapping[normalized] ?? 'Unknown';

    if (category == selected) {
      counts[entry.substance] = (counts[entry.substance] ?? 0) + 1;
    }
  }

  AppLog.d('[DATA] substanceCounts result=$counts');

  if (counts.isEmpty) {
    AppLog.w('[DATA] substanceCounts EMPTY for "$selected"');
  }

  return counts;
});

/// ---------------------------------------------------------------------------
/// ROOT WIDGET
/// ---------------------------------------------------------------------------

class CategoryPieChart extends ConsumerWidget {
  final List<LogEntry> filteredEntries;
  final Map<String, String> substanceToCategory;

  const CategoryPieChart({
    super.key,
    required this.filteredEntries,
    required this.substanceToCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    AppLog.i(
      '[BUILD] CategoryPieChart '
      '(selectedCategory=$selectedCategory, '
      'entries=${filteredEntries.length})',
    );

    return CommonCard(
      child: Column(
        children: [
          const CommonSectionHeader(title: 'Category Distribution'),
          CommonSpacer.vertical(context.theme.spacing.md),

          const _PieChart(),

          const CommonSpacer.vertical(16),

          const _Legend(),

          if (selectedCategory != null) ...[
            const CommonSpacer.vertical(16),
            const _SubstanceHeader(),
            const CommonSpacer.vertical(16),
            const _SubstanceBarChart(),
          ],
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// PIE CHART
/// ---------------------------------------------------------------------------

class _PieChart extends ConsumerWidget {
  const _PieChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(pieChartDataProvider);
    final touchedIndex = ref.watch(touchedIndexProvider);

    final categories = data.keys.toList();

    AppLog.d(
      '[BUILD] PieChart '
      '(categories=$categories, touchedIndex=$touchedIndex)',
    );

    return SizedBox(
      height: context.sizes.heightXl,
      child: PieChart(
        PieChartData(
          sections: List.generate(categories.length, (index) {
            final category = categories[index];
            final count = data[category]!;

            return PieChartSectionData(
              value: count.toDouble(),
              title: '$category\n$count',
              color: context.theme.accent.primary.withValues(
                alpha: (0.4 + index * 0.1).clamp(0.4, 0.8),
              ),
              radius: touchedIndex == index
                  ? MediaQuery.of(context).size.width * 0.25
                  : MediaQuery.of(context).size.width * 0.20,
            );
          }),
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              final index = response?.touchedSection?.touchedSectionIndex;

              AppLog.i('[UI] Pie touched index=$index');

              if (index == null) {
                AppLog.i('[UI] Clearing selection');
                ref.read(touchedIndexProvider.notifier).state = -1;
                ref.read(selectedCategoryProvider.notifier).state = null;
                return;
              }

              final category = categories[index];
              AppLog.i('[UI] Selecting category "$category"');

              ref.read(touchedIndexProvider.notifier).state = index;
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// LEGEND
/// ---------------------------------------------------------------------------

class _Legend extends ConsumerWidget {
  const _Legend();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(allCategoryCountsProvider);

    AppLog.d('[BUILD] Legend build categories=${data.keys.toList()}');

    return Wrap(
      spacing: context.theme.spacing.lg,
      runSpacing: context.theme.spacing.sm,
      children: data.entries.map((e) {
        return Row(
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            Container(
              width: context.theme.spacing.lg,
              height: context.theme.spacing.lg,
              decoration: BoxDecoration(
                color: context.theme.accent.primary,
                borderRadius: BorderRadius.circular(context.theme.spacing.xs),
              ),
            ),
            SizedBox(width: context.theme.spacing.sm),
            Text('${e.key} (${e.value})', style: context.theme.typography.body),
          ],
        );
      }).toList(),
    );
  }
}

/// ---------------------------------------------------------------------------
/// SUBSTANCE VIEW
/// ---------------------------------------------------------------------------

class _SubstanceHeader extends ConsumerWidget {
  const _SubstanceHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoryProvider)!;

    AppLog.d('[BUILD] SubstanceHeader build selected=$selected');

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: context.theme.colors.textPrimary),
          onPressed: () {
            AppLog.i('[UI] Back pressed – clearing selection');
            ref.read(selectedCategoryProvider.notifier).state = null;
            ref.read(touchedIndexProvider.notifier).state = -1;
          },
        ),
        Text('$selected Substances', style: context.theme.typography.heading3),
      ],
    );
  }
}

class _SubstanceBarChart extends ConsumerWidget {
  const _SubstanceBarChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(substanceCountsProvider);

    AppLog.d(
      '[BUILD] SubstanceBarChart build '
      'substances=${data.keys.toList()}',
    );

    return SizedBox(
      height: context.sizes.heightMd,
      child: Center(
        child: Text(data.isEmpty ? 'No data' : data.keys.join(', ')),
      ),
    );
  }
}
