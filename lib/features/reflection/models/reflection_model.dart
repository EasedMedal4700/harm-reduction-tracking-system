// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: FREEZED
// Theme: N/A
// Common: N/A
// Notes: Data model.
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_drug_use_app/core/utils/error_handler.dart';

import '../reflection_exceptions.dart';

part 'reflection_model.freezed.dart';

double _doubleFromAny(Object? v) => double.tryParse(v?.toString() ?? '') ?? 0.0;

int _intFromAny(Object? v, int fallback) =>
    int.tryParse(v?.toString() ?? '') ?? fallback;

DateTime _dateTimeFromAny(Object? v) {
  final parsed = DateTime.tryParse(v?.toString() ?? '');
  return parsed ?? DateTime.now();
}

Object? _readSelectedReflections(Map<dynamic, dynamic> json, String key) {
  return json['selected_reflections'] ??
      json['reflections'] ??
      json['related_entries'];
}

List<String> _stringListFromAny(Object? v) {
  if (v == null) return const [];
  if (v is List) {
    return v
        .map((e) => e?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }
  if (v is String && v.isNotEmpty) {
    return v
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  return const [];
}

@freezed
abstract class Reflection with _$Reflection {
  const factory Reflection({
    @Default(5.0) double effectiveness,
    @Default(8.0) double sleepHours,
    @Default('Good') String sleepQuality,
    @Default('') String nextDayMood,
    @Default('Neutral') String energyLevel,
    @Default('') String sideEffects,
    @Default(5.0) double postUseCraving,
    @Default('') String copingStrategies,
    @Default(5.0) double copingEffectiveness,
    @Default(5.0) double overallSatisfaction,
    @Default('') String notes,
  }) = _Reflection;

  const Reflection._();

  Reflection clone() => copyWith();

  Reflection reset() => const Reflection();

  Map<String, dynamic> toJson() => {
    'effectiveness': effectiveness.round(),
    'sleep_hours': sleepHours.isNaN ? null : sleepHours,
    'sleep_quality': sleepHours.isNaN ? null : sleepQuality,
    'next_day_mood': nextDayMood.isEmpty ? null : nextDayMood,
    'energy_level': energyLevel,
    'side_effects': sideEffects.isEmpty ? null : sideEffects,
    'post_use_craving': postUseCraving.round(),
    'coping_strategies': copingStrategies.isEmpty ? null : copingStrategies,
    'coping_effectiveness': copingEffectiveness.isNaN
        ? null
        : copingEffectiveness.round(),
    'overall_satisfaction': overallSatisfaction.round(),
    'notes': notes,
  };
}

@freezed
abstract class ReflectionModel with _$ReflectionModel {
  const factory ReflectionModel({
    @Default([]) List<String> selectedReflections,
    String? id,
    String? notes,
    required DateTime date,
    required int hour,
    required int minute,
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
  }) = _ReflectionModel;

  const ReflectionModel._();

  factory ReflectionModel.fromJson(Map<String, dynamic> json) {
    try {
      ErrorHandler.logDebug('ReflectionModel', 'Parsing reflection from JSON');
      ErrorHandler.logDebug('ReflectionModel', 'Raw field values:', {
        'related_entries': json['related_entries'],
        'selected_reflections': json['selected_reflections'],
        'reflections': json['reflections'],
      });

      final now = TimeOfDay.now();

      return ReflectionModel(
        id: json['reflection_id']?.toString() ?? json['id']?.toString(),
        notes: json['notes']?.toString(),
        selectedReflections: _stringListFromAny(
          _readSelectedReflections(json, 'selected_reflections'),
        ),
        date: _dateTimeFromAny(json['date'] ?? json['created_at']),
        hour: _intFromAny(json['hour'], now.hour),
        minute: _intFromAny(json['minute'], now.minute),
        effectiveness: _doubleFromAny(json['effectiveness']),
        sleepHours: _doubleFromAny(json['sleep_hours']),
        sleepQuality: json['sleep_quality']?.toString() ?? '',
        nextDayMood: json['next_day_mood']?.toString() ?? '',
        energyLevel: json['energy_level']?.toString() ?? '',
        sideEffects: json['side_effects']?.toString() ?? '',
        postUseCraving: _doubleFromAny(json['post_use_craving']),
        copingStrategies: json['coping_strategies']?.toString() ?? '',
        copingEffectiveness: _doubleFromAny(json['coping_effectiveness']),
        overallSatisfaction: _doubleFromAny(json['overall_satisfaction']),
      );
    } catch (e, stackTrace) {
      ErrorHandler.logError('ReflectionModel.fromJson', e, stackTrace);
      throw ReflectionParseException(
        'Failed to parse reflection from JSON',
        rawData: json,
        details: e.toString(),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'notes': notes,
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
}
