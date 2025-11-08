import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../models/log_entry_model.dart';
import '../widgets/analytics/analytics_content.dart'; // Add this
import '../constants/drug_categories.dart';
import '../constants/time_period.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/drawer_menu.dart';

final user_id = '2';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<LogEntry> _entries = [];
  bool _isLoading = true;
  late AnalyticsService _service;
  TimePeriod _selectedPeriod = TimePeriod.all;
  List<String> _selectedCategories = [];
  int _selectedTypeIndex = 0;
  List<String> _selectedSubstances = [];
  List<String> _selectedPlaces = [];
  List<String> _selectedRoutes = [];
  List<String> _selectedFeelings = [];
  double _minCraving = 0;
  double _maxCraving = 10;

  @override
  void initState() {
    super.initState();
    _service = AnalyticsService(user_id);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final supabase = Supabase.instance.client;
      _entries = await _service.fetchEntries();
      final substanceResponse = await supabase.from('drug_profiles').select('name, categories');
      final substanceData = substanceResponse as List<dynamic>;
      final substanceToCategory = <String, String>{};
      for (var item in substanceData) {
        final categories = (item['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['Placeholder'];
        final validCategories = categories.where((c) => DrugCategories.categoryPriority.contains(c)).toList();
        final category = validCategories.isNotEmpty
            ? validCategories.reduce((a, b) => DrugCategories.categoryPriority.indexOf(a) < DrugCategories.categoryPriority.indexOf(b) ? a : b)
            : 'Placeholder';
        substanceToCategory[(item['name'] as String).toLowerCase()] = category;
      }
      _service.setSubstanceToCategory(substanceToCategory);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading analytics: $e')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: AnalyticsContent(
        entries: _entries,
        service: _service,
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
      ),
    );
  }
}