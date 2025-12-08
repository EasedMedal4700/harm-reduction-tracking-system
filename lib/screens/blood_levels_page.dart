import 'package:flutter/material.dart';
import '../services/blood_levels_service.dart';
import '../services/onboarding_service.dart';
import '../widgets/blood_levels/filter_panel.dart';
import '../widgets/blood_levels/blood_levels_app_bar.dart';
import '../widgets/blood_levels/blood_levels_loading_state.dart';
import '../widgets/blood_levels/blood_levels_error_state.dart';
import '../widgets/blood_levels/blood_levels_empty_state.dart';
import '../widgets/blood_levels/blood_levels_content.dart';
import '../common/old_common/drawer_menu.dart';
import '../common/old_common/harm_reduction_banner.dart';

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
      appBar: BloodLevelsAppBar(
        selectedTime: _selectedTime,
        onTimeMachinePressed: _showTimeMachine,
        onFilterPressed: () => setState(() => _showFilters = !_showFilters),
        onTimelinePressed: () => setState(() => _showTimeline = !_showTimeline),
        onRefreshPressed: _loadLevels,
        filterCount: _includedDrugs.length + _excludedDrugs.length,
        timelineVisible: _showTimeline,
      ),
      drawer: const DrawerMenu(),
      body: _buildBody(),
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
        // Harm reduction warning banner (dismissible with persistence)
        HarmReductionBanner(
          dismissKey: OnboardingService.bloodLevelsHarmNoticeDismissedKey,
          message: 'Blood level calculations are mathematical estimates based on '
              'pharmacokinetic models. Actual blood concentrations vary significantly '
              'based on individual metabolism, substance purity, route of administration, '
              'and many other factors. Never use these numbers to make dosing decisions.',
        ),
        
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
      return const BloodLevelsLoadingState();
    }

    if (_error != null) {
      return BloodLevelsErrorState(
        error: _error!,
        onRetry: _loadLevels,
      );
    }

    final filteredLevels = _getFilteredLevels();
    
    if (filteredLevels.isEmpty) {
      return BloodLevelsEmptyState(
        hasActiveFilters: _includedDrugs.isNotEmpty || _excludedDrugs.isNotEmpty,
      );
    }

    return BloodLevelsContent(
      filteredLevels: filteredLevels,
      allLevels: _levels,
      showTimeline: _showTimeline,
      chartHoursBack: _chartHoursBack,
      chartHoursForward: _chartHoursForward,
      chartAdaptiveScale: _chartAdaptiveScale,
      referenceTime: _selectedTime,
      onHoursBackChanged: (val) => setState(() => _chartHoursBack = val),
      onHoursForwardChanged: (val) => setState(() => _chartHoursForward = val),
      onAdaptiveScaleChanged: (val) => setState(() => _chartAdaptiveScale = val),
      onPresetSelected: (back, forward) {
        setState(() {
          _chartHoursBack = back;
          _chartHoursForward = forward;
        });
      },
    );
  }
}
