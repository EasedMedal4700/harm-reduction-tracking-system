// MIGRATION // Theme: [Not Applicable] // Common: [Not Applicable] // Riverpod: TODO
// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\providers\reflection_provider.dart
import 'package:flutter/material.dart';
import '../../models/reflection_model.dart';
import 'reflection_service.dart';

class ReflectionProvider extends ChangeNotifier {
  final ReflectionService _service;

  ReflectionProvider({ReflectionService? service}) 
      : _service = service ?? ReflectionService();

  Reflection _reflection = Reflection();
  final Set<String> _selectedIds = {};
  bool _showForm = false;
  bool _isSaving = false;
  String entryId = '';
  double effectiveness = 0.0;
  double sleepHours = 0.0;
  String sleepQuality = '';
  String nextDayMood = '';
  String energyLevel = '';
  String sideEffects = '';
  double postUseCraving = 0.0;
  String copingStrategies = '';
  double copingEffectiveness = 0.0;
  double overallSatisfaction = 0.0;

  final TextEditingController notesCtrl = TextEditingController();
  List<String> selectedReflections = [];
  DateTime date = DateTime.now();
  int hour = TimeOfDay.now().hour;
  int minute = TimeOfDay.now().minute;

  Reflection get reflection => _reflection;
  Set<String> get selectedIds => _selectedIds;
  bool get showForm => _showForm;
  bool get isSaving => _isSaving;

  void updateReflection(Reflection newReflection) {
    _reflection = newReflection;
    notifyListeners();
  }

  void toggleEntry(String id, bool selected) {
    if (selected) {
      _selectedIds.add(id);
    } else {
      _selectedIds.remove(id);
    }
    notifyListeners();
  }

  void setShowForm(bool value) {
    _showForm = value;
    notifyListeners();
  }

  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void setNotes(String value) {
    notesCtrl.text = value;
    notifyListeners();
  }

  void setSelectedReflections(List<String> value) {
    selectedReflections = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    date = value;
    notifyListeners();
  }

  void setHour(int value) {
    hour = value;
    notifyListeners();
  }

  void setMinute(int value) {
    minute = value;
    notifyListeners();
  }

  void setEffectiveness(double value) {
    effectiveness = value;
    notifyListeners();
  }

  void setSleepHours(double value) {
    sleepHours = value;
    notifyListeners();
  }

  void setSleepQuality(String value) {
    sleepQuality = value;
    notifyListeners();
  }

  void setNextDayMood(String value) {
    nextDayMood = value;
    notifyListeners();
  }

  void setEnergyLevel(String value) {
    energyLevel = value;
    notifyListeners();
  }

  void setSideEffects(String value) {
    sideEffects = value;
    notifyListeners();
  }

  void setPostUseCraving(double value) {
    postUseCraving = value;
    notifyListeners();
  }

  void setCopingStrategies(String value) {
    copingStrategies = value;
    notifyListeners();
  }

  void setCopingEffectiveness(double value) {
    copingEffectiveness = value;
    notifyListeners();
  }

  void setOverallSatisfaction(double value) {
    overallSatisfaction = value;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    setSaving(true);

    try {
      final reflectionData = {
        'notes': notesCtrl.text,
        'related_entries': selectedReflections,
        'selected_reflections': selectedReflections,
        'date': date.toIso8601String(),
        'hour': hour,
        'minute': minute,
        'effectiveness': effectiveness,
        'sleep_hours': sleepHours,
        'sleep_quality': sleepQuality,
        'next_day_mood': nextDayMood,
        'energy_level': energyLevel,
        'side_effects': sideEffects,
        'post_use_craving': postUseCraving,
        'coping_strategies': copingStrategies,
        'coping_effectiveness': copingEffectiveness,
        'overall_satisfaction': overallSatisfaction,
      };

      if (entryId.isNotEmpty) {
        await _service.updateReflection(entryId, reflectionData);
      } else {
        final oldReflection = Reflection();
        await _service.saveReflection(oldReflection, []);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reflection saved successfully!')),
        );
      }
      reset();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving reflection: $e')));
      }
    } finally {
      setSaving(false);
    }
  }

  @override
  void dispose() {
    notesCtrl.dispose();
    super.dispose();
  }

  void reset() {
    _reflection.reset();
    _selectedIds.clear();
    _showForm = false;
    notifyListeners();
  }
}
