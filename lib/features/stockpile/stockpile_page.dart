// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Migrated to Riverpod controller + Freezed state. UI/UX unchanged.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import 'package:mobile_drug_use_app/common/layout/common_drawer.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/features/catalog/widgets/add_stockpile_sheet.dart';
import 'package:mobile_drug_use_app/features/stockpile/controllers/personal_library_controller.dart';
import 'package:mobile_drug_use_app/features/stockpile/providers/stockpile_providers.dart';
import 'package:mobile_drug_use_app/models/drug_catalog_entry.dart';
import 'package:mobile_drug_use_app/models/stockpile_item.dart';

import 'widgets/day_usage_sheet.dart';
import 'widgets/library_app_bar.dart';
import 'widgets/library_search_bar.dart';
import 'widgets/substance_card.dart';
import 'widgets/summary_stats_banner.dart';

class PersonalLibraryPage extends ConsumerStatefulWidget {
  const PersonalLibraryPage({super.key});

  @override
  ConsumerState<PersonalLibraryPage> createState() =>
      _PersonalLibraryPageState();
}

class _PersonalLibraryPageState extends ConsumerState<PersonalLibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showAddStockpileSheet(DrugCatalogEntry entry) async {
    final repo = ref.read(substanceRepositoryProvider);
    final substanceDetails = await repo.getSubstanceDetails(entry.name);
    if (!mounted) return;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.transparent,
      builder: (context) => AddStockpileSheet(
        substanceId: entry.name,
        substanceName: entry.name,
        substanceDetails: substanceDetails,
      ),
    );

    if (result == true && mounted) {
      ref.invalidate(stockpileItemProvider(entry.name));
    }
  }

  void _showDayUsageDetails(
    String substanceName,
    int weekdayIndex,
    String dayName,
    bool isDark,
    Color accentColor,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.transparent,
      builder: (context) => DayUsageSheet(
        substanceName: substanceName,
        weekdayIndex: weekdayIndex,
        dayName: dayName,
        accentColor: accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;

    final asyncState = ref.watch(personalLibraryControllerProvider);
    final data = asyncState.valueOrNull;

    return Scaffold(
      backgroundColor: c.background,
      drawer: const CommonDrawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          LibraryAppBar(
            showArchived: data?.showArchived ?? false,
            onToggleArchived: () {
              ref
                  .read(personalLibraryControllerProvider.notifier)
                  .toggleShowArchived();
            },
            onRefresh: () {
              ref.read(personalLibraryControllerProvider.notifier).refresh();
            },
          ),
          if (data != null && !asyncState.isLoading && !asyncState.hasError)
            SliverToBoxAdapter(
              child: SummaryStatsBanner(
                totalUses: data.summary.totalUses,
                activeSubstances: data.summary.activeSubstances,
                avgUses: data.summary.avgUses,
                mostUsedCategory: data.summary.mostUsedCategory,
              ),
            ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, __, ___) {
                return LibrarySearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    ref
                        .read(personalLibraryControllerProvider.notifier)
                        .setQuery(value);
                  },
                  onClear: () {
                    _searchController.clear();
                    ref
                        .read(personalLibraryControllerProvider.notifier)
                        .setQuery('');
                  },
                );
              },
            ),
          ),
          if (asyncState.isLoading)
            const SliverFillRemaining(child: Center(child: CommonLoader()))
          else if (asyncState.hasError)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: AppLayout.mainAxisSizeMin,
                  children: [
                    Text(
                      'Failed to load catalog: ${asyncState.error}',
                      style: th.typography.body.copyWith(color: c.error),
                    ),
                    CommonSpacer(height: sp.md),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(personalLibraryControllerProvider.notifier)
                            .refresh();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if ((data?.filtered ?? const <DrugCatalogEntry>[]).isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  (data?.showArchived ?? false)
                      ? 'No substances found'
                      : 'No active substances in your library',
                  style: th.typography.body.copyWith(color: c.textSecondary),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(sp.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final filtered =
                        data?.filtered ?? const <DrugCatalogEntry>[];
                    final entry = filtered[index];

                    return Consumer(
                      builder: (context, ref, _) {
                        final stockpileAsync = ref.watch(
                          stockpileItemProvider(entry.name),
                        );
                        final StockpileItem? stockpile =
                            stockpileAsync.valueOrNull;

                        return SubstanceCard(
                          entry: entry,
                          stockpile: stockpile,
                          onTap: () {},
                          onFavorite: () {
                            ref
                                .read(
                                  personalLibraryControllerProvider.notifier,
                                )
                                .toggleFavorite(entry);
                          },
                          onArchive: () {
                            ref
                                .read(
                                  personalLibraryControllerProvider.notifier,
                                )
                                .toggleArchive(entry);
                          },
                          onManageStockpile: () {
                            _showAddStockpileSheet(entry);
                          },
                          onDayTap: _showDayUsageDetails,
                        );
                      },
                    );
                  },
                  childCount:
                      (data?.filtered ?? const <DrugCatalogEntry>[]).length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
