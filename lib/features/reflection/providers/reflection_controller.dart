import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/reflection_model.dart';
import '../reflection_service.dart';

part 'reflection_controller.freezed.dart';
part 'reflection_controller.g.dart';

@freezed
abstract class ReflectionState with _$ReflectionState {
  const factory ReflectionState({
    required Reflection reflection,
    @Default({}) Set<String> selectedIds,
    @Default(false) bool showForm,
    @Default(false) bool isSaving,
    @Default('') String entryId,
    @Default(0.0) double effectiveness,
    @Default(0.0) double sleepHours,
    @Default('') String sleepQuality,
    @Default('') String nextDayMood,
    @Default('') String energyLevel,
    @Default('') String sideEffects,
    @Default(0.0) double postUseCraving,
    @Default('') String copingStrategies,
    @Default(0.0) double copingEffectiveness,
    @Default(0.0) double overallSatisfaction,
    @Default('') String notes,
    @Default([]) List<String> selectedReflections,
    required DateTime date,
    required int hour,
    required int minute,
  }) = _ReflectionState;
}

@riverpod
class ReflectionController extends _$ReflectionController {
  @override
  ReflectionState build() {
    final now = DateTime.now();
    return ReflectionState(
      reflection: Reflection(),
      date: now,
      hour: now.hour,
      minute: now.minute,
    );
  }

  void updateReflection(Reflection newReflection) {
    // Clone to ensure new instance for state change detection
    state = state.copyWith(reflection: newReflection.clone());
  }

  void toggleEntry(String id, bool selected) {
    final newSelectedIds = Set<String>.from(state.selectedIds);
    if (selected) {
      newSelectedIds.add(id);
    } else {
      newSelectedIds.remove(id);
    }
    state = state.copyWith(selectedIds: newSelectedIds);
  }

  void setShowForm(bool value) {
    state = state.copyWith(showForm: value);
  }

  void setSaving(bool value) {
    state = state.copyWith(isSaving: value);
  }

  void setNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void setSelectedReflections(List<String> value) {
    state = state.copyWith(selectedReflections: value);
  }

  void setDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void setHour(int value) {
    state = state.copyWith(hour: value);
  }

  void setMinute(int value) {
    state = state.copyWith(minute: value);
  }

  void setEffectiveness(double value) {
    state = state.copyWith(effectiveness: value);
  }

  void setSleepHours(double value) {
    state = state.copyWith(sleepHours: value);
  }

  void setSleepQuality(String value) {
    state = state.copyWith(sleepQuality: value);
  }

  void setNextDayMood(String value) {
    state = state.copyWith(nextDayMood: value);
  }

  void setEnergyLevel(String value) {
    state = state.copyWith(energyLevel: value);
  }

  void setSideEffects(String value) {
    state = state.copyWith(sideEffects: value);
  }

  void setPostUseCraving(double value) {
    state = state.copyWith(postUseCraving: value);
  }

  void setCopingStrategies(String value) {
    state = state.copyWith(copingStrategies: value);
  }

  void setCopingEffectiveness(double value) {
    state = state.copyWith(copingEffectiveness: value);
  }

  void setOverallSatisfaction(double value) {
    state = state.copyWith(overallSatisfaction: value);
  }

  Future<void> save() async {
    state = state.copyWith(isSaving: true);
    try {
      final service = ReflectionService();
      final reflectionData = {
        'notes': state.notes,
        'related_entries': state.selectedReflections,
        'selected_reflections': state.selectedReflections,
        'date': state.date.toIso8601String(),
        'hour': state.hour,
        'minute': state.minute,
        'effectiveness': state.effectiveness,
        'sleep_hours': state.sleepHours,
        'sleep_quality': state.sleepQuality,
        'next_day_mood': state.nextDayMood,
        'energy_level': state.energyLevel,
        'side_effects': state.sideEffects,
        'post_use_craving': state.postUseCraving,
        'coping_strategies': state.copingStrategies,
        'coping_effectiveness': state.copingEffectiveness,
        'overall_satisfaction': state.overallSatisfaction,
      };

      if (state.entryId.isNotEmpty) {
        await service.updateReflection(state.entryId, reflectionData);
      } else {
        final oldReflection = Reflection();
        await service.saveReflection(oldReflection, []);
      }
      reset();
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  void reset() {
    final now = DateTime.now();
    state = ReflectionState(
      reflection: Reflection(),
      date: now,
      hour: now.hour,
      minute: now.minute,
    );
  }
}
