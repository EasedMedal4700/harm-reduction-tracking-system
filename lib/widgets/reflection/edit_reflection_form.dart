import 'package:flutter/material.dart';

class EditReflectionForm extends StatefulWidget {
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
  final VoidCallback onSave;

  const EditReflectionForm({
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
    required this.onSave,
  });

  @override
  State<EditReflectionForm> createState() => _EditReflectionFormState();
}

class _EditReflectionFormState extends State<EditReflectionForm> {
  late TextEditingController _sleepHoursController;
  late TextEditingController _nextDayMoodController;
  late TextEditingController _sideEffectsController;
  late TextEditingController _copingStrategiesController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _sleepHoursController = TextEditingController(text: widget.sleepHours.toString());
    _nextDayMoodController = TextEditingController(text: widget.nextDayMood);
    _sideEffectsController = TextEditingController(text: widget.sideEffects);
    _copingStrategiesController = TextEditingController(text: widget.copingStrategies);
    _notesController = TextEditingController(text: widget.notes);
  }

  @override
  void didUpdateWidget(covariant EditReflectionForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text when the parent supplies new initial values
    if (oldWidget.sleepHours != widget.sleepHours) {
      _sleepHoursController.text = widget.sleepHours.toString();
    }
    if (oldWidget.nextDayMood != widget.nextDayMood) {
      _nextDayMoodController.text = widget.nextDayMood;
    }
    if (oldWidget.sideEffects != widget.sideEffects) {
      _sideEffectsController.text = widget.sideEffects;
    }
    if (oldWidget.copingStrategies != widget.copingStrategies) {
      _copingStrategiesController.text = widget.copingStrategies;
    }
    if (oldWidget.notes != widget.notes) {
      _notesController.text = widget.notes;
    }
  }

  @override
  void dispose() {
    _sleepHoursController.dispose();
    _nextDayMoodController.dispose();
    _sideEffectsController.dispose();
    _copingStrategiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reflecting on ${widget.selectedCount} selected entries',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Effectiveness (1-10)', style: TextStyle(fontWeight: FontWeight.w500)),
          Slider(
            value: widget.effectiveness,
            min: 1,
            max: 10,
            divisions: 9,
            label: widget.effectiveness.round().toString(),
            onChanged: widget.onEffectivenessChanged,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _sleepHoursController,
            decoration: const InputDecoration(
              labelText: 'Sleep Hours',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 8.0;
              widget.onSleepHoursChanged(parsed);
            },
          ),
          const SizedBox(height: 16),
          const Text('Sleep Quality', style: TextStyle(fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: widget.sleepQuality.isEmpty ? 'Good' : widget.sleepQuality,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onChanged: (value) => widget.onSleepQualityChanged(value!),
            items: ['Poor', 'Fair', 'Good', 'Excellent']
                .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                .toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nextDayMoodController,
            decoration: const InputDecoration(
              labelText: 'Next Day Mood',
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onNextDayMoodChanged,
          ),
          const SizedBox(height: 16),
          const Text('Energy Level', style: TextStyle(fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: widget.energyLevel.isEmpty ? 'Neutral' : widget.energyLevel,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onChanged: (value) => widget.onEnergyLevelChanged(value!),
            items: ['Low', 'Neutral', 'High']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _sideEffectsController,
            decoration: const InputDecoration(
              labelText: 'Side Effects',
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onSideEffectsChanged,
          ),
          const SizedBox(height: 16),
          const Text('Post Use Craving (1-10)', style: TextStyle(fontWeight: FontWeight.w500)),
          Slider(
            value: widget.postUseCraving,
            min: 1,
            max: 10,
            divisions: 9,
            label: widget.postUseCraving.round().toString(),
            onChanged: widget.onPostUseCravingChanged,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _copingStrategiesController,
            decoration: const InputDecoration(
              labelText: 'Coping Strategies',
              border: OutlineInputBorder(),
            ),
            onChanged: widget.onCopingStrategiesChanged,
          ),
          const SizedBox(height: 16),
          const Text('Coping Effectiveness (1-10)', style: TextStyle(fontWeight: FontWeight.w500)),
          Slider(
            value: widget.copingEffectiveness,
            min: 1,
            max: 10,
            divisions: 9,
            label: widget.copingEffectiveness.round().toString(),
            onChanged: widget.onCopingEffectivenessChanged,
          ),
          const SizedBox(height: 16),
          const Text('Overall Satisfaction (1-10)', style: TextStyle(fontWeight: FontWeight.w500)),
          Slider(
            value: widget.overallSatisfaction,
            min: 1,
            max: 10,
            divisions: 9,
            label: widget.overallSatisfaction.round().toString(),
            onChanged: widget.onOverallSatisfactionChanged,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: widget.onNotesChanged,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSave,
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}
