import 'package:flutter/material.dart';
import '../repo/substance_repository.dart';
import '../services/analytics_service.dart';
import '../constants/ui_colors.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/catalog/add_stockpile_sheet.dart';
import '../widgets/catalog/substance_details_sheet.dart';
import '../widgets/catalog/catalog_app_bar.dart';
import '../widgets/catalog/catalog_search_filters.dart';
import '../widgets/catalog/catalog_empty_state.dart';
import '../widgets/catalog/animated_substance_list.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final SubstanceRepository _repository = SubstanceRepository();
  final AnalyticsService _analyticsService = AnalyticsService();
  List<Map<String, dynamic>> _allSubstances = [];
  List<Map<String, dynamic>> _filteredSubstances = [];
  String _searchQuery = '';
  bool _showCommonOnly = false;
  final List<String> _selectedCategories = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCatalog() async {
    try {
      final substances = await _repository.fetchSubstancesCatalog();
      substances.sort((a, b) {
        final nameA = (a['pretty_name'] ?? a['name']).toLowerCase();
        final nameB = (b['pretty_name'] ?? b['name']).toLowerCase();
        return nameA.compareTo(nameB);
      });
      setState(() {
        _allSubstances = substances;
        _filteredSubstances = substances;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading catalog: $e')));
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredSubstances = _allSubstances.where((sub) {
        final name = (sub['pretty_name'] ?? sub['name'] ?? '')
            .toString()
            .toLowerCase();
        final aliases =
            (sub['aliases'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final matchesSearch =
            name.contains(_searchQuery.toLowerCase()) ||
            aliases.any(
              (alias) =>
                  alias.toLowerCase().contains(_searchQuery.toLowerCase()),
            );

        final categories =
            (sub['categories'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final matchesCategory =
            _selectedCategories.isEmpty ||
            _selectedCategories.any(
              (selected) => categories.any(
                (cat) => cat.toLowerCase() == selected.toLowerCase(),
              ),
            );

        final matchesCommon =
            !_showCommonOnly ||
            categories.any((cat) => cat.toLowerCase() == 'common');

        return matchesSearch && matchesCategory && matchesCommon;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? UIColors.darkNeonViolet
        : UIColors.lightAccentIndigo;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark
            ? UIColors.darkBackground
            : UIColors.lightBackground,
        appBar: CatalogAppBar(isDark: isDark, accentColor: accentColor),
        drawer: const DrawerMenu(),
        body: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? UIColors.darkBackground
          : UIColors.lightBackground,
      appBar: CatalogAppBar(isDark: isDark, accentColor: accentColor),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          CatalogSearchFilters(
            searchController: _searchController,
            searchQuery: _searchQuery,
            selectedCategories: _selectedCategories,
            showCommonOnly: _showCommonOnly,
            isDark: isDark,
            accentColor: accentColor,
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
          Expanded(
            child: _filteredSubstances.isEmpty
                ? CatalogEmptyState(isDark: isDark)
                : AnimatedSubstanceList(
                    substances: _filteredSubstances,
                    isDark: isDark,
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
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
      backgroundColor: Colors.transparent,
      builder: (context) => SubstanceDetailsSheet(
        substance: substance,
        onAddStockpile: _showAddStockpileSheet,
      ),
    );
  }
}
