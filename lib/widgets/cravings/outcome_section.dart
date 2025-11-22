import 'package:flutter/material.dart';
import '../common/modern_form_card.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

class OutcomeSection extends StatelessWidget {
  final String? whatDidYouDo;
  final ValueChanged<String> onWhatDidYouDoChanged;
  final bool actedOnCraving;
  final ValueChanged<bool> onActedOnCravingChanged;

  const OutcomeSection({
    super.key,
    required this.whatDidYouDo,
    required this.onWhatDidYouDoChanged,
    required this.actedOnCraving,
    required this.onActedOnCravingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ModernFormCard(
      title: 'Outcome',
      icon: Icons.flag,
      accentColor: isDark ? UIColors.darkNeonOrange : UIColors.lightAccentOrange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What did you do?',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
          TextFormField(
            initialValue: whatDidYouDo,
            onChanged: onWhatDidYouDoChanged,
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
          SizedBox(height: ThemeConstants.space12),
          SwitchListTile(
            title: Text(
              'Acted on craving?',
              style: TextStyle(
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            value: actedOnCraving,
            onChanged: onActedOnCravingChanged,
            activeColor: isDark ? UIColors.darkNeonOrange : UIColors.lightAccentOrange,
          ),
        ],
      ),
    );
  }
}