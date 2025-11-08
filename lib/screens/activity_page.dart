import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../services/activity_service.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final ActivityService _service = ActivityService();
  Map<String, dynamic> _activity = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchActivity();
  }

  Future<void> _fetchActivity() async {
    try {
      final data = await _service.fetchRecentActivity();
      setState(() {
        _activity = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load activity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Activity'),
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSection('Recent Drug Use', _activity['entries'] ?? [], (entry) => '${entry['name']} - ${entry['dose']} at ${entry['place']}'),
              _buildSection('Recent Cravings', _activity['cravings'] ?? [], (craving) => 'Craving level: ${craving['intensity']} - ${craving['notes']}'), // Change to 'intensity'
              _buildSection('Recent Reflections', _activity['reflections'] ?? [], (reflection) => 'Notes: ${reflection['notes']}'),
            ],
          ),
    );
  }

  Widget _buildSection(String title, List items, String Function(dynamic) itemText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((item) => Card(
          child: ListTile(
            title: Text(itemText(item)),
            subtitle: Text(_formatDate(item)), // Use a helper method
          ),
        )),
        if (items.isEmpty) const Text('No recent activity.'),
        const SizedBox(height: 16),
      ],
    );
  }

  String _formatDate(dynamic item) {
    final dateStr = item['time'] ?? item['created_at'] ?? item['start_time'];
    if (dateStr == null) return 'No date available';
    try {
      return DateTime.parse(dateStr).toLocal().toString();
    } catch (e) {
      return 'Invalid date';
    }
  }
}