import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/log_entry_service.dart';
import '../services/user_service.dart';

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

  // Replace controllers with variables
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

  @override
  void dispose() {
    // Dispose controllers (same as before)
    super.dispose();
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
      return 1; // Fallback
    }
  }

  Future<void> _saveReflection() async {
    if (_selectedIds.isEmpty || _notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select entries and add notes')),
      );
      return;
    }

    final nextId = await _getNextReflectionId(); // Get next ID

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
        : _showForm ? _buildForm() : _buildSelection(),
    );
  }

  Widget _buildSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Recent Entries', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ..._entries.map((entry) => CheckboxListTile(
            key: ValueKey(entry['use_id']),
            title: Text('${entry['name']} - ${entry['dose']}'),
            subtitle: Text('${DateTime.parse(entry['start_time']).toLocal()} - ${entry['place']}'),
            value: _selectedIds.contains(entry['use_id']?.toString()),
            onChanged: (selected) {
              final id = entry['use_id']?.toString();
              if (id == null) return;
              setState(() {
                if (selected ?? false) {
                  _selectedIds.add(id);
                } else {
                  _selectedIds.remove(id);
                }
              });
            },
          )),
          if (_selectedIds.isNotEmpty)
            ElevatedButton(
              onPressed: () => setState(() => _showForm = true),
              child: const Text('Next'),
            ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reflecting on ${_selectedIds.length} selected entries', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          // Effectiveness Slider
          const Text('Effectiveness (1-10)'),
          Slider(
            value: _effectiveness,
            min: 1,
            max: 10,
            divisions: 9,
            label: _effectiveness.round().toString(),
            onChanged: (value) => setState(() => _effectiveness = value),
          ),
          // Sleep Hours
          TextField(
            decoration: const InputDecoration(labelText: 'Sleep Hours'),
            keyboardType: TextInputType.number,
            onChanged: (value) => _sleepHours = double.tryParse(value) ?? 8.0,
          ),
          // Sleep Quality Dropdown
          const Text('Sleep Quality'),
          DropdownButton<String>(
            value: _sleepQuality,
            onChanged: (value) => setState(() => _sleepQuality = value!),
            items: ['Poor', 'Fair', 'Good', 'Excellent'].map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
          ),
          // Next Day Mood
          TextField(
            decoration: const InputDecoration(labelText: 'Next Day Mood'),
            onChanged: (value) => _nextDayMood = value,
          ),
          // Energy Level Dropdown
          const Text('Energy Level'),
          DropdownButton<String>(
            value: _energyLevel,
            onChanged: (value) => setState(() => _energyLevel = value!),
            items: ['Low', 'Neutral', 'High'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          // Side Effects
          TextField(
            decoration: const InputDecoration(labelText: 'Side Effects'),
            onChanged: (value) => _sideEffects = value,
          ),
          // Post Use Craving Slider
          const Text('Post Use Craving (1-10)'),
          Slider(
            value: _postUseCraving,
            min: 1,
            max: 10,
            divisions: 9,
            label: _postUseCraving.round().toString(),
            onChanged: (value) => setState(() => _postUseCraving = value),
          ),
          // Coping Strategies
          TextField(
            decoration: const InputDecoration(labelText: 'Coping Strategies'),
            onChanged: (value) => _copingStrategies = value,
          ),
          // Coping Effectiveness Slider
          const Text('Coping Effectiveness (1-10)'),
          Slider(
            value: _copingEffectiveness,
            min: 1,
            max: 10,
            divisions: 9,
            label: _copingEffectiveness.round().toString(),
            onChanged: (value) => setState(() => _copingEffectiveness = value),
          ),
          // Overall Satisfaction Slider
          const Text('Overall Satisfaction (1-10)'),
          Slider(
            value: _overallSatisfaction,
            min: 1,
            max: 10,
            divisions: 9,
            label: _overallSatisfaction.round().toString(),
            onChanged: (value) => setState(() => _overallSatisfaction = value),
          ),
          // Notes
          TextField(
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
            onChanged: (value) => _notes = value,
          ),
        ],
      ),
    );
  }
}