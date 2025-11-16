import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../models/log_entry_model.dart';
import '../widgets/analytics/analytics_content.dart';
import '../constants/drug_categories.dart';
import '../constants/time_period.dart';
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
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: _isLoading ? null : _fetchData,
          ),
        ],
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

    return AnalyticsContent(
      entries: _entries,
      service: _service!,
      selectedPeriod: _selectedPeriod,
      onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
      selectedCategories: _selectedCategories,
      onCategoryChanged: (categories) => setState(() => _selectedCategories = categories),
      selectedSubstances: _selectedSubstances,
      onSubstanceChanged: (substances) => setState(() => _selectedSubstances = substances),
      selectedTypeIndex: _selectedTypeIndex,
      onTypeChanged: (index) => setState(() => _selectedTypeIndex = index),
      selectedPlaces: _selectedPlaces,
      onPlaceChanged: (places) => setState(() => _selectedPlaces = places),
      selectedRoutes: _selectedRoutes,
      onRouteChanged: (routes) => setState(() => _selectedRoutes = routes),
      selectedFeelings: _selectedFeelings,
      onFeelingChanged: (feelings) => setState(() => _selectedFeelings = feelings),
      minCraving: _minCraving,
      onMinCravingChanged: (value) => setState(() => _minCraving = value),
      maxCraving: _maxCraving,
      onMaxCravingChanged: (value) => setState(() => _maxCraving = value),
    );
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
