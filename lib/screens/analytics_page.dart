import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../models/log_entry_model.dart';
import '../widgets/analytics/analytics_app_bar.dart';
import '../widgets/analytics/analytics_filter_card.dart';
import '../widgets/analytics/metrics_row.dart';
import '../widgets/analytics/use_distribution_card.dart';
import '../widgets/analytics/usage_trends_card.dart';
import '../widgets/analytics/insight_summary_card.dart';
import '../widgets/analytics/recent_activity_list.dart';
import '../widgets/common/filter.dart';
import '../constants/drug_categories.dart';
import '../constants/time_period.dart';
import '../constants/theme_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/error_handler.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<LogEntry> _entries = [];
  bool _isLoading = true;
  AnalyticsService? _service;
  TimePeriod _selectedPeriod = TimePeriod.all;
  List<String> _selectedCategories = [];
  int _selectedTypeIndex = 0;
  List<String> _selectedSubstances = [];
  List<String> _selectedPlaces = [];
  List<String> _selectedRoutes = [];
  List<String> _selectedFeelings = [];
  double _minCraving = 0;
  double _maxCraving = 10;
  String? _errorMessage;
  String? _errorDetails;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _errorDetails = null;
    });

    try {
      _service ??= AnalyticsService();
      final supabase = Supabase.instance.client;
      final entries = await _service!.fetchEntries();
      final substanceResponse = await supabase.from('drug_profiles').select('name, categories');
      final substanceData = substanceResponse as List<dynamic>;
      final substanceToCategory = <String, String>{};

      for (final item in substanceData) {
        final categories = (item['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['Placeholder'];
        final validCategories = categories.where((c) => DrugCategories.categoryPriority.contains(c)).toList();
        final category = validCategories.isNotEmpty
            ? validCategories.reduce(
                (a, b) => DrugCategories.categoryPriority.indexOf(a) < DrugCategories.categoryPriority.indexOf(b) ? a : b,
              )
            : 'Placeholder';
        substanceToCategory[(item['name'] as String).toLowerCase()] = category;
      }

      _service!.setSubstanceToCategory(substanceToCategory);

      if (!mounted) return;
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
      ErrorHandler.logInfo('AnalyticsPage._fetchData', 'Loaded ${entries.length} entries');
    } catch (e, stackTrace) {
      ErrorHandler.logError('AnalyticsPage._fetchData', e, stackTrace);
      if (!mounted) return;
      setState(() {
        _entries = [];
        _isLoading = false;
        _errorMessage = 'We were unable to load your analytics data.';
        _errorDetails = e.toString();
      });
      ErrorHandler.showErrorDialog(
        context,
        title: 'Analytics Unavailable',
        message: 'Something went wrong while loading analytics.',
        details: e.toString(),
        onRetry: _fetchData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnalyticsAppBar(
        selectedPeriod: _selectedPeriod,
        onPeriodChanged: (period) {
          print('📊 DEBUG: Period changed in AppBar to: ${period.toString()}');
          setState(() => _selectedPeriod = period);
        },
        onExport: () {
          // TODO: Implement export functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export functionality coming soon')),
          );
        },
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_service == null) {
      return _buildErrorState(
        message: 'Analytics service is unavailable.',
        details: _errorDetails,
      );
    }

    // Calculate filtered data
    final periodFilteredEntries = _service!.filterEntriesByPeriod(_entries, _selectedPeriod);
    final categoryTypeFilteredEntries = periodFilteredEntries.where((e) {
      final category = _service!.substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder';
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(category);
      final matchesType = _selectedTypeIndex == 0 ||
          (_selectedTypeIndex == 1 && e.isMedicalPurpose) ||
          (_selectedTypeIndex == 2 && !e.isMedicalPurpose);
      return matchesCategory && matchesType;
    }).toList();
    
    final filteredEntries = categoryTypeFilteredEntries.where((e) {
      final matchesSubstance = _selectedSubstances.isEmpty || _selectedSubstances.contains(e.substance);
      final matchesPlace = _selectedPlaces.isEmpty || _selectedPlaces.contains(e.location);
      final matchesRoute = _selectedRoutes.isEmpty || _selectedRoutes.contains(e.route);
      final matchesFeeling = _selectedFeelings.isEmpty || e.feelings.any((f) => _selectedFeelings.contains(f));
      final matchesCraving = e.cravingIntensity >= _minCraving && e.cravingIntensity <= _maxCraving;
      return matchesSubstance && matchesPlace && matchesRoute && matchesFeeling && matchesCraving;
    }).toList();

    // Calculate metrics
    final avgPerWeek = _service!.calculateAvgPerWeek(filteredEntries);
    final categoryCounts = _service!.getCategoryCounts(filteredEntries);
    final mostUsed = _service!.getMostUsedCategory(categoryCounts);
    final substanceCounts = _service!.getSubstanceCounts(filteredEntries);
    final mostUsedSubstance = _service!.getMostUsedSubstance(substanceCounts);
    final totalEntries = filteredEntries.length;
    final topCategoryPercent = _service!.getTopCategoryPercent(mostUsed.value, totalEntries).toDouble();
    final selectedPeriodText = _getSelectedPeriodText();
    
    // Get unique values for filters
    final uniqueSubstances = categoryTypeFilteredEntries.map((e) => e.substance).toSet().toList()..sort();
    final uniqueCategories = periodFilteredEntries.map((e) => _service!.substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder').toSet().toList()..sort();
    final uniquePlaces = periodFilteredEntries.map((e) => e.location).toSet().toList()..sort();
    final uniqueRoutes = periodFilteredEntries.map((e) => e.route).toSet().toList()..sort();
    final uniqueFeelings = periodFilteredEntries.expand((e) => e.feelings).toSet().toList()..sort();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 900;
        
        return AnimatedOpacity(
          opacity: 1.0,
          duration: ThemeConstants.animationNormal,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ThemeConstants.homePagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters section
                AnalyticsFilterCard(
                  filterContent: FilterWidget(
                    uniqueCategories: uniqueCategories,
                    uniqueSubstances: uniqueSubstances,
                    selectedCategories: _selectedCategories,
                    onCategoryChanged: (categories) => setState(() => _selectedCategories = categories),
                    selectedSubstances: _selectedSubstances,
                    onSubstanceChanged: (substances) => setState(() => _selectedSubstances = substances),
                    selectedTypeIndex: _selectedTypeIndex,
                    onTypeChanged: (index) => setState(() => _selectedTypeIndex = index),
                    uniquePlaces: uniquePlaces,
                    selectedPlaces: _selectedPlaces,
                    onPlaceChanged: (places) => setState(() => _selectedPlaces = places),
                    uniqueRoutes: uniqueRoutes,
                    selectedRoutes: _selectedRoutes,
                    onRouteChanged: (routes) => setState(() => _selectedRoutes = routes),
                    uniqueFeelings: uniqueFeelings,
                    selectedFeelings: _selectedFeelings,
                    onFeelingChanged: (feelings) => setState(() => _selectedFeelings = feelings),
                    minCraving: _minCraving,
                    maxCraving: _maxCraving,
                    onMinCravingChanged: (value) => setState(() => _minCraving = value),
                    onMaxCravingChanged: (value) => setState(() => _maxCraving = value),
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: (period) {
                      print('📊 DEBUG: Period changed in filter to: ${period.toString()}');
                      setState(() => _selectedPeriod = period);
                    },
                  ),
                ),
                SizedBox(height: ThemeConstants.cardSpacing),
                
                // Metrics row
                MetricsRow(
                  totalEntries: totalEntries,
                  mostUsedSubstance: mostUsedSubstance.key,
                  mostUsedCount: mostUsedSubstance.value,
                  weeklyAverage: avgPerWeek,
                  topCategory: mostUsed.key,
                  topCategoryPercent: topCategoryPercent,
                ),
                SizedBox(height: ThemeConstants.cardSpacing),
                
                // Two-column grid layout for wide screens
                if (isWideScreen)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column
                      Expanded(
                        child: Column(
                          children: [
                            UseDistributionCard(
                              categoryCounts: categoryCounts,
                              substanceCounts: substanceCounts,
                              filteredEntries: filteredEntries,
                              substanceToCategory: _service!.substanceToCategory,
                              onCategoryTapped: (category) {
                                setState(() {
                                  // Filter substances to only show those in the tapped category
                                  _selectedSubstances = filteredEntries
                                      .where((e) => (_service!.substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder') == category)
                                      .map((e) => e.substance)
                                      .toSet()
                                      .toList();
                                });
                              },
                            ),
                            SizedBox(height: ThemeConstants.cardSpacing),
                            InsightSummaryCard(
                              totalEntries: totalEntries,
                              mostUsedCategory: mostUsed.key,
                              weeklyAverage: avgPerWeek,
                              selectedPeriodText: selectedPeriodText,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: ThemeConstants.cardSpacing),
                      // Right column
                      Expanded(
                        child: Column(
                          children: [
                            UsageTrendsCard(
                              filteredEntries: filteredEntries,
                              period: _selectedPeriod,
                              substanceToCategory: _service!.substanceToCategory,
                            ),
                            SizedBox(height: ThemeConstants.cardSpacing),
                            RecentActivityList(
                              entries: filteredEntries,
                              substanceToCategory: _service!.substanceToCategory,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  // Single column layout for narrow screens
                  Column(
                    children: [
                      UseDistributionCard(
                        categoryCounts: categoryCounts,
                        substanceCounts: substanceCounts,
                        filteredEntries: filteredEntries,
                        substanceToCategory: _service!.substanceToCategory,
                        onCategoryTapped: (category) {
                          setState(() {
                            // Filter substances to only show those in the tapped category
                            _selectedSubstances = filteredEntries
                                .where((e) => (_service!.substanceToCategory[e.substance.toLowerCase()] ?? 'Placeholder') == category)
                                .map((e) => e.substance)
                                .toSet()
                                .toList();
                          });
                        },
                      ),
                      SizedBox(height: ThemeConstants.cardSpacing),
                      UsageTrendsCard(
                        filteredEntries: filteredEntries,
                        period: _selectedPeriod,
                        substanceToCategory: _service!.substanceToCategory,
                      ),
                      SizedBox(height: ThemeConstants.cardSpacing),
                      InsightSummaryCard(
                        totalEntries: totalEntries,
                        mostUsedCategory: mostUsed.key,
                        weeklyAverage: avgPerWeek,
                        selectedPeriodText: selectedPeriodText,
                      ),
                      SizedBox(height: ThemeConstants.cardSpacing),
                      RecentActivityList(
                        entries: filteredEntries,
                        substanceToCategory: _service!.substanceToCategory,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getSelectedPeriodText() {
    switch (_selectedPeriod) {
      case TimePeriod.all:
        return 'All Time';
      case TimePeriod.last7Days:
        return 'Last 7 Days';
      case TimePeriod.last7Weeks:
        return 'Last 7 Weeks';
      case TimePeriod.last7Months:
        return 'Last 7 Months';
    }
  }

  Widget _buildErrorState({String? message, String? details}) {
    final resolvedMessage = message ?? _errorMessage ?? 'Something went wrong.';
    final resolvedDetails = details ?? _errorDetails;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              resolvedMessage,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (resolvedDetails != null) ...[
              const SizedBox(height: 12),
              SelectableText(
                resolvedDetails,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
