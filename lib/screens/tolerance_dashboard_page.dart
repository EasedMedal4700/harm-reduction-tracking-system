import 'package:flutter/material.dart';

import '../models/tolerance_model.dart';
import '../services/tolerance_service.dart';
import '../services/user_service.dart';
import '../services/tolerance_engine_service.dart';
import '../utils/tolerance_calculator.dart';
import '../widgets/system_tolerance_widget.dart';
import '../widgets/tolerance/tolerance_summary_card.dart';
import '../widgets/tolerance/tolerance_stats_card.dart';
import '../widgets/tolerance/tolerance_notes_card.dart';
import '../widgets/tolerance/recent_uses_card.dart';
import '../widgets/tolerance/debug_substance_list.dart';

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
      final values = await ToleranceEngineService.computePerSubstanceTolerances(
        userId: _userId!,
      );
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
        _selectedSubstance =
            widget.initialSubstance ??
            (options.isNotEmpty ? options.first : null);
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
            icon: Icon(
              _showDebugSubstances
                  ? Icons.bug_report
                  : Icons.bug_report_outlined,
            ),
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
                          (name) =>
                              DropdownMenuItem(value: name, child: Text(name)),
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
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(child: _buildContent()),
                ],
              ),
            ),
    );
  }

  Widget _buildContent() {
    if (_selectedSubstance == null) {
      return const Center(
        child: Text('Select a substance to view tolerance data.'),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // 1. Current Tolerance (Top priority)
        if (_toleranceModel != null)
          ToleranceSummaryCard(currentTolerance: _currentTolerance),

        const SizedBox(height: 16),

        // 2. System Tolerance
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

        // 3. Key Metrics & Notes
        if (_errorMessage != null)
          Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(_errorMessage!),
            ),
          ),

        if (_toleranceModel != null) ...[
          ToleranceStatsCard(
            toleranceModel: _toleranceModel!,
            daysUntilBaseline: _daysUntilBaseline,
            recentUseCount: _useEvents.length,
          ),
          const SizedBox(height: 16),
          ToleranceNotesCard(notes: _toleranceModel!.notes),
          const SizedBox(height: 16),
        ],

        // 4. Recent Uses
        RecentUsesCard(
          useEvents: _useEvents,
          substanceName: _selectedSubstance,
        ),

        // Debug per-substance tolerance table
        if (_showDebugSubstances) ...[
          const SizedBox(height: 12),
          DebugSubstanceList(
            perSubstanceTolerances: _perSubstanceTolerances,
            isLoading: _isLoadingPerSubstance,
          ),
        ],
      ],
    );
  }
}
