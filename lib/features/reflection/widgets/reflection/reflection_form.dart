// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
// Notes: No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';

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
    final t = context.theme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Reflecting on $selectedCount entries',
            style: t.typography.heading2,
          ),
          CommonSpacer.vertical(t.spacing.sm),
          Text(
            'Take a moment to analyze how these experiences affected you.',
            style: t.typography.body.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
          CommonSpacer.vertical(t.spacing.xl),

          // 1. Core Experience
          _buildSectionCard(context, 'Core Experience', Icons.stars, [
            _buildSlider(
              context,
              'Effectiveness',
              effectiveness,
              onEffectivenessChanged,
              minLabel: 'Ineffective',
              maxLabel: 'Highly Effective',
            ),
            CommonSpacer.vertical(t.spacing.md),
            _buildSlider(
              context,
              'Overall Satisfaction',
              overallSatisfaction,
              onOverallSatisfactionChanged,
              minLabel: 'Dissatisfied',
              maxLabel: 'Very Satisfied',
            ),
          ]),
          CommonSpacer.vertical(t.spacing.lg),

          // 2. Sleep & Recovery
          _buildSectionCard(context, 'Sleep & Recovery', Icons.bedtime, [
            Row(
              children: [
                Expanded(
                  child: _buildNumberInput(
                    context,
                    'Sleep Hours',
                    sleepHours,
                    onSleepHoursChanged,
                  ),
                ),
                CommonSpacer.horizontal(t.spacing.md),
                Expanded(
                  child: _buildDropdown(
                    context,
                    'Sleep Quality',
                    sleepQuality,
                    ['Poor', 'Fair', 'Good', 'Excellent'],
                    onSleepQualityChanged,
                  ),
                ),
              ],
            ),
            CommonSpacer.vertical(t.spacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    context,
                    'Next Day Mood',
                    nextDayMood,
                    ['Depressed', 'Anxious', 'Neutral', 'Good', 'Great'],
                    onNextDayMoodChanged,
                  ),
                ),
                CommonSpacer.horizontal(t.spacing.md),
                Expanded(
                  child: _buildDropdown(
                    context,
                    'Energy Level',
                    energyLevel,
                    ['Low', 'Medium', 'High'],
                    onEnergyLevelChanged,
                  ),
                ),
              ],
            ),
          ]),
          CommonSpacer.vertical(t.spacing.lg),

          // 3. Side Effects & Cravings
          _buildSectionCard(context, 'Side Effects & Cravings', Icons.warning_amber, [
            _buildTextInput(
              context,
              'Side Effects',
              sideEffects,
              onSideEffectsChanged,
              hint: 'Headache, nausea, anxiety...',
            ),
            CommonSpacer.vertical(t.spacing.md),
            _buildSlider(
              context,
              'Post-Use Craving',
              postUseCraving,
              onPostUseCravingChanged,
              minLabel: 'None',
              maxLabel: 'Intense',
            ),
          ]),
          CommonSpacer.vertical(t.spacing.lg),

          // 4. Coping & Notes
          _buildSectionCard(context, 'Coping & Notes', Icons.psychology, [
            _buildTextInput(
              context,
              'Coping Strategies',
              copingStrategies,
              onCopingStrategiesChanged,
              hint: 'Meditation, exercise, talking to a friend...',
            ),
            CommonSpacer.vertical(t.spacing.md),
            _buildSlider(
              context,
              'Coping Effectiveness',
              copingEffectiveness,
              onCopingEffectivenessChanged,
              minLabel: 'Not Helpful',
              maxLabel: 'Very Helpful',
            ),
            CommonSpacer.vertical(t.spacing.md),
            _buildTextInput(
              context,
              'Additional Notes',
              notes,
              onNotesChanged,
              maxLines: 3,
              hint: 'Any other thoughts or observations...',
            ),
          ]),
          CommonSpacer.vertical(t.spacing.xl3),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    final t = context.theme;

    return Container(
      padding: EdgeInsets.all(t.spacing.lg),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusLg),
        boxShadow: t.cardShadow,
        border: Border.all(color: t.colors.border),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(icon, color: t.accent.primary, size: t.sizes.iconSm),
              CommonSpacer.horizontal(t.spacing.sm),
              Text(
                title,
                style: t.typography.heading3,
              ),
            ],
          ),
          CommonSpacer.vertical(t.spacing.lg),
          ...children,
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
    final text = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text(
              label,
              style: t.typography.bodySmall.copyWith(fontWeight: text.bodyBold.fontWeight),
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
              mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
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

  Widget _buildTextInput(
    BuildContext context,
    String label,
    String value,
    ValueChanged<String> onChanged, {
    int maxLines = 1,
    String? hint,
  }) {
    final t = context.theme;
    final text = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          label,
          style: t.typography.bodySmall.copyWith(
            fontWeight: text.bodyBold.fontWeight,
            color: t.colors.textSecondary,
          ),
        ),
        SizedBox(height: t.spacing.sm),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: maxLines,
          style: t.typography.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: t.typography.body.copyWith(
              color: t.colors.textSecondary.withValues(alpha: 0.5),
            ),
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

  Widget _buildNumberInput(
    BuildContext context,
    String label,
    double value,
    ValueChanged<double> onChanged,
  ) {
    final t = context.theme;
    final text = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          label,
          style: t.typography.bodySmall.copyWith(
            fontWeight: text.bodyBold.fontWeight,
            color: t.colors.textSecondary,
          ),
        ),
        SizedBox(height: t.spacing.sm),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (val) => onChanged(double.tryParse(val) ?? 0),
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
    final text = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          label,
          style: t.typography.bodySmall.copyWith(
            fontWeight: text.bodyBold.fontWeight,
            color: t.colors.textSecondary,
          ),
        ),
        SizedBox(height: t.spacing.sm),
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
