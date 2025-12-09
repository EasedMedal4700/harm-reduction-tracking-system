
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../common/old_common/feeling_selection.dart';
import '../../common/old_common/modern_form_card.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class EmotionalStateSection extends StatelessWidget {
  final List<String> selectedEmotions;
  final Map<String, List<String>> secondaryEmotions;
  final ValueChanged<List<String>> onEmotionsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryEmotionsChanged;
  final String? thoughts;
  final ValueChanged<String> onThoughtsChanged;

  const EmotionalStateSection({
    super.key,
    required this.selectedEmotions,
    required this.secondaryEmotions,
    required this.onEmotionsChanged,
    required this.onSecondaryEmotionsChanged,
    required this.thoughts,
    required this.onThoughtsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ModernFormCard(
      title: 'Emotional State',
      icon: Icons.favorite,
      accentColor: isDark ? UIColors.darkNeonPink : UIColors.lightAccentPurple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeelingSelection(
            feelings: selectedEmotions,
            onFeelingsChanged: onEmotionsChanged,
            secondaryFeelings: secondaryEmotions,
            onSecondaryFeelingsChanged: onSecondaryEmotionsChanged,
          ),
          SizedBox(height: ThemeConstants.space16),
          Text(
            'Thoughts',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          TextFormField(
            initialValue: thoughts,
            onChanged: onThoughtsChanged,
            maxLines: 3,
            style: TextStyle(
              color: isDark ? UIColors.darkText : UIColors.lightText,
              fontSize: ThemeConstants.fontMedium,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark
                  ? UIColors.darkSurface.withValues(alpha: 0.3)
                  : UIColors.lightSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                borderSide: BorderSide(
                  color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}