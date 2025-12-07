import 'package:flutter/material.dart';
import '../common/modern_form_card.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(ThemeConstants.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reflecting on ${widget.selectedCount} selected entries',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Effectiveness Section
          ModernFormCard(
            title: 'Effectiveness',
            icon: Icons.star,
            accentColor: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
            child: ModernSlider(
              label: 'Effectiveness Rating',
              value: widget.effectiveness,
              onChanged: widget.onEffectivenessChanged,
              min: 1,
              max: 10,
              divisions: 9,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Sleep Section
          ModernFormCard(
            title: 'Sleep',
            icon: Icons.bedtime,
            accentColor: isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernTextField(
                  label: 'Sleep Hours',
                  controller: _sleepHoursController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final parsed = double.tryParse(value) ?? 8.0;
                    widget.onSleepHoursChanged(parsed);
                  },
                ),
                SizedBox(height: ThemeConstants.space16),
                ModernDropdownField<String>(
                  label: 'Sleep Quality',
                  value: widget.sleepQuality.isEmpty ? 'Good' : widget.sleepQuality,
                  items: const ['Poor', 'Fair', 'Good', 'Excellent'],
                  itemLabel: (item) => item,
                  onChanged: (value) => widget.onSleepQualityChanged(value!),
                ),
              ],
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Mood & Energy Section
          ModernFormCard(
            title: 'Mood & Energy',
            icon: Icons.psychology,
            accentColor: isDark ? UIColors.darkNeonPink : UIColors.lightAccentAmber,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernTextField(
                  label: 'Next Day Mood',
                  controller: _nextDayMoodController,
                  onChanged: widget.onNextDayMoodChanged,
                ),
                SizedBox(height: ThemeConstants.space16),
                ModernDropdownField<String>(
                  label: 'Energy Level',
                  value: widget.energyLevel.isEmpty ? 'Neutral' : widget.energyLevel,
                  items: const ['Low', 'Neutral', 'High'],
                  itemLabel: (item) => item,
                  onChanged: (value) => widget.onEnergyLevelChanged(value!),
                ),
              ],
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Side Effects Section
          ModernFormCard(
            title: 'Side Effects',
            icon: Icons.warning_amber,
            accentColor: isDark ? UIColors.darkNeonOrange : UIColors.lightAccentOrange,
            child: ModernTextField(
              label: 'Side Effects',
              controller: _sideEffectsController,
              onChanged: widget.onSideEffectsChanged,
              maxLines: 3,
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Cravings & Coping Section
          ModernFormCard(
            title: 'Cravings & Coping',
            icon: Icons.psychology_outlined,
            accentColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernSlider(
                  label: 'Post Use Craving',
                  value: widget.postUseCraving,
                  onChanged: widget.onPostUseCravingChanged,
                  min: 1,
                  max: 10,
                  divisions: 9,
                ),
                SizedBox(height: ThemeConstants.space16),
                ModernTextField(
                  label: 'Coping Strategies',
                  controller: _copingStrategiesController,
                  onChanged: widget.onCopingStrategiesChanged,
                  maxLines: 2,
                ),
                SizedBox(height: ThemeConstants.space16),
                ModernSlider(
                  label: 'Coping Effectiveness',
                  value: widget.copingEffectiveness,
                  onChanged: widget.onCopingEffectivenessChanged,
                  min: 1,
                  max: 10,
                  divisions: 9,
                ),
              ],
            ),
          ),
          SizedBox(height: ThemeConstants.space16),
          
          // Overall & Notes Section
          ModernFormCard(
            title: 'Overall',
            icon: Icons.assessment,
            accentColor: isDark ? UIColors.darkNeonViolet : UIColors.lightAccentIndigo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModernSlider(
                  label: 'Overall Satisfaction',
                  value: widget.overallSatisfaction,
                  onChanged: widget.onOverallSatisfactionChanged,
                  min: 1,
                  max: 10,
                  divisions: 9,
                ),
                SizedBox(height: ThemeConstants.space16),
                ModernTextField(
                  label: 'Notes',
                  controller: _notesController,
                  onChanged: widget.onNotesChanged,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: ThemeConstants.space24),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onSave,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? UIColors.darkNeonCyan : UIColors.lightAccentBlue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
