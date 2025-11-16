import 'package:flutter/material.dart';
import '../services/blood_levels_service.dart';
import '../widgets/blood_levels/level_card.dart';
import '../widgets/common/drawer_menu.dart';

class BloodLevelsPage extends StatefulWidget {
  const BloodLevelsPage({super.key});

  @override
  State<BloodLevelsPage> createState() => _BloodLevelsPageState();
}

class _BloodLevelsPageState extends State<BloodLevelsPage> {
  final _service = BloodLevelsService();
  Map<String, DrugLevel> _levels = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final levels = await _service.calculateLevels();
      setState(() {
        _levels = levels;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Levels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLevels,
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: _buildBody(),
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
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLevels,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_levels.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.science_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No active substances',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final sorted = _levels.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    return Column(
      children: [
        _buildSummary(),
        Expanded(
          child: ListView.builder(
            itemCount: sorted.length,
            itemBuilder: (context, index) => LevelCard(level: sorted[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    final activeCount = _levels.length;
    final highRisk = _levels.values.where((l) => l.percentage > 20).length;
    final avgPct = _levels.values.isEmpty
        ? 0.0
        : _levels.values.map((l) => l.percentage).reduce((a, b) => a + b) /
            _levels.length;

    Color statusColor = Colors.green;
    String statusText = 'LOW';
    if (highRisk > 0) {
      statusColor = Colors.red;
      statusText = 'HIGH';
    } else if (avgPct > 10) {
      statusColor = Colors.orange;
      statusText = 'MODERATE';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Active', '$activeCount', Icons.medication),
          _buildSummaryItem('Status', statusText, Icons.health_and_safety,
              color: statusColor),
          _buildSummaryItem(
              'Average', '${avgPct.toStringAsFixed(0)}%', Icons.show_chart),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon,
      {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
