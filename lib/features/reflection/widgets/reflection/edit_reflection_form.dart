// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
// Notes: No hardcoded values.
import 'package:flutter/material.dart';
import '../../../../common/widgets/common_spacer.dart';
import '../../../../common/cards/common_form_card.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/inputs/dropdown.dart';
import '../../../../common/inputs/input_field.dart';
import '../../../../common/inputs/textarea.dart';
import '../../../../common/inputs/slider.dart';
import '../../../../common/buttons/common_primary_button.dart';

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
    final t = context.theme;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reflecting on ${widget.selectedCount} selected entries',
            style: t.typography.heading2,
          ),
          CommonSpacer.vertical(t.spacing.lg),
          
          // Effectiveness Section
          CommonFormCard(
            title: 'Effectiveness',
            icon: Icons.star,
            accentColor: t.colors.info,
            child: _buildSlider(
              context,
              'Effectiveness Rating',
              widget.effectiveness,
              widget.onEffectivenessChanged,
              minLabel: 'Ineffective',
              maxLabel: 'Highly Effective',
            ),
          ),
          CommonSpacer.vertical(t.spacing.lg),
          
          // Sleep Section
          CommonFormCard(
            title: 'Sleep',
            icon: Icons.bedtime,
            accentColor: t.accent.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonInputField(
                  controller: _sleepHoursController,
                  labelText: 'Sleep Hours',
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final parsed = double.tryParse(value) ?? 8.0;
                    widget.onSleepHoursChanged(parsed);
                  },
                ),
                CommonSpacer.vertical(t.spacing.lg),
                _buildDropdown(
                  context,
                  'Sleep Quality',
                  widget.sleepQuality.isEmpty ? 'Good' : widget.sleepQuality,
                  ['Poor', 'Fair', 'Good', 'Excellent'],
                  (value) => widget.onSleepQualityChanged(value),
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(t.spacing.lg),
          
          // Mood & Energy Section
          CommonFormCard(
            title: 'Mood & Energy',
            icon: Icons.psychology,
            accentColor: t.colors.warning,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonInputField(
                  controller: _nextDayMoodController,
                  labelText: 'Next Day Mood',
                  onChanged: widget.onNextDayMoodChanged,
                ),
                CommonSpacer.vertical(t.spacing.lg),
                _buildDropdown(
                  context,
                  'Energy Level',
                  widget.energyLevel.isEmpty ? 'Neutral' : widget.energyLevel,
                  ['Low', 'Neutral', 'High'],
                  (value) => widget.onEnergyLevelChanged(value),
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(t.spacing.lg),
          
          // Side Effects Section
          CommonFormCard(
            title: 'Side Effects',
            icon: Icons.warning_amber,
            accentColor: t.accent.secondary,
            child: CommonTextarea(
              controller: _sideEffectsController,
              labelText: 'Side Effects',
              onChanged: widget.onSideEffectsChanged,
              maxLines: 3,
            ),
          ),
          CommonSpacer.vertical(t.spacing.lg),
          
          // Cravings & Coping Section
          CommonFormCard(
            title: 'Cravings & Coping',
            icon: Icons.psychology_outlined,
            accentColor: t.colors.success,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSlider(
                  context,
                  'Post Use Craving',
                  widget.postUseCraving,
                  widget.onPostUseCravingChanged,
                  minLabel: 'None',
                  maxLabel: 'Intense',
                ),
                CommonSpacer.vertical(t.spacing.lg),
                CommonTextarea(
                  controller: _copingStrategiesController,
                  labelText: 'Coping Strategies',
                  onChanged: widget.onCopingStrategiesChanged,
                  maxLines: 2,
                ),
                CommonSpacer.vertical(t.spacing.lg),
                _buildSlider(
                  context,
                  'Coping Effectiveness',
                  widget.copingEffectiveness,
                  widget.onCopingEffectivenessChanged,
                  minLabel: 'Not Helpful',
                  maxLabel: 'Very Helpful',
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(t.spacing.lg),
          
          // Overall & Notes Section
          CommonFormCard(
            title: 'Overall',
            icon: Icons.assessment,
            accentColor: t.accent.secondary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSlider(
                  context,
                  'Overall Satisfaction',
                  widget.overallSatisfaction,
                  widget.onOverallSatisfactionChanged,
                  minLabel: 'Dissatisfied',
                  maxLabel: 'Very Satisfied',
                ),
                CommonSpacer.vertical(t.spacing.lg),
                CommonTextarea(
                  controller: _notesController,
                  labelText: 'Notes',
                  onChanged: widget.onNotesChanged,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          CommonSpacer.vertical(t.spacing.xl),
          
          // Save Button
          CommonPrimaryButton(
            onPressed: widget.onSave,
            label: 'Save Changes',
            icon: Icons.save,
            backgroundColor: t.colors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    double value,
    ValueChanged<double> onChanged, {
    String? minLabel,
    String? maxLabel,
  }) {
    final t = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: t.typography.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              value.round().toString(),
              style: t.typography.heading3.copyWith(
                color: t.accent.primary,
              ),
            ),
          ],
        ),
        CommonSlider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: onChanged,
          activeColor: t.accent.primary,
        ),
        if (minLabel != null && maxLabel != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: t.spacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minLabel,
                  style: t.typography.caption,
                ),
                Text(
                  maxLabel,
                  style: t.typography.caption,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    final t = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: t.typography.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: t.colors.textSecondary,
          ),
        ),
        CommonSpacer.vertical(t.spacing.sm),
        CommonDropdown<String>(
          value: items.contains(value) ? value : items.first,
          items: items,
          onChanged: (val) => onChanged(val!),
          hintText: label,
        ),
      ],
    );
  }
}
