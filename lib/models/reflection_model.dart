// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\models\reflection_model.dart
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