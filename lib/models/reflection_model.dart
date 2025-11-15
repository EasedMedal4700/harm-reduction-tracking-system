import 'package:flutter/material.dart';

class Reflection {
  double effectiveness;
  double sleepHours;
  String sleepQuality;
  String nextDayMood;
  String energyLevel;
  String sideEffects;
  double postUseCraving;
  String copingStrategies;
  double copingEffectiveness;
  double overallSatisfaction;
  String notes;

  Reflection({
    this.effectiveness = 5.0,
    this.sleepHours = 8.0,
    this.sleepQuality = 'Good',
    this.nextDayMood = '',
    this.energyLevel = 'Neutral',
    this.sideEffects = '',
    this.postUseCraving = 5.0,
    this.copingStrategies = '',
    this.copingEffectiveness = 5.0,
    this.overallSatisfaction = 5.0,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
    'effectiveness': effectiveness.round(),
    'sleep_hours': sleepHours,
    'sleep_quality': sleepQuality,
    'next_day_mood': nextDayMood.isEmpty ? null : nextDayMood,
    'energy_level': energyLevel,
    'side_effects': sideEffects.isEmpty ? null : sideEffects,
    'post_use_craving': postUseCraving.round(),
    'coping_strategies': copingStrategies.isEmpty ? null : copingStrategies,
    'coping_effectiveness': copingEffectiveness.round(),
    'overall_satisfaction': overallSatisfaction.round(),
    'notes': notes,
  };

  void reset() {
    effectiveness = 5.0;
    sleepHours = 8.0;
    sleepQuality = 'Good';
    nextDayMood = '';
    energyLevel = 'Neutral';
    sideEffects = '';
    postUseCraving = 5.0;
    copingStrategies = '';
    copingEffectiveness = 5.0;
    overallSatisfaction = 5.0;
    notes = '';
  }
}

class ReflectionModel {
  final String? id;
  final String? notes;
  final List<String> selectedReflections;
  final DateTime date;
  final int hour;
  final int minute;
  final double effectiveness;
  final double sleepHours;
  final String sleepQuality;
  final String nextDayMood;
  final String energyLevel;
  final String sideEffects;
  final double postUseCraving;
  final String copingStrategies;
  final double copingEffectiveness;
  final double overallSatisfaction;

  ReflectionModel({
    this.id,
    this.notes,
    this.selectedReflections = const [],
    required this.date,
    required this.hour,
    required this.minute,
    this.effectiveness = 0.0,
    this.sleepHours = 0.0,
    this.sleepQuality = '',
    this.nextDayMood = '',
    this.energyLevel = '',
    this.sideEffects = '',
    this.postUseCraving = 0.0,
    this.copingStrategies = '',
    this.copingEffectiveness = 0.0,
    this.overallSatisfaction = 0.0,
  });

  factory ReflectionModel.fromJson(Map<String, dynamic> json) {
    List<String> _toList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      if (v is String && v.isNotEmpty) {
        return v.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    double _toDouble(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0.0;
    DateTime _toDate(dynamic v) => DateTime.tryParse(v?.toString() ?? '') ?? DateTime.now();

    return ReflectionModel(
      id: json['id']?.toString(),
      notes: json['notes']?.toString(),
      selectedReflections: _toList(json['selected_reflections'] ?? json['reflections']),
      date: _toDate(json['date'] ?? json['created_at']),
      hour: int.tryParse(json['hour']?.toString() ?? '') ?? TimeOfDay.now().hour,
      minute: int.tryParse(json['minute']?.toString() ?? '') ?? TimeOfDay.now().minute,
      effectiveness: _toDouble(json['effectiveness']),
      sleepHours: _toDouble(json['sleep_hours']),
      sleepQuality: json['sleep_quality']?.toString() ?? '',
      nextDayMood: json['next_day_mood']?.toString() ?? '',
      energyLevel: json['energy_level']?.toString() ?? '',
      sideEffects: json['side_effects']?.toString() ?? '',
      postUseCraving: _toDouble(json['post_use_craving']),
      copingStrategies: json['coping_strategies']?.toString() ?? '',
      copingEffectiveness: _toDouble(json['coping_effectiveness']),
      overallSatisfaction: _toDouble(json['overall_satisfaction']),
    );
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