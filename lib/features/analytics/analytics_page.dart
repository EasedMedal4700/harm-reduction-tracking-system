// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Analytics page. Uses common components and theme.

import 'package:flutter/material.dart';
import '../../services/analytics_service.dart';
import '../../common/layout/common_drawer.dart';
import '../../models/log_entry_model.dart';
import 'widgets/analytics/analytics_app_bar.dart';
import 'widgets/analytics/analytics_loading_state.dart';
import 'widgets/analytics/analytics_error_state.dart';
import 'widgets/analytics/analytics_layout.dart';
import '../../common/inputs/filter_widget.dart';
import '../../constants/data/drug_categories.dart';
import '../../constants/enums/time_period.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/error_handler.dart';
import '../../utils/time_period_utils.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../repo/substance_repository.dart';

class AnalyticsPage extends StatefulWidget {
  final AnalyticsService? analyticsService;
  final SubstanceRepository? substanceRepository;
  const AnalyticsPage({super.key, this.analyticsService, this.substanceRepository});

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
      _service = widget.analyticsService ?? AnalyticsService();
      _substanceRepo = widget.substanceRepository ?? SubstanceRepository();
      
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

      if (!mounted) return;
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
      ErrorHandler.logInfo(
        'AnalyticsPage._fetchData',
        'Loaded ${entries.length} entries',
      );
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
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AnalyticsAppBar(
        selectedPeriod: _selectedPeriod,
        onPeriodChanged: (period) {
          print('📊 DEBUG: Period changed in AppBar to: ${period.toString()}');
          setState(() => _selectedPeriod = period);
        },
        onExport: () {
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
    if (_isLoading) {
      return const AnalyticsLoadingState();
    }

    if (_errorMessage != null) {
      return AnalyticsErrorState(
        message: _errorMessage!,
        details: _errorDetails,
        onRetry: _fetchData,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchData,
      child: _buildAnalyticsContent(),
    );
  }

  Widget _buildAnalyticsContent() {
    // Calculate filtered data
    final periodFilteredEntries = _service.filterEntriesByPeriod(
      _entries,
      _selectedPeriod,
    );
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

    return AnalyticsLayout(
      filterContent: FilterWidget(
        uniqueCategories: uniqueCategories,
        uniqueSubstances: uniqueSubstances,
        selectedCategories: _selectedCategories,
        onCategoryChanged: (categories) =>
            setState(() => _selectedCategories = categories),
        selectedSubstances: _selectedSubstances,
        onSubstanceChanged: (substances) =>
            setState(() => _selectedSubstances = substances),
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
        onFeelingChanged: (feelings) =>
            setState(() => _selectedFeelings = feelings),
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
        setState(() {
          // Filter logic differs based on context, using simpler approach
          _selectedSubstances = filteredEntries
              .where(
                (e) =>
                    (_service.substanceToCategory[e.substance.toLowerCase()] ??
                        'Placeholder') ==
                    category,
              )
              .map((e) => e.substance)
              .toSet()
              .toList();
        });
      },
      period: _selectedPeriod,
      selectedPeriodText: selectedPeriodText,
      mostUsedCategory: mostUsed.key,
    );
  }
}
