import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/log_entry_model.dart';

final user_id = '2';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<LogEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('drug_use')
          .select('*')
          .eq('user_id', user_id); // Filter by user_id
      print('Response: $response'); // Debug: Print the full response
      final data = response as List<dynamic>;
      print('Fetched data: $data'); // Debug: Print raw data
      _entries = data.map((json) {
        try {
          return LogEntry.fromJson(json);
        } catch (e) {
          print('Error parsing entry: $json, error: $e'); // Debug: Print parsing errors
          return null;
        }
      }).where((entry) => entry != null).cast<LogEntry>().toList();
      print('Parsed entries: ${_entries.length}'); // Debug: Print number of entries
    } catch (e) {
      print('Error fetching data: $e'); // Debug: Print fetch errors
      // Optionally show a snackbar or error message
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

    // Basic summary: Count substances (keep for potential future use)
    final substanceCounts = <String, int>{};
    for (final entry in _entries) {
      substanceCounts[entry.substance] = (substanceCounts[entry.substance] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total Entries: ${_entries.length}'),
            // Removed charts; add text summaries or lists here if needed
          ],
        ),
      ),
    );
  }
}