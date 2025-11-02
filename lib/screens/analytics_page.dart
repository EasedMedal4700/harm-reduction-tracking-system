import 'package:flutter/material.dart';
import '../services/analytics_service.dart';
import '../models/log_entry_model.dart';
import '../widgets/analytics/time_period_selector.dart';
import '../widgets/analytics/analytics_summary.dart';

final user_id = '2';

enum TimePeriod { all, last7Days, last7Weeks, last7Months }

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
      _entries = await _service.fetchEntries();
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

  List<LogEntry> _getFilteredEntries() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case TimePeriod.last7Days:
        return _entries.where((e) => e.datetime.isAfter(now.subtract(const Duration(days: 7)))).toList();
      case TimePeriod.last7Weeks:
        return _entries.where((e) => e.datetime.isAfter(now.subtract(const Duration(days: 49)))).toList();
      case TimePeriod.last7Months:
        return _entries.where((e) => e.datetime.isAfter(now.subtract(const Duration(days: 210)))).toList();
      case TimePeriod.all:
      default:
        return _entries;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final filteredEntries = _getFilteredEntries();
    final avgPerWeek = _service.calculateAvgPerWeek(filteredEntries);
    final substanceCounts = _service.getSubstanceCounts(filteredEntries);
    final mostUsed = _service.getMostUsedSubstance(substanceCounts);

    final selectedPeriodText = _selectedPeriod == TimePeriod.all ? 'All Time' :
                               _selectedPeriod == TimePeriod.last7Days ? 'Last 7 Days' :
                               _selectedPeriod == TimePeriod.last7Weeks ? 'Last 7 Weeks' : 'Last 7 Months';

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              mostUsedSubstance: mostUsed.key,
              mostUsedCount: mostUsed.value,
              selectedPeriodText: selectedPeriodText,
            ),
          ],
        ),
      ),
    );
  }
}