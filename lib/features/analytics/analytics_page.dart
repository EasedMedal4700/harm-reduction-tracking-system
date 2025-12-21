// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Analytics page. Uses common components and theme.

import 'package:flutter/material.dart';
import 'services/analytics_service.dart';
import '../../common/layout/common_drawer.dart';
import '../../models/log_entry_model.dart';
import 'widgets/analytics/analytics_app_bar.dart';
import 'widgets/analytics/analytics_loading_state.dart';
import 'widgets/analytics/analytics_error_state.dart';
import 'widgets/analytics/analytics_layout.dart';
import '../../common/inputs/filter_widget.dart';
import '../../constants/data/drug_categories.dart';
import '../../constants/enums/time_period.dart';
import '../../utils/error_handler.dart';
import '../../utils/time_period_utils.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../repo/substance_repository.dart';
import '../../../../common/logging/app_log.dart';

class AnalyticsPage extends StatefulWidget {
  final AnalyticsService? analyticsService;
  final SubstanceRepository? substanceRepository;
  const AnalyticsPage({
    super.key,
    this.analyticsService,
    this.substanceRepository,
  });

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<LogEntry> _entries = [];
  bool _isLoading = true;
  late final AnalyticsService _service;
  late final SubstanceRepository _substanceRepo;
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
    log.i('[LIFECYCLE] AnalyticsPage initState');
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) {
      log.w('[DATA] _fetchData called but not mounted');
      return;
    }
    log.i('[DATA] _fetchData starting');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _errorDetails = null;
    });

    try {
      _service = widget.analyticsService ?? AnalyticsService();
      _substanceRepo = widget.substanceRepository ?? SubstanceRepository();

      log.d('[DATA] Fetching entries and substance catalog');
      final entries = await _service.fetchEntries();
      final substanceData = await _substanceRepo.fetchSubstancesCatalog();
      final substanceToCategory = <String, String>{};

      for (final item in substanceData) {
        final categories =
            (item['categories'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            ['Placeholder'];
        final validCategories = categories
            .where((c) => DrugCategories.categoryPriority.contains(c))
            .toList();
        final category = validCategories.isNotEmpty
            ? validCategories.reduce(
                (a, b) =>
                    DrugCategories.categoryPriority.indexOf(a) <
                        DrugCategories.categoryPriority.indexOf(b)
                    ? a
                    : b,
              )
            : 'Placeholder';
        substanceToCategory[(item['name'] as String).toLowerCase()] = category;
      }

      _service.setSubstanceToCategory(substanceToCategory);

      if (!mounted) {
        log.w('[DATA] _fetchData completed but not mounted');
        return;
      }
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
      log.i(
        '[DATA] _fetchData completed successfully: ${entries.length} entries loaded',
      );
      ErrorHandler.logInfo(
        'AnalyticsPage._fetchData',
        'Loaded ${entries.length} entries',
      );
    } catch (e, stackTrace) {
      log.e('[DATA] _fetchData failed: $e');
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
    final c = context.colors;
    log.d(
      '[BUILD] AnalyticsPage build (isLoading: $_isLoading, hasError: ${_errorMessage != null}, entries: ${_entries.length})',
    );

    return Scaffold(
      backgroundColor: c.background,
      appBar: AnalyticsAppBar(
        selectedPeriod: _selectedPeriod,
        onPeriodChanged: (period) {
          log.i('[UI] Period changed in AppBar to: ${period.toString()}');
          setState(() => _selectedPeriod = period);
        },
        onExport: () {
          log.i('[UI] Export button pressed');
          // TODO: Implement export functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Export functionality coming soon'),
              backgroundColor: c.info,
            ),
          );
        },
      ),
      drawer: const CommonDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    log.d(
      '[BUILD] _buildBody (isLoading: $_isLoading, hasError: ${_errorMessage != null})',
    );
    if (_isLoading) {
      log.d('[BUILD] Showing loading state');
      return const AnalyticsLoadingState();
    }

    if (_errorMessage != null) {
      log.d('[BUILD] Showing error state');
      return AnalyticsErrorState(
        message: _errorMessage!,
        details: _errorDetails,
        onRetry: _fetchData,
      );
    }

    log.d('[BUILD] Showing analytics content');
    return RefreshIndicator(
      onRefresh: _fetchData,
      child: _buildAnalyticsContent(),
    );
  }

  Widget _buildAnalyticsContent() {
    log.d(
      '[BUILD] _buildAnalyticsContent starting (entries: ${_entries.length}, period: $_selectedPeriod)',
    );
    // Calculate filtered data
    final periodFilteredEntries = _service.filterEntriesByPeriod(
      _entries,
      _selectedPeriod,
    );
    log.d('[DATA] Period filtered entries: ${periodFilteredEntries.length}');
    final categoryTypeFilteredEntries = periodFilteredEntries.where((e) {
      final category =
          _service.substanceToCategory[e.substance.toLowerCase()] ??
          'Placeholder';
      final matchesCategory =
          _selectedCategories.isEmpty || _selectedCategories.contains(category);
      final matchesType =
          _selectedTypeIndex == 0 ||
          (_selectedTypeIndex == 1 && e.isMedicalPurpose) ||
          (_selectedTypeIndex == 2 && !e.isMedicalPurpose);
      return matchesCategory && matchesType;
    }).toList();
    log.d(
      '[DATA] Category/type filtered entries: ${categoryTypeFilteredEntries.length}',
    );

    final filteredEntries = categoryTypeFilteredEntries.where((e) {
      final matchesSubstance =
          _selectedSubstances.isEmpty ||
          _selectedSubstances.contains(e.substance);
      final matchesPlace =
          _selectedPlaces.isEmpty || _selectedPlaces.contains(e.location);
      final matchesRoute =
          _selectedRoutes.isEmpty || _selectedRoutes.contains(e.route);
      final matchesFeeling =
          _selectedFeelings.isEmpty ||
          e.feelings.any((f) => _selectedFeelings.contains(f));
      final matchesCraving =
          e.cravingIntensity >= _minCraving &&
          e.cravingIntensity <= _maxCraving;
      return matchesSubstance &&
          matchesPlace &&
          matchesRoute &&
          matchesFeeling &&
          matchesCraving;
    }).toList();
    log.d('[DATA] Fully filtered entries: ${filteredEntries.length}');

    // Calculate metrics
    final avgPerWeek = _service.calculateAvgPerWeek(filteredEntries);
    final categoryCounts = _service.getCategoryCounts(filteredEntries);
    final mostUsed = _service.getMostUsedCategory(categoryCounts);
    final substanceCounts = _service.getSubstanceCounts(filteredEntries);
    final mostUsedSubstance = _service.getMostUsedSubstance(substanceCounts);
    final totalEntries = filteredEntries.length;
    final topCategoryPercent = _service
        .getTopCategoryPercent(mostUsed.value, totalEntries)
        .toDouble();
    final selectedPeriodText = TimePeriodUtils.getPeriodText(_selectedPeriod);

    log.d(
      '[METRICS] Total entries: $totalEntries, avg/week: $avgPerWeek, most used category: ${mostUsed.key} (${mostUsed.value}), most used substance: ${mostUsedSubstance.key} (${mostUsedSubstance.value})',
    );

    // Get unique values for filters
    final uniqueSubstances =
        categoryTypeFilteredEntries.map((e) => e.substance).toSet().toList()
          ..sort();
    final uniqueCategories =
        periodFilteredEntries
            .map(
              (e) =>
                  _service.substanceToCategory[e.substance.toLowerCase()] ??
                  'Placeholder',
            )
            .toSet()
            .toList()
          ..sort();
    final uniquePlaces =
        periodFilteredEntries.map((e) => e.location).toSet().toList()..sort();
    final uniqueRoutes =
        periodFilteredEntries.map((e) => e.route).toSet().toList()..sort();
    final uniqueFeelings =
        periodFilteredEntries.expand((e) => e.feelings).toSet().toList()
          ..sort();

    log.d(
      '[FILTERS] Unique substances: ${uniqueSubstances.length}, categories: ${uniqueCategories.length}, places: ${uniquePlaces.length}, routes: ${uniqueRoutes.length}, feelings: ${uniqueFeelings.length}',
    );

    return AnalyticsLayout(
      filterContent: FilterWidget(
        uniqueCategories: uniqueCategories,
        uniqueSubstances: uniqueSubstances,
        selectedCategories: _selectedCategories,
        onCategoryChanged: (categories) {
          log.i('[FILTER] Categories changed: $categories');
          setState(() => _selectedCategories = categories);
        },
        selectedSubstances: _selectedSubstances,
        onSubstanceChanged: (substances) {
          log.i('[FILTER] Substances changed: $substances');
          setState(() => _selectedSubstances = substances);
        },
        selectedTypeIndex: _selectedTypeIndex,
        onTypeChanged: (index) {
          log.i('[FILTER] Type index changed: $index');
          setState(() => _selectedTypeIndex = index);
        },
        uniquePlaces: uniquePlaces,
        selectedPlaces: _selectedPlaces,
        onPlaceChanged: (places) {
          log.i('[FILTER] Places changed: $places');
          setState(() => _selectedPlaces = places);
        },
        uniqueRoutes: uniqueRoutes,
        selectedRoutes: _selectedRoutes,
        onRouteChanged: (routes) {
          log.i('[FILTER] Routes changed: $routes');
          setState(() => _selectedRoutes = routes);
        },
        uniqueFeelings: uniqueFeelings,
        selectedFeelings: _selectedFeelings,
        onFeelingChanged: (feelings) {
          log.i('[FILTER] Feelings changed: $feelings');
          setState(() => _selectedFeelings = feelings);
        },
        minCraving: _minCraving,
        maxCraving: _maxCraving,
        onMinCravingChanged: (value) {
          log.i('[FILTER] Min craving changed: $value');
          setState(() => _minCraving = value);
        },
        onMaxCravingChanged: (value) {
          log.i('[FILTER] Max craving changed: $value');
          setState(() => _maxCraving = value);
        },
        selectedPeriod: _selectedPeriod,
        onPeriodChanged: (period) {
          log.i('[FILTER] Period changed in filter: ${period.toString()}');
          setState(() => _selectedPeriod = period);
        },
      ),
      totalEntries: totalEntries,
      mostUsedSubstance: mostUsedSubstance.key,
      mostUsedCount: mostUsedSubstance.value,
      weeklyAverage: avgPerWeek,
      topCategory: mostUsed.key,
      topCategoryPercent: topCategoryPercent,
      categoryCounts: categoryCounts,
      substanceCounts: substanceCounts,
      filteredEntries: filteredEntries,
      substanceToCategory: _service.substanceToCategory,
      onCategoryTapped: (category) {
        log.i('[UI] Category tapped: $category');
        setState(() {
          // Toggle zoom behavior: if already filtered to this category, zoom out
          final currentCategorySubstances = filteredEntries
              .where(
                (e) =>
                    (_service.substanceToCategory[e.substance.toLowerCase()] ??
                        'Placeholder') ==
                    category,
              )
              .map((e) => e.substance)
              .toSet()
              .toList();

          log.d('[UI] Category substances: $currentCategorySubstances');
          log.d('[UI] Current selected substances: $_selectedSubstances');

          // Check if we're already zoomed into this category
          final isAlreadyZoomed =
              _selectedSubstances.isNotEmpty &&
              _selectedSubstances.every(
                (s) => currentCategorySubstances.contains(s),
              ) &&
              currentCategorySubstances.every(
                (s) => _selectedSubstances.contains(s),
              );

          log.d('[UI] Is already zoomed: $isAlreadyZoomed');

          if (isAlreadyZoomed) {
            // Zoom out: clear filter to show all categories
            log.i('[UI] Zooming out from category $category');
            _selectedSubstances = [];
          } else {
            // Zoom in: filter to this category's substances
            log.i(
              '[UI] Zooming into category $category with substances: $currentCategorySubstances',
            );
            _selectedSubstances = currentCategorySubstances;
          }
        });
      },
      period: _selectedPeriod,
      selectedPeriodText: selectedPeriodText,
      mostUsedCategory: mostUsed.key,
    );
  }
}
