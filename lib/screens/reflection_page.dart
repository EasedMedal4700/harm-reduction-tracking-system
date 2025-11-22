import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/log_entry_service.dart';
import '../providers/reflection_provider.dart';
import '../widgets/reflection/reflection_form.dart';
import '../widgets/reflection/reflection_selection.dart';

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final LogEntryService _entryService = LogEntryService();
  List<Map<String, dynamic>> _entries = [];
  bool _isLoading = true;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load entries: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Consumer<ReflectionProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reflect on Recent Entries'),
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            foregroundColor: isDark ? Colors.white : Colors.black87,
            elevation: 0,
            leading: provider.showForm
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => provider.setShowForm(false), // Back button
                )
              : null,
            actions: provider.showForm
              ? [
                  TextButton(
                    onPressed: provider.isSaving
                      ? null
                      : () => provider.save(context),
                    child: provider.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                  ),
                ]
              : null,
          ),
          body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.showForm
              ? ReflectionForm(
                  selectedCount: provider.selectedIds.length,
                  effectiveness: provider.reflection.effectiveness,
                  onEffectivenessChanged: (value) => provider.updateReflection(
                    provider.reflection..effectiveness = value,
                  ),
                  sleepHours: provider.reflection.sleepHours,
                  onSleepHoursChanged: (value) => provider.updateReflection(
                    provider.reflection..sleepHours = value,
                  ),
                  sleepQuality: provider.reflection.sleepQuality,
                  onSleepQualityChanged: (value) => provider.updateReflection(
                    provider.reflection..sleepQuality = value,
                  ),
                  nextDayMood: provider.reflection.nextDayMood,
                  onNextDayMoodChanged: (value) => provider.updateReflection(
                    provider.reflection..nextDayMood = value,
                  ),
                  energyLevel: provider.reflection.energyLevel,
                  onEnergyLevelChanged: (value) => provider.updateReflection(
                    provider.reflection..energyLevel = value,
                  ),
                  sideEffects: provider.reflection.sideEffects,
                  onSideEffectsChanged: (value) => provider.updateReflection(
                    provider.reflection..sideEffects = value,
                  ),
                  postUseCraving: provider.reflection.postUseCraving,
                  onPostUseCravingChanged: (value) => provider.updateReflection(
                    provider.reflection..postUseCraving = value,
                  ),
                  copingStrategies: provider.reflection.copingStrategies,
                  onCopingStrategiesChanged: (value) => provider.updateReflection(
                    provider.reflection..copingStrategies = value,
                  ),
                  copingEffectiveness: provider.reflection.copingEffectiveness,
                  onCopingEffectivenessChanged: (value) => provider.updateReflection(
                    provider.reflection..copingEffectiveness = value,
                  ),
                  overallSatisfaction: provider.reflection.overallSatisfaction,
                  onOverallSatisfactionChanged: (value) => provider.updateReflection(
                    provider.reflection..overallSatisfaction = value,
                  ),
                  notes: provider.reflection.notes,
                  onNotesChanged: (value) => provider.updateReflection(
                    provider.reflection..notes = value,
                  ),
                )
              : ReflectionSelection(
                  entries: _entries,
                  selectedIds: provider.selectedIds,
                  onEntryChanged: provider.toggleEntry, // Use provider method
                  onNext: () => provider.setShowForm(true),
                ),
        );
      },
    );
  }
}