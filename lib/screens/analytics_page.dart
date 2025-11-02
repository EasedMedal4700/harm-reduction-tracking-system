import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../models/log_entry_model.dart';
import '../widgets/analytics/time_period_selector.dart';
import '../widgets/analytics/analytics_summary.dart';
import '../widgets/analytics/category_pie_chart.dart';
import '../widgets/analytics/usage_trend_chart.dart';
import '../constants/drug_categories.dart';
import '../constants/drug_theme.dart';
import '../constants/time_period.dart'; // Import the enum from here
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _service = AnalyticsService(user_id);
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final supabase = Supabase.instance.client;
      // Fetch entries
      _entries = await _service.fetchEntries();
      // Fetch substance-to-category map from drug_profiles
      final substanceResponse = await supabase.from('drug_profiles').select('name, categories');
      final substanceData = substanceResponse as List<dynamic>;
      final substanceToCategory = <String, String>{};
      for (var item in substanceData) {
        final categories = (item['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['Placeholder'];
        final validCategories = categories.where((c) => DrugCategories.categoryPriority.contains(c)).toList();
        final category = validCategories.isNotEmpty
            ? validCategories.reduce((a, b) => DrugCategories.categoryPriority.indexOf(a) < DrugCategories.categoryPriority.indexOf(b) ? a : b)
            : 'Placeholder';
        substanceToCategory[(item['name'] as String).toLowerCase()] = category; // Use lowercase key
      }
      _service.setSubstanceToCategory(substanceToCategory);
      print('Parsed entries: ${_entries.length}');
    } catch (e) {
      print('Error fetching data: $e');
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
    
    final filteredEntries = _service.filterEntriesByPeriod(_entries, _selectedPeriod);
    final avgPerWeek = _service.calculateAvgPerWeek(filteredEntries);
    final categoryCounts = _service.getCategoryCounts(filteredEntries);
    final mostUsed = _service.getMostUsedCategory(categoryCounts);

    final substanceCounts = _service.getSubstanceCounts(filteredEntries);
    final mostUsedSubstance = _service.getMostUsedSubstance(substanceCounts);

    final totalEntries = filteredEntries.length;
    final topCategoryPercent = _service.getTopCategoryPercent(mostUsed.value, totalEntries);

    final selectedPeriodText = _getSelectedPeriodText();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TimePeriodSelector(
                selectedPeriod: _selectedPeriod,
                onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
              ),
              const SizedBox(height: 16),
              AnalyticsSummary(
                totalEntries: filteredEntries.length,
                avgPerWeek: avgPerWeek,
                mostUsedCategory: mostUsed.key,
                mostUsedCount: mostUsed.value,
                selectedPeriodText: selectedPeriodText,
                mostUsedSubstance: mostUsedSubstance.key,
                mostUsedSubstanceCount: mostUsedSubstance.value,
                topCategoryPercent: topCategoryPercent,
              ),
              const SizedBox(height: 16),
              CategoryPieChart(
                categoryCounts: categoryCounts,
                filteredEntries: filteredEntries,
                substanceToCategory: _service.substanceToCategory,
              ),
              const SizedBox(height: 16),
              UsageTrendChart(filteredEntries: filteredEntries, period: _selectedPeriod, substanceToCategory: _service.substanceToCategory),
            ],
          ),
        ),
      ),
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
}