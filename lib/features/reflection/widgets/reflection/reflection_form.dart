// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
// Notes: No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final th = context.theme;
    return SingleChildScrollView(
      padding: EdgeInsets.all(th.spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text(
            'Reflecting on $selectedCount entries',
            style: th.typography.heading2,
          ),
          CommonSpacer.vertical(th.spacing.sm),
          Text(
            'Take a moment to analyze how these experiences affected you.',
            style: th.typography.body.copyWith(color: th.colors.textSecondary),
          ),
          CommonSpacer.vertical(th.spacing.xl),
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
            CommonSpacer.vertical(th.spacing.md),
            _buildSlider(
              context,
              'Overall Satisfaction',
              overallSatisfaction,
              onOverallSatisfactionChanged,
              minLabel: 'Dissatisfied',
              maxLabel: 'Very Satisfied',
            ),
          ]),
          CommonSpacer.vertical(th.spacing.lg),
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
                CommonSpacer.horizontal(th.spacing.md),
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
            CommonSpacer.vertical(th.spacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(context, 'Next Day Mood', nextDayMood, [
                    'Depressed',
                    'Anxious',
                    'Neutral',
                    'Good',
                    'Great',
                  ], onNextDayMoodChanged),
                ),
                CommonSpacer.horizontal(th.spacing.md),
                Expanded(
                  child: _buildDropdown(context, 'Energy Level', energyLevel, [
                    'Low',
                    'Medium',
                    'High',
                  ], onEnergyLevelChanged),
                ),
              ],
            ),
          ]),
          CommonSpacer.vertical(th.spacing.lg),
          // 3. Side Effects & Cravings
          _buildSectionCard(
            context,
            'Side Effects & Cravings',
            Icons.warning_amber,
            [
              _buildTextInput(
                context,
                'Side Effects',
                sideEffects,
                onSideEffectsChanged,
                hint: 'Headache, nausea, anxiety...',
              ),
              CommonSpacer.vertical(th.spacing.md),
              _buildSlider(
                context,
                'Post-Use Craving',
                postUseCraving,
                onPostUseCravingChanged,
                minLabel: 'None',
                maxLabel: 'Intense',
              ),
            ],
          ),
          CommonSpacer.vertical(th.spacing.lg),
          // 4. Coping & Notes
          _buildSectionCard(context, 'Coping & Notes', Icons.psychology, [
            _buildTextInput(
              context,
              'Coping Strategies',
              copingStrategies,
              onCopingStrategiesChanged,
              hint: 'Meditation, exercise, talking to a friend...',
            ),
            CommonSpacer.vertical(th.spacing.md),
            _buildSlider(
              context,
              'Coping Effectiveness',
              copingEffectiveness,
              onCopingEffectivenessChanged,
              minLabel: 'Not Helpful',
              maxLabel: 'Very Helpful',
            ),
            CommonSpacer.vertical(th.spacing.md),
            _buildTextInput(
              context,
              'Additional Notes',
              notes,
              onNotesChanged,
              maxLines: 3,
              hint: 'Any other thoughts or observations...',
            ),
          ]),
          CommonSpacer.vertical(th.spacing.xl3),
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
    final th = context.theme;

    return Container(
      padding: EdgeInsets.all(th.spacing.lg),
      decoration: BoxDecoration(
        color: th.colors.surface,
        borderRadius: BorderRadius.circular(th.shapes.radiusLg),
        boxShadow: th.cardShadow,
        border: Border.all(color: th.colors.border),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Row(
            children: [
              Icon(icon, color: th.accent.primary, size: th.sizes.iconSm),
              CommonSpacer.horizontal(th.spacing.sm),
              Text(title, style: th.typography.heading3),
            ],
          ),
          CommonSpacer.vertical(th.spacing.lg),
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
    final th = context.theme;

    final tx = context.text;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Row(
          mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
          children: [
            Text(
              label,
              style: th.typography.bodySmall.copyWith(
                fontWeight: tx.bodyBold.fontWeight,
              ),
            ),
            Text(
              value.round().toString(),
              style: th.typography.heading3.copyWith(color: th.accent.primary),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: th.accent.primary,
            inactiveTrackColor: th.accent.primary.withValues(alpha: 0.2),
            thumbColor: th.accent.primary,
            overlayColor: th.accent.primary.withValues(alpha: 0.1),
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
            padding: EdgeInsets.symmetric(horizontal: th.spacing.sm),
            child: Row(
              mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
              children: [
                Text(minLabel, style: th.typography.caption),
                Text(maxLabel, style: th.typography.caption),
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
    final th = context.theme;
    final tx = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          label,
          style: th.typography.bodySmall.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: th.colors.textSecondary,
          ),
        ),
        SizedBox(height: th.spacing.sm),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: maxLines,
          style: th.typography.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: th.typography.body.copyWith(
              color: th.colors.textSecondary.withValues(alpha: 0.5),
            ),
            contentPadding: EdgeInsets.all(th.spacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              borderSide: BorderSide(color: th.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              borderSide: BorderSide(color: th.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              borderSide: BorderSide(color: th.accent.primary),
            ),
            filled: true,
            fillColor: th.colors.surfaceVariant,
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
    final th = context.theme;
    final tx = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          label,
          style: th.typography.bodySmall.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: th.colors.textSecondary,
          ),
        ),
        SizedBox(height: th.spacing.sm),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (val) => onChanged(double.tryParse(val) ?? 0),
          style: th.typography.body,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(th.spacing.md),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              borderSide: BorderSide(color: th.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              borderSide: BorderSide(color: th.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              borderSide: BorderSide(color: th.accent.primary),
            ),
            filled: true,
            fillColor: th.colors.surfaceVariant,
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
    final th = context.theme;
    final tx = context.text;

    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        Text(
          label,
          style: th.typography.bodySmall.copyWith(
            fontWeight: tx.bodyBold.fontWeight,
            color: th.colors.textSecondary,
          ),
        ),
        SizedBox(height: th.spacing.sm),
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
