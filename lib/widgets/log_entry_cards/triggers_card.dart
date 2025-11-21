import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/body_and_mind_catalog.dart';

/// Triggers selection card
class TriggersCard extends StatelessWidget {
  final List<String> selectedTriggers;
  final ValueChanged<List<String>> onTriggersChanged;

  const TriggersCard({
    required this.selectedTriggers,
    required this.onTriggersChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Triggers',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          Text(
            'What prompted this use?',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark 
                  ? UIColors.darkTextSecondary 
                  : UIColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Triggers chips
          Wrap(
            spacing: ThemeConstants.space8,
            runSpacing: ThemeConstants.space8,
            children: triggers.map((trigger) {
              final isSelected = selectedTriggers.contains(trigger);
              final accentColor = isDark 
                  ? UIColors.darkNeonViolet 
                  : UIColors.lightAccentPurple;
              
              return GestureDetector(
                onTap: () {
                  final newTriggers = List<String>.from(selectedTriggers);
                  if (isSelected) {
                    newTriggers.remove(trigger);
                  } else {
                    newTriggers.add(trigger);
                  }
                  onTriggersChanged(newTriggers);
                },
                child: AnimatedContainer(
                  duration: ThemeConstants.animationFast,
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space12,
                    vertical: ThemeConstants.space8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? accentColor.withOpacity(0.15) : accentColor.withOpacity(0.1))
                        : (isDark ? const Color(0x08FFFFFF) : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : (isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? UIColors.createNeonGlow(accentColor, intensity: 0.15)
                        : null,
                  ),
                  child: Text(
                    trigger,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      fontWeight: isSelected 
                          ? ThemeConstants.fontMediumWeight
                          : ThemeConstants.fontRegular,
                      color: isSelected
                          ? (isDark ? UIColors.darkText : UIColors.lightText)
                          : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark) {
    if (isDark) {
      return BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: const Color(0x14FFFFFF),
          width: 1,
        ),
      );
    } else {
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        boxShadow: UIColors.createSoftShadow(),
      );
    }
  }
}
