import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../../constants/ui_colors.dart';
import '../../constants/reflection_options.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reflecting on $selectedCount entries',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: textColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          Text(
            'Take a moment to analyze how these experiences affected you.',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space24),

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
            const SizedBox(height: ThemeConstants.space16),
            _buildSlider(
              context,
              'Overall Satisfaction',
              overallSatisfaction,
              onOverallSatisfactionChanged,
              minLabel: 'Regret',
              maxLabel: 'Satisfied',
            ),
          ]),
          const SizedBox(height: ThemeConstants.space16),

          // 2. Sleep & Recovery
          _buildSectionCard(context, 'Sleep & Recovery', Icons.bedtime, [
            Row(
              children: [
                Expanded(
                  child: _buildNumberInput(
                    context,
                    'Sleep Hours',
                    sleepHours,
                    (val) => onSleepHoursChanged(val),
                  ),
                ),
                const SizedBox(width: ThemeConstants.space16),
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
            const SizedBox(height: ThemeConstants.space16),
            _buildDropdown(context, 'Energy Level (Next Day)', energyLevel, [
              'Low',
              'Neutral',
              'High',
            ], onEnergyLevelChanged),
          ]),
          const SizedBox(height: ThemeConstants.space16),

          // 3. Mood & Effects
          _buildSectionCard(context, 'Mood & Effects', Icons.mood, [
            _buildMultiSelectChips(
              context,
              'Next Day Mood',
              nextDayMood,
              ReflectionOptions.moodOptions,
              onNextDayMoodChanged,
            ),
            const SizedBox(height: ThemeConstants.space16),
            _buildMultiSelectChips(
              context,
              'Side Effects',
              sideEffects,
              ReflectionOptions.sideEffectsOptions,
              onSideEffectsChanged,
            ),
          ]),
          const SizedBox(height: ThemeConstants.space16),

          // 4. Cravings & Coping
          _buildSectionCard(context, 'Cravings & Coping', Icons.psychology, [
            _buildSlider(
              context,
              'Post-Use Craving',
              postUseCraving,
              onPostUseCravingChanged,
              minLabel: 'None',
              maxLabel: 'Intense',
            ),
            const SizedBox(height: ThemeConstants.space16),
            _buildMultiSelectChips(
              context,
              'Coping Strategies Used',
              copingStrategies,
              ReflectionOptions.copingStrategiesOptions,
              onCopingStrategiesChanged,
            ),
            const SizedBox(height: ThemeConstants.space16),
            _buildSlider(
              context,
              'Coping Effectiveness',
              copingEffectiveness,
              onCopingEffectivenessChanged,
              minLabel: 'Useless',
              maxLabel: 'Helpful',
            ),
          ]),
          const SizedBox(height: ThemeConstants.space16),

          // 5. Notes
          _buildSectionCard(context, 'Additional Notes', Icons.note, [
            _buildTextInput(
              context,
              'Journal',
              notes,
              onNotesChanged,
              maxLines: 4,
              hint: 'Any other thoughts or observations...',
            ),
          ]),
          const SizedBox(height: ThemeConstants.space32),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkSurface : Colors.white;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final accentColor = isDark
        ? UIColors.darkNeonPurple
        : UIColors.lightAccentPurple;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.space16),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;
    final accentColor = isDark
        ? UIColors.darkNeonPurple
        : UIColors.lightAccentPurple;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                fontWeight: ThemeConstants.fontMediumWeight,
                color: textColor,
              ),
            ),
            Text(
              value.round().toString(),
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontBold,
                color: accentColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accentColor,
            inactiveTrackColor: accentColor.withOpacity(0.2),
            thumbColor: accentColor,
            overlayColor: accentColor.withOpacity(0.1),
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minLabel,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    color: secondaryTextColor,
                  ),
                ),
                Text(
                  maxLabel,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontXSmall,
                    color: secondaryTextColor,
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          maxLines: maxLines,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.5)),
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark
                    ? UIColors.darkNeonPurple
                    : UIColors.lightAccentPurple,
              ),
            ),
            filled: true,
            fillColor: isDark ? Colors.black12 : Colors.grey[50],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (val) => onChanged(double.tryParse(val) ?? 0),
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark
                    ? UIColors.darkNeonPurple
                    : UIColors.lightAccentPurple,
              ),
            ),
            filled: true,
            fillColor: isDark ? Colors.black12 : Colors.grey[50],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;
    final borderColor = isDark ? UIColors.darkBorder : UIColors.lightBorder;
    final dropdownColor = isDark ? UIColors.darkSurface : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first,
          onChanged: (val) => onChanged(val!),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: TextStyle(color: textColor)),
                ),
              )
              .toList(),
          dropdownColor: dropdownColor,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark
                    ? UIColors.darkNeonPurple
                    : UIColors.lightAccentPurple,
              ),
            ),
            filled: true,
            fillColor: isDark ? Colors.black12 : Colors.grey[50],
          ),
          icon: Icon(Icons.arrow_drop_down, color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildMultiSelectChips(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;
    final accentColor = isDark
        ? UIColors.darkNeonPurple
        : UIColors.lightAccentPurple;

    // Parse existing selections (comma-separated)
    final selectedItems = value.isEmpty 
        ? <String>[] 
        : value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ThemeConstants.fontSmall,
            fontWeight: ThemeConstants.fontMediumWeight,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedItems.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                final newSelections = List<String>.from(selectedItems);
                if (selected) {
                  newSelections.add(option);
                } else {
                  newSelections.remove(option);
                }
                onChanged(newSelections.join(', '));
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontSize: ThemeConstants.fontSmall,
              ),
              backgroundColor: isDark ? Colors.black12 : Colors.grey[200],
              selectedColor: accentColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? accentColor
                    : (isDark ? UIColors.darkBorder : UIColors.lightBorder),
              ),
            );
          }).toList(),
        ),
        if (selectedItems.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black12 : Colors.grey[100],
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
              border: Border.all(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: accentColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Selected: ${selectedItems.join(", ")}',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontXSmall,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
                if (selectedItems.isNotEmpty)
                  InkWell(
                    onTap: () => onChanged(''),
                    child: Icon(
                      Icons.clear,
                      size: 16,
                      color: secondaryTextColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
