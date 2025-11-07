import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/log_entry_service.dart';
import '../services/user_service.dart';
import '../widgets/reflection/reflection_form.dart';
import '../widgets/reflection/reflection_selection.dart';

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final LogEntryService _entryService = LogEntryService();
  bool _showForm = false;
  List<Map<String, dynamic>> _entries = [];
  Set<String> _selectedIds = {};
  bool _isLoading = true;
  bool _isSaving = false;

  double _effectiveness = 5.0;
  double _sleepHours = 8.0;
  String _sleepQuality = 'Good';
  String _nextDayMood = '';
  String _energyLevel = 'Neutral';
  String _sideEffects = '';
  double _postUseCraving = 5.0;
  String _copingStrategies = '';
  double _copingEffectiveness = 5.0;
  double _overallSatisfaction = 5.0;
  String _notes = '';

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final entries = await _entryService.fetchRecentEntriesRaw();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load entries: $e')),
      );
    }
  }

  Future<int> _getNextReflectionId() async {
    try {
      final response = await Supabase.instance.client
        .from('reflections')
        .select('reflection_id')
        .order('reflection_id', ascending: false)
        .limit(1);
      return response.isNotEmpty ? (response[0]['reflection_id'] as int) + 1 : 1;
    } catch (e) {
      return 1;
    }
  }

  Future<void> _saveReflection() async {
    if (_selectedIds.isEmpty || _notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select entries and add notes')),
      );
      return;
    }

    final nextId = await _getNextReflectionId();

    setState(() => _isSaving = true);
    try {
      await Supabase.instance.client.from('reflections').insert({
        'reflection_id': nextId,
        'user_id': UserService.getCurrentUserId(),
        'effectiveness': _effectiveness.round(),
        'sleep_hours': _sleepHours,
        'sleep_quality': _sleepQuality,
        'next_day_mood': _nextDayMood.isEmpty ? null : _nextDayMood,
        'energy_level': _energyLevel,
        'side_effects': _sideEffects.isEmpty ? null : _sideEffects,
        'post_use_craving': _postUseCraving.round(),
        'coping_strategies': _copingStrategies.isEmpty ? null : _copingStrategies,
        'coping_effectiveness': _copingEffectiveness.round(),
        'overall_satisfaction': _overallSatisfaction.round(),
        'notes': _notes,
        'created_at': DateTime.now().toIso8601String(),
        'related_entries': _selectedIds.map((id) => int.tryParse(id)).where((id) => id != null).toList(),
        'is_simple': false,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reflection saved!')),
      );
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _resetForm() {
    setState(() {
      _showForm = false;
      _selectedIds.clear();
      _effectiveness = 5.0;
      _sleepHours = 8.0;
      _sleepQuality = 'Good';
      _nextDayMood = '';
      _energyLevel = 'Neutral';
      _sideEffects = '';
      _postUseCraving = 5.0;
      _copingStrategies = '';
      _copingEffectiveness = 5.0;
      _overallSatisfaction = 5.0;
      _notes = '';
    });
  }

  void _onEntryChanged(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflect on Recent Entries'),
        actions: _showForm
          ? [
              TextButton(
                onPressed: _isSaving ? null : _saveReflection,
                child: _isSaving ? const CircularProgressIndicator() : const Text('Save'),
              ),
            ]
          : null,
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _showForm
          ? ReflectionForm(
              selectedCount: _selectedIds.length,
              effectiveness: _effectiveness,
              onEffectivenessChanged: (value) => setState(() => _effectiveness = value),
              sleepHours: _sleepHours,
              onSleepHoursChanged: (value) => setState(() => _sleepHours = value),
              sleepQuality: _sleepQuality,
              onSleepQualityChanged: (value) => setState(() => _sleepQuality = value),
              nextDayMood: _nextDayMood,
              onNextDayMoodChanged: (value) => setState(() => _nextDayMood = value),
              energyLevel: _energyLevel,
              onEnergyLevelChanged: (value) => setState(() => _energyLevel = value),
              sideEffects: _sideEffects,
              onSideEffectsChanged: (value) => setState(() => _sideEffects = value),
              postUseCraving: _postUseCraving,
              onPostUseCravingChanged: (value) => setState(() => _postUseCraving = value),
              copingStrategies: _copingStrategies,
              onCopingStrategiesChanged: (value) => setState(() => _copingStrategies = value),
              copingEffectiveness: _copingEffectiveness,
              onCopingEffectivenessChanged: (value) => setState(() => _copingEffectiveness = value),
              overallSatisfaction: _overallSatisfaction,
              onOverallSatisfactionChanged: (value) => setState(() => _overallSatisfaction = value),
              notes: _notes,
              onNotesChanged: (value) => setState(() => _notes = value),
            )
          : ReflectionSelection(
              entries: _entries,
              selectedIds: _selectedIds,
              onEntryChanged: _onEntryChanged, // Pass the function directly
              onNext: () => setState(() => _showForm = true),
            ),
    );
  }
}