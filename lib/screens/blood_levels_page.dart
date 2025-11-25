import 'package:flutter/material.dart';
import '../services/blood_levels_service.dart';
import '../widgets/blood_levels/level_card.dart';
import '../widgets/blood_levels/system_overview_card.dart';
import '../widgets/blood_levels/risk_assessment_card.dart';
import '../widgets/blood_levels/filter_panel.dart';
import '../widgets/blood_levels/metabolism_timeline_card.dart';
import '../widgets/blood_levels/metabolism_timeline_controls.dart';
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
  
  // Time machine state
  DateTime _selectedTime = DateTime.now();
  
  // Filter state
  final Set<String> _includedDrugs = {};
  final Set<String> _excludedDrugs = {};
  bool _showFilters = false;
  
  // Timeline state
  int _chartHoursBack = 24;
  int _chartHoursForward = 24;
  bool _chartAdaptiveScale = true;
  bool _showTimeline = true;

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
      final levels = await _service.calculateLevels(referenceTime: _selectedTime);
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
  
  /// Get filtered levels based on include/exclude lists
  Map<String, DrugLevel> _getFilteredLevels() {
    if (_includedDrugs.isEmpty && _excludedDrugs.isEmpty) {
      return _levels;
    }
    
    return Map.fromEntries(
      _levels.entries.where((entry) {
        final drugName = entry.key;
        // If included list is not empty, only show included drugs
        if (_includedDrugs.isNotEmpty && !_includedDrugs.contains(drugName)) {
          return false;
        }
        // Always exclude drugs in excluded list
        if (_excludedDrugs.contains(drugName)) {
          return false;
        }
        return true;
      }),
    );
  }
  
  /// Get list of all drug names from current data
  List<String> _getAvailableDrugs() {
    return _levels.keys.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTimeDisplay(),
        actions: [
          // Time machine button
          IconButton(
            icon: Icon(_selectedTime.difference(DateTime.now()).abs().inMinutes < 5 
              ? Icons.access_time 
              : Icons.history),
            tooltip: 'Time Machine',
            onPressed: _showTimeMachine,
          ),
          // Filter button
          IconButton(
            icon: Badge(
              label: Text('${_includedDrugs.length + _excludedDrugs.length}'),
              isLabelVisible: _includedDrugs.isNotEmpty || _excludedDrugs.isNotEmpty,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Filters',
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
          // Timeline button
          IconButton(
            icon: Icon(_showTimeline ? Icons.timeline : Icons.timeline_outlined),
            tooltip: 'Metabolism Timeline',
            onPressed: () => setState(() => _showTimeline = !_showTimeline),
          ),
          // Refresh button
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
  
  Widget _buildTimeDisplay() {
    final isNow = _selectedTime.difference(DateTime.now()).abs().inMinutes < 5;
    
    if (isNow) {
      return const Text('Blood Levels');
    }
    
    final diff = _selectedTime.difference(DateTime.now());
    final hoursAgo = (diff.inMinutes / 60.0).abs().round();
    final label = diff.isNegative ? '$hoursAgo hours ago' : '$hoursAgo hours future';
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Blood Levels', style: TextStyle(fontSize: 16)),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
  
  Future<void> _showTimeMachine() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (date == null) return;
    
    if (!mounted) return;
    
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    
    if (time == null) return;
    
    setState(() {
      _selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    
    _loadLevels();
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Filter panel (collapsible)
        if (_showFilters) _buildFilterPanel(),
        
        // Main content
        Expanded(
          child: _buildMainContent(),
        ),
      ],
    );
  }
  
  Widget _buildFilterPanel() {
    return FilterPanel(
      availableDrugs: _getAvailableDrugs(),
      includedDrugs: _includedDrugs,
      excludedDrugs: _excludedDrugs,
      onIncludeChanged: (drug, selected) {
        setState(() {
          if (selected) {
            _includedDrugs.add(drug);
            _excludedDrugs.remove(drug);
          } else {
            _includedDrugs.remove(drug);
          }
        });
      },
      onExcludeChanged: (drug, selected) {
        setState(() {
          if (selected) {
            _excludedDrugs.add(drug);
            _includedDrugs.remove(drug);
          } else {
            _excludedDrugs.remove(drug);
          }
        });
      },
      onClearAll: () {
        setState(() {
          _includedDrugs.clear();
          _excludedDrugs.clear();
        });
      },
    );
  }
  
  Widget _buildMainContent() {
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

    final filteredLevels = _getFilteredLevels();
    
    if (filteredLevels.isEmpty) {
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
            if (_includedDrugs.isNotEmpty || _excludedDrugs.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Try adjusting filters',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      );
    }

    final sorted = filteredLevels.values.toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));

    return ListView(
      children: [
        SystemOverviewCard(levels: filteredLevels, allLevels: _levels),
        RiskAssessmentCard(levels: filteredLevels),
        const SizedBox(height: 16),
        
        // Metabolism Timeline section
        if (_showTimeline) ...[
          _buildTimelineSection(filteredLevels),
          const SizedBox(height: 16),
        ],
        
        ...sorted.map((level) => LevelCard(level: level)),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildTimelineSection(Map<String, DrugLevel> levels) {
    if (levels.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.timeline_outlined, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Select a substance to view metabolism timeline',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
    
    // Pass ALL filtered drugs to show multiple lines on the graph
    final allDrugs = levels.values.toList();
    
    return Column(
      children: [
        // Timeline controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MetabolismTimelineControls(
            hoursBack: _chartHoursBack,
            hoursForward: _chartHoursForward,
            adaptiveScale: _chartAdaptiveScale,
            onHoursBackChanged: (val) => setState(() => _chartHoursBack = val),
            onHoursForwardChanged: (val) => setState(() => _chartHoursForward = val),
            onAdaptiveScaleChanged: (val) => setState(() => _chartAdaptiveScale = val),
            onPresetSelected: (back, forward) {
              setState(() {
                _chartHoursBack = back;
                _chartHoursForward = forward;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        
        // Timeline graph - now showing ALL drugs
        MetabolismTimelineCard(
          drugLevels: allDrugs,
          hoursBack: _chartHoursBack,
          hoursForward: _chartHoursForward,
          adaptiveScale: _chartAdaptiveScale,
          referenceTime: _selectedTime,
        ),
      ],
    );
  }
}
