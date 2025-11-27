import 'package:flutter/material.dart';
import '../models/drug_catalog_entry.dart';
import '../services/personal_library_service.dart';
import '../repo/stockpile_repository.dart';
import '../repo/substance_repository.dart';
import '../models/stockpile_item.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/catalog/add_stockpile_sheet.dart';
import '../widgets/personal_library/substance_card.dart';
import '../widgets/personal_library/summary_stats_banner.dart';
import '../widgets/personal_library/day_usage_sheet.dart';
import '../widgets/personal_library/library_search_bar.dart';
import '../widgets/personal_library/library_app_bar.dart';
import '../constants/ui_colors.dart';
import '../constants/theme_constants.dart';
import '../utils/drug_preferences_manager.dart';

class PersonalLibraryPage extends StatefulWidget {
  const PersonalLibraryPage({super.key});

  @override
  State<PersonalLibraryPage> createState() => _PersonalLibraryPageState();
}

class _PersonalLibraryPageState extends State<PersonalLibraryPage> {
  final _service = PersonalLibraryService();
  final _stockpileRepo = StockpileRepository();
  final _substanceRepo = SubstanceRepository();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<DrugCatalogEntry> _catalog = [];
  List<DrugCatalogEntry> _filtered = [];
  bool _loading = true;
  String? _error;
  bool _showArchived = false;

  // Summary stats
  int _totalUses = 0;
  String _mostUsedCategory = '';
  double _avgUses = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final catalog = await _service.fetchCatalog();
      setState(() {
        _catalog = catalog;
        _filtered = _applyFilters(_searchController.text);
        _loading = false;
        _calculateSummaryStats();
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load catalog: $e';
        _loading = false;
      });
    }
  }

  void _calculateSummaryStats() {
    final activeSubstances = _catalog.where((e) => !e.archived).toList();
    
    _totalUses = activeSubstances.fold(0, (sum, e) => sum + e.totalUses);
    _avgUses = activeSubstances.isEmpty ? 0.0 : _totalUses / activeSubstances.length;
    
    // Find most used category
    final Map<String, int> categoryCount = {};
    for (final entry in activeSubstances) {
      for (final cat in entry.categories) {
        categoryCount[cat] = (categoryCount[cat] ?? 0) + entry.totalUses;
      }
    }
    
    if (categoryCount.isNotEmpty) {
      final maxEntry = categoryCount.entries.reduce((a, b) => a.value > b.value ? a : b);
      _mostUsedCategory = maxEntry.key;
    } else {
      _mostUsedCategory = 'None';
    }
  }

  Future<void> _toggleFavorite(DrugCatalogEntry entry) async {
    await _service.toggleFavorite(entry);
    if (!mounted) return;
    
    // Reload catalog to get updated entry
    await _loadCatalog();
  }

  Future<void> _toggleArchive(DrugCatalogEntry entry) async {
    try {
      final currentPrefs = LocalPrefs(
        favorite: entry.favorite,
        archived: entry.archived,
        notes: entry.notes,
        quantity: entry.quantity,
      );
      
      await DrugPreferencesManager.saveArchived(
        entry.name,
        !entry.archived,
        currentPrefs,
      );
      
      await _loadCatalog();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to archive: $e')),
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filtered = _applyFilters(value);
    });
  }

  List<DrugCatalogEntry> _applyFilters(String query) {
    var results = _service.applySearch(query, _catalog);
    if (!_showArchived) {
      results = results.where((e) => !e.archived).toList();
    }
    return results;
  }

  void _showAddStockpileSheet(DrugCatalogEntry entry) async {
    final substanceDetails = await _substanceRepo.getSubstanceDetails(entry.name);
    
    if (!mounted) return;
    
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddStockpileSheet(
        substanceId: entry.name,
        substanceName: entry.name,
        substanceDetails: substanceDetails,
      ),
    );
    
    if (result == true && mounted) {
      setState(() {});
    }
  }

  void _showDayUsageDetails(String substanceName, int weekdayIndex, String dayName, bool isDark, Color accentColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      drawer: const DrawerMenu(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App bar
          LibraryAppBar(
            showArchived: _showArchived,
            onToggleArchived: () {
              setState(() {
                _showArchived = !_showArchived;
                _filtered = _applyFilters(_searchController.text);
              });
            },
            onRefresh: _loadCatalog,
          ),

          // Summary stats banner - scrolls away
          if (!_loading && _error == null)
            SliverToBoxAdapter(
              child: SummaryStatsBanner(
                totalUses: _totalUses,
                activeSubstances: _catalog.where((e) => !e.archived).length,
                avgUses: _avgUses,
                mostUsedCategory: _mostUsedCategory,
              ),
            ),

          // Search bar - scrolls away
          SliverToBoxAdapter(
            child: LibrarySearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          ),

          // Content
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 12),
                    TextButton(onPressed: _loadCatalog, child: const Text('Retry')),
                  ],
                ),
              ),
            )
          else if (_filtered.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  _showArchived ? 'No substances found' : 'No active substances in your library',
                  style: TextStyle(
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.all(ThemeConstants.space16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = _filtered[index];
                    return FutureBuilder<StockpileItem?>(
                      future: _stockpileRepo.getStockpile(entry.name),
                      builder: (context, snapshot) {
                        return SubstanceCard(
                          entry: entry,
                          stockpile: snapshot.data,
                          onTap: () {
                            // Navigate to details if needed
                          },
                          onFavorite: () => _toggleFavorite(entry),
                          onArchive: () => _toggleArchive(entry),
                          onManageStockpile: () => _showAddStockpileSheet(entry),
                          onDayTap: _showDayUsageDetails,
                        );
                      },
                    );
                  },
                  childCount: _filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
