import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tolerance_model.dart';
import '../services/tolerance_service.dart';
import '../services/user_service.dart';
import '../services/tolerance_engine_service.dart';
import '../widgets/system_tolerance_widget.dart';

class ToleranceDashboardPage extends StatefulWidget {
  final String? initialSubstance;

  const ToleranceDashboardPage({super.key, this.initialSubstance});

  @override
  State<ToleranceDashboardPage> createState() => _ToleranceDashboardPageState();
}

class _ToleranceDashboardPageState extends State<ToleranceDashboardPage> {
  bool _isLoadingOptions = true;
  bool _isLoadingMetrics = false;
  int? _userId;
  List<String> _substances = [];
  String? _selectedSubstance;
  String? _errorMessage;

  ToleranceModel? _toleranceModel;
  List<UseEvent> _useEvents = [];
  double _currentTolerance = 0;
  double _daysUntilBaseline = 0;

  // System tolerance data
  SystemToleranceData? _systemToleranceData;
  bool _isLoadingSystemTolerance = false;
  // Debugging per-substance tolerance
  bool _showDebugSubstances = false;
  Map<String, double> _perSubstanceTolerances = {};
  bool _isLoadingPerSubstance = false;

  @override
  void initState() {
    super.initState();
    _loadSubstances();
    _loadSystemTolerance();
  }

  Future<void> _loadSystemTolerance() async {
    setState(() => _isLoadingSystemTolerance = true);
    try {
      final data = await loadSystemToleranceData();
      if (mounted) {
        setState(() {
          _systemToleranceData = data;
          _isLoadingSystemTolerance = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingSystemTolerance = false);
      }
    }
  }

  Future<void> _loadPerSubstanceTolerances() async {
    if (_userId == null) return;
    setState(() => _isLoadingPerSubstance = true);
    try {
      final values = await ToleranceEngineService.computePerSubstanceTolerances(userId: _userId!);
      if (!mounted) return;
      setState(() {
        _perSubstanceTolerances = values;
        _isLoadingPerSubstance = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingPerSubstance = false);
    }
  }

  Future<void> _loadSubstances() async {
    setState(() {
      _isLoadingOptions = true;
      _errorMessage = null;
    });

    try {
      final userId = await UserService.getIntegerUserId();
      final options = await ToleranceService.fetchUserSubstances(userId);

      if (!mounted) return;

      setState(() {
        _userId = userId;
        _substances = options;
        _selectedSubstance = widget.initialSubstance ?? (options.isNotEmpty ? options.first : null);
        _isLoadingOptions = false;
      });

      if (_selectedSubstance != null) {
        await _loadMetrics(_selectedSubstance!);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load your substances.';
        _isLoadingOptions = false;
      });
    }
  }

  Future<void> _loadMetrics(String substance) async {
    if (_userId == null) return;

    setState(() {
      _isLoadingMetrics = true;
      _errorMessage = null;
    });

    final toleranceData = await ToleranceService.fetchToleranceData(substance);
    final useEvents = await ToleranceService.fetchUseEvents(
      substanceName: substance,
      userId: _userId!,
      daysBack: 30,
    );

    if (!mounted) return;

    if (toleranceData == null) {
      setState(() {
        _toleranceModel = null;
        _useEvents = useEvents;
        _currentTolerance = 0;
        _daysUntilBaseline = 0;
        _errorMessage = 'No tolerance data available for $substance.';
        _isLoadingMetrics = false;
      });
      return;
    }

    final now = DateTime.now();
    final currentTolerance = ToleranceCalculator.toleranceScore(
      useEvents: useEvents,
      halfLifeHours: toleranceData.halfLifeHours,
      currentTime: now,
    );
    final daysUntilBaseline = ToleranceCalculator.daysUntilBaseline(
      currentTolerance: currentTolerance,
      toleranceDecayDays: toleranceData.toleranceDecayDays,
    );

    setState(() {
      _toleranceModel = toleranceData;
      _useEvents = useEvents;
      _currentTolerance = currentTolerance;
      _daysUntilBaseline = daysUntilBaseline;
      _isLoadingMetrics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tolerance dashboard'),
        actions: [
          // Debug toggle
          IconButton(
            icon: Icon(_showDebugSubstances ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: () async {
              setState(() => _showDebugSubstances = !_showDebugSubstances);
              if (_showDebugSubstances) {
                await _loadPerSubstanceTolerances();
              }
            },
            tooltip: 'Toggle substance tolerance debug',
          ),
        ],
      ),
      body: _isLoadingOptions
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    key: ValueKey(_selectedSubstance),
                    initialValue: _selectedSubstance,
                    decoration: const InputDecoration(
                      labelText: 'Substance',
                      border: OutlineInputBorder(),
                    ),
                    items: _substances
                        .map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedSubstance = value);
                      if (value != null) {
                        _loadMetrics(value);
                      }
                    },
                  ),
                  if (_substances.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Log entries with substance names to see tolerance insights.',
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (_isLoadingMetrics)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else
                    Expanded(
                      child: _buildContent(),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildContent() {
    if (_selectedSubstance == null) {
      return const Center(child: Text('Select a substance to view tolerance data.'));
    }

    return ListView(
      children: [
        // System-wide tolerance section
        if (_isLoadingSystemTolerance)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_systemToleranceData != null)
          buildSystemToleranceSection(_systemToleranceData!),
        const SizedBox(height: 16),
        
        // Per-substance tolerance section
        if (_errorMessage != null)
          Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_errorMessage!),
            ),
          ),
        if (_toleranceModel != null) ...[
          _buildSummaryCard(),
          _buildStatsCard(),
          if (_toleranceModel!.notes.isNotEmpty) _buildNotesCard(),
        ],
        _buildRecentUsesCard(),
        // Debug per-substance tolerance table
        if (_showDebugSubstances) ...[
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DEBUG: Per-substance tolerance', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_isLoadingPerSubstance)
                    const Center(child: CircularProgressIndicator())
                  else if (_perSubstanceTolerances.isEmpty)
                    const Text('No data')
                  else
                    ..._perSubstanceTolerances.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: const TextStyle(fontSize: 14)),
                              Text('${e.value.toStringAsFixed(1)} %', style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current tolerance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${_currentTolerance.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (_currentTolerance / 100).clamp(0.0, 1.0),
            ),
            const SizedBox(height: 8),
            Text(
              _toleranceLabel(_currentTolerance),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final model = _toleranceModel!;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Key metrics', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildMetricRow('Half-life', '${model.halfLifeHours} h'),
            _buildMetricRow('Tolerance decay', '${model.toleranceDecayDays} days'),
            _buildMetricRow('Days until baseline', _daysUntilBaseline.toStringAsFixed(1)),
            _buildMetricRow('Recent uses (30 d)', _useEvents.length.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              _toleranceModel!.notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentUsesCard() {
    if (_useEvents.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No recent use events recorded for $_selectedSubstance.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final recentEvents = _useEvents.take(5).toList();
    final formatter = DateFormat('MMM d · HH:mm');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent use events', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...recentEvents.map(
              (event) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(formatter.format(event.timestamp)),
                subtitle: Text('${event.dose.toStringAsFixed(1)} units'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _toleranceLabel(double tolerance) {
    if (tolerance < 10) return 'Baseline';
    if (tolerance < 30) return 'Low';
    if (tolerance < 50) return 'Moderate';
    if (tolerance < 70) return 'High';
    return 'Very high';
  }
}
