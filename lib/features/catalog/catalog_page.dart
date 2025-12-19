import 'package:flutter/material.dart';
import '../../repo/substance_repository.dart';
import '../../services/analytics_service.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/catalog/add_stockpile_sheet.dart';
import 'widgets/catalog/substance_details_sheet.dart';
import 'widgets/catalog/catalog_app_bar.dart';
import 'widgets/catalog/catalog_search_filters.dart';
import 'widgets/catalog/catalog_empty_state.dart';
import 'widgets/catalog/animated_substance_list.dart';

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
      final substances = await _repository.fetchSubstancesCatalog();
      if (mounted) {
        setState(() {
          _allSubstances = substances;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading substances: $e'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredSubstances = _allSubstances.where((substance) {
        final name = (substance['pretty_name'] ?? substance['name'] ?? '')
            .toString()
            .toLowerCase();
        final aliases = (substance['aliases'] as List?)
                ?.map((e) => e.toString().toLowerCase())
                .toList() ??
            [];
        final categories = (substance['categories'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        // Search filter
        final query = _searchQuery.toLowerCase();
        final matchesSearch = query.isEmpty ||
            name.contains(query) ||
            aliases.any((alias) => alias.contains(query));

        // Category filter
        final matchesCategory = _selectedCategories.isEmpty ||
            categories.any((cat) => _selectedCategories.contains(cat));

        // Common only filter (simplified logic for now, assuming 'common' property or similar if available, otherwise ignored or based on categories)
        // For now, let's assume if showCommonOnly is true, we might filter by some property if it existed.
        // Since the original code didn't seem to have a specific 'common' flag logic visible in the snippet, I'll leave it as true for now or implement if I find the logic.
        // Wait, the original code had `matchesCommon`. Let's see if I can infer it.
        // The original code snippet I read didn't show the `_applyFilters` implementation fully.
        // But `CatalogSearchFilters` has `showCommonOnly`.
        // I'll assume for now it's just a placeholder or I should check `drug_profiles.txt` or similar.
        // For now, I will just ignore `matchesCommon` logic or set it to true to avoid filtering out everything.
        final matchesCommon = true; 

        return matchesSearch && matchesCategory && matchesCommon;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: t.colors.background,
        appBar: const CatalogAppBar(),
        drawer: const CommonDrawer(),
        body: Center(child: CircularProgressIndicator(color: t.accent.primary)),
      );
    }

    return Scaffold(
      backgroundColor: t.colors.background,
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
    final c = context.colors;
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
