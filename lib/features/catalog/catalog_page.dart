// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Catalog page using local state and repository.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../stockpile/repo/substance_repository.dart';
import '../analytics/services/analytics_service.dart';
import '../analytics/providers/analytics_providers.dart' as analytics_providers;
import '../stockpile/providers/stockpile_providers.dart' as stockpile_providers;
import '../../constants/data/drug_categories.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/add_stockpile_sheet.dart';
import 'widgets/substance_details_sheet.dart';
import 'widgets/catalog_app_bar.dart';
import 'widgets/catalog_search_filters.dart';
import 'widgets/catalog_empty_state.dart';
import 'widgets/animated_substance_list.dart';

enum CatalogSortMode { relevance, alphabetical }

class CatalogPage extends ConsumerStatefulWidget {
  final SubstanceRepository? repository;
  final AnalyticsService? analyticsService;
  const CatalogPage({super.key, this.repository, this.analyticsService});
  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  late final SubstanceRepository _repository;
  late final AnalyticsService _analyticsService;
  List<Map<String, dynamic>> _allSubstances = [];
  List<Map<String, dynamic>> _filteredSubstances = [];
  String _searchQuery = '';
  bool _showCommonOnly = false;
  final List<String> _selectedCategories = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  CatalogSortMode _sortMode = CatalogSortMode.relevance;
  Set<String> _stockpileSubstanceIdsLower = {};
  Set<String> _usedSubstanceNamesLower = {};
  @override
  void initState() {
    super.initState();
    _repository =
        widget.repository ??
        ref.read(stockpile_providers.substanceRepositoryProvider);
    _analyticsService =
        widget.analyticsService ??
        ref.read(analytics_providers.analyticsServiceProvider);
    _loadSubstances();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSubstances() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _repository.fetchSubstancesCatalog(),
        _analyticsService.fetchEntries(),
        ref
            .read(stockpile_providers.stockpileRepositoryProvider)
            .getAllStockpileItems(),
      ]);

      final substances = results[0] as List<Map<String, dynamic>>;
      final entries = results[1] as List<dynamic>;
      final stockpileItems = results[2] as List<dynamic>;

      final usedNamesLower = <String>{};
      for (final entry in entries) {
        try {
          final substance = (entry as dynamic).substance as String?;
          final v = substance?.toLowerCase().trim();
          if (v != null && v.isNotEmpty) usedNamesLower.add(v);
        } catch (_) {
          // Ignore entries that don't match the expected shape.
        }
      }

      final stockpileIdsLower = <String>{};
      for (final item in stockpileItems) {
        try {
          final id = (item as dynamic).substanceId as String?;
          final v = id?.toLowerCase().trim();
          if (v != null && v.isNotEmpty) stockpileIdsLower.add(v);
        } catch (_) {
          // Ignore items that don't match the expected shape.
        }
      }

      if (mounted) {
        setState(() {
          _allSubstances = substances;
          _usedSubstanceNamesLower = usedNamesLower;
          _stockpileSubstanceIdsLower = stockpileIdsLower;
          _filteredSubstances = _computeFilteredAndSorted();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading substances: $e'),
            backgroundColor: th.colors.error,
          ),
        );
      }
    }
  }

  String _substanceIdFor(Map<String, dynamic> substance) {
    final id = (substance['id'] ?? substance['substance_id'])?.toString();
    if (id != null && id.trim().isNotEmpty) return id.trim();
    final name = (substance['name'] ?? substance['pretty_name'] ?? '')
        .toString();
    return name.trim();
  }

  String _displayNameFor(Map<String, dynamic> substance) {
    return (substance['pretty_name'] ?? substance['name'] ?? '')
        .toString()
        .trim();
  }

  bool _isCommonFor(Map<String, dynamic> substance) {
    final v = substance['is_common'] ?? substance['common'];
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) {
      final s = v.toLowerCase().trim();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  bool _isPreviouslyUsedFor(Map<String, dynamic> substance) {
    final name = (substance['name'] ?? '').toString().toLowerCase().trim();
    final pretty = (substance['pretty_name'] ?? '')
        .toString()
        .toLowerCase()
        .trim();
    if (name.isNotEmpty && _usedSubstanceNamesLower.contains(name)) return true;
    if (pretty.isNotEmpty && _usedSubstanceNamesLower.contains(pretty)) {
      return true;
    }
    return false;
  }

  bool _isInStockpileFor(Map<String, dynamic> substance) {
    final idLower = _substanceIdFor(substance).toLowerCase();
    final nameLower = (substance['name'] ?? '').toString().toLowerCase().trim();
    return _stockpileSubstanceIdsLower.contains(idLower) ||
        (nameLower.isNotEmpty &&
            _stockpileSubstanceIdsLower.contains(nameLower));
  }

  int _categoryPriorityIndexFor(Map<String, dynamic> substance) {
    final categories =
        (substance['categories'] as List?)?.map((e) => e.toString()).toList() ??
        <String>[];
    final primary = categories.isEmpty
        ? 'Placeholder'
        : DrugCategories.primaryCategoryFromRaw(categories.join(', '));
    final index = DrugCategories.categoryPriority
        .map((e) => e.toLowerCase())
        .toList()
        .indexOf(primary.toLowerCase());
    return index >= 0 ? index : DrugCategories.categoryPriority.length + 1;
  }

  List<Map<String, dynamic>> _computeFilteredAndSorted() {
    final query = _searchQuery.toLowerCase();

    final filtered = _allSubstances
        .where((substance) {
          final nameLower = _displayNameFor(substance).toLowerCase();
          final aliases =
              (substance['aliases'] as List?)
                  ?.map((e) => e.toString().toLowerCase())
                  .toList() ??
              <String>[];
          final categories =
              (substance['categories'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              <String>[];

          final matchesSearch =
              query.isEmpty ||
              nameLower.contains(query) ||
              aliases.any((alias) => alias.contains(query));

          final matchesCategory =
              _selectedCategories.isEmpty ||
              categories.any((cat) => _selectedCategories.contains(cat));

          final matchesCommon = !_showCommonOnly || _isCommonFor(substance);

          return matchesSearch && matchesCategory && matchesCommon;
        })
        .toList(growable: false);

    int boolDesc(bool a, bool b) {
      if (a == b) return 0;
      return a ? -1 : 1;
    }

    final sorted = [...filtered];
    sorted.sort((a, b) {
      if (_sortMode == CatalogSortMode.alphabetical) {
        return _displayNameFor(
          a,
        ).toLowerCase().compareTo(_displayNameFor(b).toLowerCase());
      }

      // Relevance sort
      final inStockA = _isInStockpileFor(a);
      final inStockB = _isInStockpileFor(b);
      final byStock = boolDesc(inStockA, inStockB);
      if (byStock != 0) return byStock;

      final usedA = _isPreviouslyUsedFor(a);
      final usedB = _isPreviouslyUsedFor(b);
      final byUsed = boolDesc(usedA, usedB);
      if (byUsed != 0) return byUsed;

      final commonA = _isCommonFor(a);
      final commonB = _isCommonFor(b);
      final byCommon = boolDesc(commonA, commonB);
      if (byCommon != 0) return byCommon;

      final catA = _categoryPriorityIndexFor(a);
      final catB = _categoryPriorityIndexFor(b);
      final byCat = catA.compareTo(catB);
      if (byCat != 0) return byCat;

      return _displayNameFor(
        a,
      ).toLowerCase().compareTo(_displayNameFor(b).toLowerCase());
    });

    return sorted;
  }

  void _applyFilters() {
    setState(() {
      _filteredSubstances = _computeFilteredAndSorted();
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: th.colors.background,
        appBar: const CatalogAppBar(),
        drawer: const CommonDrawer(),
        body: Center(
          child: CircularProgressIndicator(color: th.accent.primary),
        ),
      );
    }
    return Scaffold(
      backgroundColor: th.colors.background,
      appBar: const CatalogAppBar(),
      drawer: const CommonDrawer(),
      body: Column(
        children: [
          CatalogSearchFilters(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedCategories: _selectedCategories,
            showCommonOnly: _showCommonOnly,
            onSearchClear: () {
              _searchController.clear();
              setState(() => _searchQuery = '');
              _applyFilters();
            },
            onSearchChanged: (value) {
              setState(() => _searchQuery = value);
              _applyFilters();
            },
            onCategoryToggled: (category) {
              setState(() {
                if (category == null) {
                  _selectedCategories.clear();
                } else {
                  if (_selectedCategories.contains(category)) {
                    _selectedCategories.remove(category);
                  } else {
                    _selectedCategories.add(category);
                  }
                }
              });
              _applyFilters();
            },
            onCommonOnlyChanged: (value) {
              setState(() => _showCommonOnly = value);
              _applyFilters();
            },
          ),

          InkWell(
            onTap: () {
              setState(() {
                _sortMode = _sortMode == CatalogSortMode.relevance
                    ? CatalogSortMode.alphabetical
                    : CatalogSortMode.relevance;
                _filteredSubstances = _computeFilteredAndSorted();
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: th.sp.md,
                vertical: th.sp.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sort,
                    size: th.sizes.iconSm,
                    color: th.colors.textTertiary,
                  ),
                  SizedBox(width: th.sp.xs),
                  Text(
                    'Sorted by: ${_sortMode == CatalogSortMode.relevance ? 'Relevance' : 'A–Z'}',
                    style: th.typography.bodySmall.copyWith(
                      color: th.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: _filteredSubstances.isEmpty
                ? const CatalogEmptyState()
                : AnimatedSubstanceList(
                    substances: _filteredSubstances,
                    onSubstanceTap: _showSubstanceDetails,
                    onAddStockpile: _showAddStockpileSheet,
                    getMostActiveDay: _getMostActiveDay,
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddStockpileSheet(
    String substanceId,
    String substanceName,
    Map<String, dynamic> substance,
  ) async {
    final c = context.colors;
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.transparent,
      builder: (context) => AddStockpileSheet(
        substanceId: substanceId,
        substanceName: substanceName,
        substanceDetails: substance,
      ),
    );
    // Refresh the list if stockpile was added
    if (result == true && mounted) {
      setState(() {});
    }
  }

  Future<String?> _getMostActiveDay(String substanceName) async {
    try {
      final entries = await _analyticsService.fetchEntries();
      if (entries.isEmpty) {
        return null;
      }
      // Filter entries for this substance
      final substanceEntries = entries
          .where(
            (e) => e.substance.toLowerCase() == substanceName.toLowerCase(),
          )
          .toList();
      if (substanceEntries.isEmpty) {
        return null;
      }
      final mostActive = _analyticsService.getMostActiveDay(
        substanceEntries,
        substanceName,
      );
      return mostActive;
    } catch (e) {
      return null;
    }
  }

  void _showSubstanceDetails(Map<String, dynamic> substance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.transparent,
      builder: (context) => SubstanceDetailsSheet(
        substance: substance,
        onAddStockpile: _showAddStockpileSheet,
      ),
    );
  }
}
