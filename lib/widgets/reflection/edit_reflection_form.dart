import 'package:flutter/material.dart';
import '../../common/old_common/modern_form_card.dart';
import '../../constants/theme/app_theme_extension.dart';

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
            'Reflecting on  selected entries',
            style: t.typography.heading2,
          ),
          SizedBox(height: t.spacing.lg),
          
          // Effectiveness Section
          ModernFormCard(
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
          SizedBox(height: t.spacing.lg),
          
          // Sleep Section
          ModernFormCard(
            title: 'Sleep',
            icon: Icons.bedtime,
            accentColor: t.accent.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  context,
                  'Sleep Hours',
                  _sleepHoursController,
                  (value) {
                    final parsed = double.tryParse(value) ?? 8.0;
                    widget.onSleepHoursChanged(parsed);
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: t.spacing.lg),
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
          SizedBox(height: t.spacing.lg),
          
          // Mood & Energy Section
          ModernFormCard(
            title: 'Mood & Energy',
            icon: Icons.psychology,
            accentColor: t.colors.warning,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  context,
                  'Next Day Mood',
                  _nextDayMoodController,
                  widget.onNextDayMoodChanged,
                ),
                SizedBox(height: t.spacing.lg),
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
          SizedBox(height: t.spacing.lg),
          
          // Side Effects Section
          ModernFormCard(
            title: 'Side Effects',
            icon: Icons.warning_amber,
            accentColor: t.accent.secondary,
            child: _buildTextField(
              context,
              'Side Effects',
              _sideEffectsController,
              widget.onSideEffectsChanged,
              maxLines: 3,
            ),
          ),
          SizedBox(height: t.spacing.lg),
          
          // Cravings & Coping Section
          ModernFormCard(
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
                SizedBox(height: t.spacing.lg),
                _buildTextField(
                  context,
                  'Coping Strategies',
                  _copingStrategiesController,
                  widget.onCopingStrategiesChanged,
                  maxLines: 2,
                ),
                SizedBox(height: t.spacing.lg),
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
          SizedBox(height: t.spacing.lg),
          
          // Overall & Notes Section
          ModernFormCard(
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
                SizedBox(height: t.spacing.lg),
                _buildTextField(
                  context,
                  'Notes',
                  _notesController,
                  widget.onNotesChanged,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: t.spacing.xl),
          
          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onSave,
              icon: const Icon(Icons.save),
              label: Text('Save Changes', style: t.typography.button),
              style: ElevatedButton.styleFrom(
                backgroundColor: t.colors.info,
                foregroundColor: t.colors.textInverse,
                padding: EdgeInsets.symmetric(vertical: t.spacing.lg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusMd),
                ),
              ),
            ),
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
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: t.accent.primary,
            inactiveTrackColor: t.accent.primary.withValues(alpha: 0.2),
            thumbColor: t.accent.primary,
            overlayColor: t.accent.primary.withValues(alpha: 0.1),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: onChanged,
          ),
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

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
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
        SizedBox(height: t.spacing.sm),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: t.typography.body,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(t.spacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(
                color: t.accent.primary,
              ),
            ),
            filled: true,
            fillColor: t.colors.surfaceVariant,
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
        SizedBox(height: t.spacing.sm),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          onChanged: (val) => onChanged(val!),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: t.typography.body),
                ),
              )
              .toList(),
          dropdownColor: t.colors.surface,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: t.spacing.md,
              vertical: t.spacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(
                color: t.accent.primary,
              ),
            ),
            filled: true,
            fillColor: t.colors.surfaceVariant,
          ),
          icon: Icon(Icons.arrow_drop_down, color: t.colors.textSecondary),
        ),
      ],
    );
  }
}
