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
    final updatedFavorite = await _service.toggleFavorite(entry);
    if (!mounted) return;
    setState(() {
      final index = _catalog.indexWhere((item) => item.name == entry.name);
      if (index != -1) {
        _catalog[index] = _catalog[index].copyWith(favorite: updatedFavorite);
      }
      _filtered = _applyFilters(_searchController.text);
    });
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
    
    // Filter archived if not showing them
    if (!_showArchived) {
      results = results.where((e) => !e.archived).toList();
    }
    
    return results;
  }

  void _showAddStockpileSheet(DrugCatalogEntry entry) async {
    final substanceDetails = await _substanceRepo.getSubstanceDetails(entry.name);
    
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
      setState(() {}); // Refresh to show updated stockpile
    }
  }

  String _selectPrimaryCategory(List<String> categories) {
    if (categories.isEmpty) return 'Unknown';
    
    // Filter out non-descriptive categories
    final filtered = categories.where((cat) =>
        cat.toLowerCase() != 'tentative' &&
        cat.toLowerCase() != 'research chemical' &&
        cat.toLowerCase() != 'habit-forming' &&
        cat.toLowerCase() != 'common' &&
        cat.toLowerCase() != 'inactive').toList();

    if (filtered.isEmpty) return 'Unknown';

    // Use priority list from DrugCategories (higher in list = more important)
    for (final priorityCategory in DrugCategories.categoryPriority) {
      if (filtered.any((cat) => cat.toLowerCase() == priorityCategory.toLowerCase())) {
        return priorityCategory;
      }
    }
    
    // If no match found in priority list, return first filtered category
    return filtered.first;
  }

  void _showDayUsageDetails(String substanceName, int weekdayIndex, String dayName, bool isDark, Color accentColor) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Fetch all entries for this substance
      final response = await Supabase.instance.client
          .from('drug_use')
          .select('start_time, dose, route, is_medical_purpose')
          .eq('name', substanceName)
          .order('start_time', ascending: false);

      final entries = (response as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList();

      // Filter entries for the selected weekday (with 5am cutoff logic)
      final filteredEntries = entries.where((entry) {
        final startTime = DateTime.tryParse(entry['start_time']?.toString() ?? '');
        if (startTime == null) return false;

        // Apply 5am cutoff for non-medical use
        final isMedical = entry['is_medical_purpose'] == true || entry['is_medical_purpose'] == 1;
        DateTime adjustedTime = startTime;
        
        if (!isMedical && startTime.hour < 5) {
          adjustedTime = startTime.subtract(const Duration(hours: 5));
        }

        return adjustedTime.weekday % 7 == weekdayIndex;
      }).toList();

      if (!mounted) return;

      // Close loading dialog
      Navigator.pop(context);

      // Show bottom sheet with results
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildDayUsageSheet(
          substanceName,
          dayName,
          filteredEntries,
          isDark,
          accentColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load usage data: $e')),
      );
    }
  }

  Widget _buildDayUsageSheet(
    String substanceName,
    String dayName,
    List<Map<String, dynamic>> entries,
    bool isDark,
    Color accentColor,
  ) {
    // Show first 10 by default, with option to see all
    final showAll = entries.length <= 10;
    final displayEntries = showAll ? entries : entries.take(10).toList();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radiusExtraLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: ThemeConstants.space12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(ThemeConstants.space20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ThemeConstants.space8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withValues(alpha: 0.7)],
                        ),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: ThemeConstants.iconMedium,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            substanceName,
                            style: TextStyle(
                              fontSize: ThemeConstants.fontLarge,
                              fontWeight: ThemeConstants.fontBold,
                              color: isDark ? UIColors.darkText : UIColors.lightText,
                            ),
                          ),
                          Text(
                            '$dayName Usage History',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontMedium,
                              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                    ),
                  ],
                ),
                SizedBox(height: ThemeConstants.space8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space12,
                    vertical: ThemeConstants.space8,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${entries.length} ${entries.length == 1 ? 'use' : 'uses'} on ${dayName}s',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: ThemeConstants.fontSemiBold,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // List of entries
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: ThemeConstants.space20),
              itemCount: displayEntries.length,
              itemBuilder: (context, index) {
                final entry = displayEntries[index];
                final startTime = DateTime.parse(entry['start_time']);
                final dose = entry['dose']?.toString() ?? 'Unknown';
                final route = entry['route']?.toString() ?? 'Unknown';
                final isMedical = entry['is_medical_purpose'] == true || entry['is_medical_purpose'] == 1;

                return Container(
                  margin: EdgeInsets.only(bottom: ThemeConstants.space8),
                  padding: EdgeInsets.all(ThemeConstants.space12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? UIColors.darkBackground.withValues(alpha: 0.5)
                        : UIColors.lightBackground,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    border: Border.all(
                      color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Time
                      Container(
                        width: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('HH:mm').format(startTime),
                              style: TextStyle(
                                fontSize: ThemeConstants.fontMedium,
                                fontWeight: ThemeConstants.fontBold,
                                color: accentColor,
                              ),
                            ),
                            Text(
                              DateFormat('MMM d').format(startTime),
                              style: TextStyle(
                                fontSize: ThemeConstants.fontXSmall,
                                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: ThemeConstants.space12),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dose,
                              style: TextStyle(
                                fontSize: ThemeConstants.fontMedium,
                                fontWeight: ThemeConstants.fontSemiBold,
                                color: isDark ? UIColors.darkText : UIColors.lightText,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.route,
                                  size: 12,
                                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                                ),
                                SizedBox(width: ThemeConstants.space4),
                                Text(
                                  route,
                                  style: TextStyle(
                                    fontSize: ThemeConstants.fontSmall,
                                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                                  ),
                                ),
                                if (isMedical) ...[
                                  SizedBox(width: ThemeConstants.space8),
                                  Icon(
                                    Icons.medical_services,
                                    size: 12,
                                    color: UIColors.lightAccentGreen,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // "Show All" button if more than 10
          if (!showAll) ...[
            Padding(
              padding: EdgeInsets.all(ThemeConstants.space16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDayUsageDetails(substanceName, 0, dayName, isDark, accentColor);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space20,
                    vertical: ThemeConstants.space12,
                  ),
                ),
                child: Text('Show All ${entries.length} Uses'),
              ),
            ),
          ],
          
          SizedBox(height: ThemeConstants.space16),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadCatalog, child: const Text('Retry')),
          ],
        ),
      );
    }
    
    if (_filtered.isEmpty) {
      return Center(
        child: Text(
          _showArchived ? 'No substances found' : 'No active substances in your library',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? UIColors.darkTextSecondary
                : UIColors.lightTextSecondary,
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(ThemeConstants.space16),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        return _buildSubstanceCard(_filtered[index]);
      },
    );
  }

  Widget _buildSubstanceCard(DrugCatalogEntry entry) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryCategory = _selectPrimaryCategory(entry.categories);
    final categoryColor = DrugCategoryColors.colorFor(primaryCategory);
    final categoryIcon = DrugCategories.categoryIconMap[primaryCategory] ?? Icons.science;

    return Container(
      margin: EdgeInsets.only(bottom: ThemeConstants.space16),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: categoryColor,
              radius: ThemeConstants.radiusLarge,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
              border: Border.all(color: UIColors.lightBorder),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.all(ThemeConstants.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with name and actions
                Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                        boxShadow: UIColors.createNeonGlow(categoryColor, intensity: 0.3),
                      ),
                      child: Icon(categoryIcon, color: Colors.white, size: ThemeConstants.iconMedium),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                    // Name and category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.name,
                            style: TextStyle(
                              fontSize: ThemeConstants.fontLarge,
                              fontWeight: ThemeConstants.fontBold,
                              color: isDark ? UIColors.darkText : UIColors.lightText,
                            ),
                          ),
                          SizedBox(height: ThemeConstants.space4),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space8,
                              vertical: ThemeConstants.space4,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [categoryColor.withValues(alpha: 0.2), categoryColor.withValues(alpha: 0.1)],
                              ),
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                              border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              primaryCategory,
                              style: TextStyle(
                                fontSize: ThemeConstants.fontXSmall,
                                fontWeight: ThemeConstants.fontSemiBold,
                                color: categoryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Favorite button
                    IconButton(
                      icon: Icon(
                        entry.favorite ? Icons.favorite : Icons.favorite_border,
                        color: entry.favorite ? UIColors.lightAccentRed : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                      ),
                      onPressed: () => _toggleFavorite(entry),
                    ),
                    // Archive button
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                      ),
                      onSelected: (value) {
                        if (value == 'archive') {
                          _toggleArchive(entry);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'archive',
                          child: Row(
                            children: [
                              Icon(entry.archived ? Icons.unarchive : Icons.archive),
                              SizedBox(width: ThemeConstants.space8),
                              Text(entry.archived ? 'Unarchive' : 'Archive'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ThemeConstants.space16),
                
                // Stats grid
                _buildStatsGrid(entry, isDark),
                
                SizedBox(height: ThemeConstants.space16),
                
                // Usage days
                _buildUsageDays(entry, isDark, categoryColor),
              ],
            ),
          ),
          
          // Stockpile section
          FutureBuilder<StockpileItem?>(
            future: _stockpileRepo.getStockpile(entry.name),
            builder: (context, snapshot) {
              final stockpile = snapshot.data;
              
              return Container(
                padding: EdgeInsets.all(ThemeConstants.space12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: stockpile != null
                          ? _buildStockpileInfo(stockpile, isDark, categoryColor)
                          : Text(
                              'No stockpile tracked',
                              style: TextStyle(
                                fontSize: ThemeConstants.fontSmall,
                                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                              ),
                            ),
                    ),
                    SizedBox(width: ThemeConstants.space8),
                    ElevatedButton.icon(
                      onPressed: () => _showAddStockpileSheet(entry),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(stockpile != null ? 'Add More' : 'Track'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: categoryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space12,
                          vertical: ThemeConstants.space8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DrugCatalogEntry entry, bool isDark) {
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryColor = isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary;

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Total Uses',
            '${entry.totalUses}',
            Icons.repeat,
            textColor,
            secondaryColor,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Avg Dose',
            '${entry.avgDose.toStringAsFixed(1)}mg',
            Icons.science_outlined,
            textColor,
            secondaryColor,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Last Used',
            _formatLastUsed(entry.lastUsed),
            Icons.schedule,
            textColor,
            secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color textColor, Color secondaryColor) {
    return Column(
      children: [
        Icon(icon, size: 20, color: secondaryColor),
        SizedBox(height: ThemeConstants.space4),
        Text(
          value,
          style: TextStyle(
            fontSize: ThemeConstants.fontMedium,
            fontWeight: ThemeConstants.fontBold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildUsageDays(DrugCatalogEntry entry, bool isDark, Color accentColor) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxCount = entry.weekdayUsage.counts.reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
            SizedBox(width: ThemeConstants.space4),
            Text(
              'Weekly Usage',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight: ThemeConstants.fontSemiBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            SizedBox(width: ThemeConstants.space4),
            Text(
              '(Tap to see times)',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeConstants.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            final count = entry.weekdayUsage.counts[index];
            final intensity = maxCount > 0 ? count / maxCount : 0.0;
            final isMostActive = index == entry.weekdayUsage.mostActive;
            final isLeastActive = index == entry.weekdayUsage.leastActive && count > 0;
            
            return Column(
              children: [
                InkWell(
                  onTap: count > 0 ? () => _showDayUsageDetails(entry.name, index, days[index], isDark, accentColor) : null,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? accentColor.withValues(alpha: 0.2 + (intensity * 0.6))
                          : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                      border: Border.all(
                        color: isMostActive
                            ? accentColor
                            : (isLeastActive ? accentColor.withValues(alpha: 0.5) : Colors.transparent),
                        width: isMostActive ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        count > 0 ? '$count' : '',
                        style: TextStyle(
                          fontSize: ThemeConstants.fontXSmall,
                          fontWeight: ThemeConstants.fontBold,
                          color: count > 0 ? accentColor : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ThemeConstants.space4),
                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(height: ThemeConstants.space8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Most: ${days[entry.weekdayUsage.mostActive]}',
              style: TextStyle(
                fontSize: ThemeConstants.fontXSmall,
                color: accentColor,
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
            if (entry.weekdayUsage.counts[entry.weekdayUsage.leastActive] > 0)
              Text(
                'Least: ${days[entry.weekdayUsage.leastActive]}',
                style: TextStyle(
                  fontSize: ThemeConstants.fontXSmall,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockpileInfo(StockpileItem stockpile, bool isDark, Color accentColor) {
    final percentage = stockpile.getPercentage();
    final isLow = stockpile.isLow();
    final isEmpty = stockpile.isEmpty();
    
    Color statusColor;
    if (isEmpty) {
      statusColor = UIColors.lightAccentRed;
    } else if (isLow) {
      statusColor = UIColors.lightAccentAmber;
    } else {
      statusColor = UIColors.lightAccentGreen;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.inventory_2, size: 16, color: statusColor),
            SizedBox(width: ThemeConstants.space4),
            Text(
              '${stockpile.currentAmountMg.toStringAsFixed(1)}mg remaining',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight: ThemeConstants.fontMediumWeight,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeConstants.space4),
        ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall / 2),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            minHeight: 4,
          ),
        ),
        SizedBox(height: ThemeConstants.space4),
        Text(
          '${percentage.toStringAsFixed(0)}% of ${stockpile.totalAddedMg.toStringAsFixed(0)}mg',
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  String _formatLastUsed(DateTime? lastUsed) {
    if (lastUsed == null) return 'Never';
    
    final now = DateTime.now();
    final diff = now.difference(lastUsed);
    
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      appBar: AppBar(
        title: const Text('Personal Library'),
        backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_showArchived ? Icons.archive : Icons.archive_outlined),
            onPressed: () {
              setState(() {
                _showArchived = !_showArchived;
                _filtered = _applyFilters(_searchController.text);
              });
            },
            tooltip: _showArchived ? 'Hide Archived' : 'Show Archived',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCatalog,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          // Summary stats banner
          if (!_loading && _error == null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ThemeConstants.space16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [UIColors.darkSurface, UIColors.darkSurface.withValues(alpha: 0.8)]
                      : [UIColors.lightSurface, UIColors.lightSurface.withValues(alpha: 0.9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSummaryItem(
                        'Total Uses',
                        '$_totalUses',
                        Icons.bar_chart,
                        isDark,
                      ),
                      _buildSummaryItem(
                        'Active Substances',
                        '${_catalog.where((e) => !e.archived).length}',
                        Icons.science,
                        isDark,
                      ),
                      _buildSummaryItem(
                        'Avg Uses',
                        _avgUses.toStringAsFixed(1),
                        Icons.trending_up,
                        isDark,
                      ),
                    ],
                  ),
                  SizedBox(height: ThemeConstants.space12),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space12,
                      vertical: ThemeConstants.space8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? UIColors.darkBorder.withValues(alpha: 0.3)
                          : UIColors.lightBorder.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 16,
                          color: DrugCategoryColors.colorFor(_mostUsedCategory),
                        ),
                        SizedBox(width: ThemeConstants.space8),
                        Text(
                          'Most Used Category: $_mostUsedCategory',
                          style: TextStyle(
                            fontSize: ThemeConstants.fontSmall,
                            fontWeight: ThemeConstants.fontSemiBold,
                            color: isDark ? UIColors.darkText : UIColors.lightText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // Search bar
          Container(
            padding: EdgeInsets.all(ThemeConstants.space12),
            color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name or category',
                hintStyle: TextStyle(
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? UIColors.darkBackground
                    : UIColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  borderSide: BorderSide(
                    color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          
          // Substance list
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconMedium,
          color: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
        ),
        SizedBox(height: ThemeConstants.space4),
        Text(
          value,
          style: TextStyle(
            fontSize: ThemeConstants.fontLarge,
            fontWeight: ThemeConstants.fontBold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
