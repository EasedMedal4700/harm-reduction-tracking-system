import 'package:flutter/material.dart';

class ReflectionForm extends StatelessWidget {
  final int selectedCount;
  final double effectiveness;
  final ValueChanged<double> onEffectivenessChanged;
  final double sleepHours;
  final ValueChanged<double> onSleepHoursChanged;
  final String sleepQuality;
  final ValueChanged<String> onSleepQualityChanged;
  final String nextDayMood;
  final ValueChanged<String> onNextDayMoodChanged;
  final String energyLevel;
  final ValueChanged<String> onEnergyLevelChanged;
  final String sideEffects;
  final ValueChanged<String> onSideEffectsChanged;
  final double postUseCraving;
  final ValueChanged<double> onPostUseCravingChanged;
  final String copingStrategies;
  final ValueChanged<String> onCopingStrategiesChanged;
  final double copingEffectiveness;
  final ValueChanged<double> onCopingEffectivenessChanged;
  final double overallSatisfaction;
  final ValueChanged<double> onOverallSatisfactionChanged;
  final String notes;
  final ValueChanged<String> onNotesChanged;

  const ReflectionForm({
    super.key,
    required this.selectedCount,
    required this.effectiveness,
    required this.onEffectivenessChanged,
    required this.sleepHours,
    required this.onSleepHoursChanged,
    required this.sleepQuality,
    required this.onSleepQualityChanged,
    required this.nextDayMood,
    required this.onNextDayMoodChanged,
    required this.energyLevel,
    required this.onEnergyLevelChanged,
    required this.sideEffects,
    required this.onSideEffectsChanged,
    required this.postUseCraving,
    required this.onPostUseCravingChanged,
    required this.copingStrategies,
    required this.onCopingStrategiesChanged,
    required this.copingEffectiveness,
    required this.onCopingEffectivenessChanged,
    required this.overallSatisfaction,
    required this.onOverallSatisfactionChanged,
    required this.notes,
    required this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reflecting on $selectedCount selected entries', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          const Text('Effectiveness (1-10)'),
          Slider(
            value: effectiveness,
            min: 1,
            max: 10,
            divisions: 9,
            label: effectiveness.round().toString(),
            onChanged: onEffectivenessChanged,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Sleep Hours'),
            keyboardType: TextInputType.number,
            onChanged: (value) => onSleepHoursChanged(double.tryParse(value) ?? 8.0),
          ),
          const Text('Sleep Quality'),
          DropdownButton<String>(
            value: sleepQuality,
            onChanged: (value) => onSleepQualityChanged(value!),
            items: ['Poor', 'Fair', 'Good', 'Excellent'].map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Next Day Mood'),
            onChanged: onNextDayMoodChanged,
          ),
          const Text('Energy Level'),
          DropdownButton<String>(
            value: energyLevel,
            onChanged: (value) => onEnergyLevelChanged(value!),
            items: ['Low', 'Neutral', 'High'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Side Effects'),
            onChanged: onSideEffectsChanged,
          ),
          const Text('Post Use Craving (1-10)'),
          Slider(
            value: postUseCraving,
            min: 1,
            max: 10,
            divisions: 9,
            label: postUseCraving.round().toString(),
            onChanged: onPostUseCravingChanged,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Coping Strategies'),
            onChanged: onCopingStrategiesChanged,
          ),
          const Text('Coping Effectiveness (1-10)'),
          Slider(
            value: copingEffectiveness,
            min: 1,
            max: 10,
            divisions: 9,
            label: copingEffectiveness.round().toString(),
            onChanged: onCopingEffectivenessChanged,
          ),
          const Text('Overall Satisfaction (1-10)'),
          Slider(
            value: overallSatisfaction,
            min: 1,
            max: 10,
            divisions: 9,
            label: overallSatisfaction.round().toString(),
            onChanged: onOverallSatisfactionChanged,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
            onChanged: onNotesChanged,
          ),
        ],
      ),
    );
  }
}