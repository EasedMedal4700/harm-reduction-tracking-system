import 'package:flutter/material.dart';
import '../repo/substance_repository.dart';
import '../services/analytics_service.dart';
import '../constants/ui_colors.dart';
import '../constants/theme_constants.dart';
import '../constants/drug_categories.dart';
import '../constants/drug_theme.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/catalog/add_stockpile_sheet.dart';
import '../widgets/catalog/substance_card.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading catalog: $e')),
        );
      }
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredSubstances = _allSubstances.where((sub) {
        final name = (sub['pretty_name'] ?? sub['name'] ?? '').toString().toLowerCase();
        final aliases = (sub['aliases'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final matchesSearch = name.contains(_searchQuery.toLowerCase()) ||
            aliases.any((alias) => alias.toLowerCase().contains(_searchQuery.toLowerCase()));

        final categories = (sub['categories'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.any((selected) => categories.any(
                (cat) => cat.toLowerCase() == selected.toLowerCase()));

        final matchesCommon = !_showCommonOnly || 
            categories.any((cat) => cat.toLowerCase() == 'common');

        return matchesSearch && matchesCategory && matchesCommon;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonViolet : UIColors.lightAccentIndigo;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
        appBar: _buildAppBar(context, isDark, accentColor),
        drawer: const DrawerMenu(),
        body: Center(child: CircularProgressIndicator(color: accentColor)),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      appBar: _buildAppBar(context, isDark, accentColor),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          // Search and filter section (pinned at top)
          _buildSearchAndFilters(isDark, accentColor),
          // Scrollable substance list
          Expanded(
            child: _filteredSubstances.isEmpty
                ? _buildEmptyState(isDark)
                : _buildSubstanceList(isDark),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark, Color accentColor) {
    return AppBar(
      backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
      elevation: 0,
      // Automatic hamburger menu icon when drawer is present
      title: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: ThemeConstants.space8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              boxShadow: isDark ? UIColors.createNeonGlow(accentColor, intensity: 0.2) : null,
            ),
            child: Icon(Icons.science_outlined, color: accentColor),
          ),
          Text(
            'Substance Catalog',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isDark, Color accentColor) {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.homePagePadding),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            width: ThemeConstants.borderThin,
          ),
        ),
      ),
      child: Column(
        children: [
          // Glass search bar
          Container(
            decoration: isDark
                ? UIColors.createGlassmorphism(
                    accentColor: accentColor,
                    radius: ThemeConstants.radiusLarge,
                  )
                : BoxDecoration(
                    color: UIColors.lightSurface,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
                    border: Border.all(color: UIColors.lightBorder),
                    boxShadow: UIColors.createSoftShadow(),
                  ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: isDark ? UIColors.darkText : UIColors.lightText,
                fontSize: ThemeConstants.fontMedium,
              ),
              decoration: InputDecoration(
                hintText: 'Search substances…',
                hintStyle: TextStyle(
                  color: isDark
                      ? UIColors.darkTextSecondary
                      : UIColors.lightTextSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: accentColor,
                  size: ThemeConstants.iconMedium,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _applyFilters();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space16,
                  vertical: ThemeConstants.space16,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _applyFilters();
              },
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          // Filter chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', null, isDark, accentColor),
                ...DrugCategories.categoryPriority
                    .take(10)
                    .map((cat) => _buildFilterChip(cat, cat, isDark, accentColor)),
              ],
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          // Common Only toggle card
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space16,
              vertical: ThemeConstants.space12,
            ),
            decoration: isDark
                ? UIColors.createGlassmorphism(
                    accentColor: accentColor,
                    radius: ThemeConstants.radiusMedium,
                  )
                : BoxDecoration(
                    color: UIColors.lightSurface,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    border: Border.all(color: UIColors.lightBorder),
                    boxShadow: UIColors.createSoftShadow(),
                  ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list_rounded,
                  color: _showCommonOnly
                      ? accentColor
                      : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                  size: ThemeConstants.iconSmall,
                ),
                SizedBox(width: ThemeConstants.space12),
                Expanded(
                  child: Text(
                    'Common Only',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontMedium,
                      fontWeight: ThemeConstants.fontSemiBold,
                      color: _showCommonOnly
                          ? accentColor
                          : (isDark ? UIColors.darkText : UIColors.lightText),
                    ),
                  ),
                ),
                Switch(
                  value: _showCommonOnly,
                  onChanged: (value) {
                    setState(() => _showCommonOnly = value);
                    _applyFilters();
                  },
                  activeThumbColor: accentColor,
                  activeTrackColor: accentColor.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? category, bool isDark, Color accentColor) {
    final isSelected = (category == null && _selectedCategories.isEmpty) ||
        (category != null && _selectedCategories.contains(category));
    final chipColor = category != null
        ? DrugCategoryColors.colorFor(category)
        : accentColor;

    return Padding(
      padding: EdgeInsets.only(right: ThemeConstants.space8),
      child: AnimatedContainer(
        duration: ThemeConstants.animationNormal,
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withValues(alpha: isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          border: Border.all(
            color: isSelected
                ? chipColor
                : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
            width: isSelected ? ThemeConstants.borderMedium : ThemeConstants.borderThin,
          ),
          boxShadow: isSelected && isDark
              ? UIColors.createNeonGlow(chipColor, intensity: 0.15)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
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
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.space16,
                vertical: ThemeConstants.space8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (category != null) ...[
                    Icon(
                      DrugCategories.categoryIconMap[category] ?? Icons.science,
                      size: ThemeConstants.iconSmall,
                      color: isSelected
                          ? chipColor
                          : (isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary),
                    ),
                    SizedBox(width: ThemeConstants.space8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: isSelected
                          ? ThemeConstants.fontSemiBold
                          : ThemeConstants.fontMediumWeight,
                      color: isSelected
                          ? chipColor
                          : (isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ThemeConstants.space24),
            decoration: BoxDecoration(
              color: isDark
                  ? UIColors.darkSurfaceLight.withValues(alpha: 0.5)
                  : UIColors.lightDivider,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: ThemeConstants.space24),
          Text(
            'No substances found',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstanceList(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(ThemeConstants.homePagePadding),
      itemCount: _filteredSubstances.length,
      itemBuilder: (context, index) {
        final substance = _filteredSubstances[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 30)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: SubstanceCard(
                  substance: substance,
                  isDark: isDark,
                  onTap: () => _showSubstanceDetails(substance),
                  onAddStockpile: (substanceId, name, substance) =>
                      _showAddStockpileSheet(substanceId, name, substance),
                  getMostActiveDay: (name) => _getMostActiveDay(name),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddStockpileSheet(String substanceId, String substanceName, Map<String, dynamic> substance) async {
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
      final substanceEntries = entries.where((e) => 
        e.substance.toLowerCase() == substanceName.toLowerCase()
      ).toList();
      
      if (substanceEntries.isEmpty) {
        return null;
      }
      
      final mostActive = _analyticsService.getMostActiveDay(substanceEntries, substanceName);
      return mostActive;
    } catch (e) {
      return null;
    }
  }

  void _showSubstanceDetails(Map<String, dynamic> substance) {
    // TODO: Implement detailed bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Details for ${substance['pretty_name'] ?? substance['name']}')),
    );
  }
}
