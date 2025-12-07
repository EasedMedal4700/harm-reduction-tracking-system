import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/body_and_mind_catalog.dart';

/// Body signals selection card
class BodySignalsCard extends StatelessWidget {
  final List<String> selectedBodySignals;
  final ValueChanged<List<String>> onBodySignalsChanged;

  const BodySignalsCard({
    required this.selectedBodySignals,
    required this.onBodySignalsChanged,
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
            'Body Signals',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          Text(
            'Physical sensations you experienced',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark 
                  ? UIColors.darkTextSecondary 
                  : UIColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Body signals chips
          Wrap(
            spacing: ThemeConstants.space8,
            runSpacing: ThemeConstants.space8,
            children: physicalSensations.map((signal) {
              final isSelected = selectedBodySignals.contains(signal);
              final accentColor = isDark 
                  ? UIColors.darkNeonTeal 
                  : UIColors.lightAccentTeal;
              
              return GestureDetector(
                onTap: () {
                  final newBodySignals = List<String>.from(selectedBodySignals);
                  if (isSelected) {
                    newBodySignals.remove(signal);
                  } else {
                    newBodySignals.add(signal);
                  }
                  onBodySignalsChanged(newBodySignals);
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
                    signal,
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
