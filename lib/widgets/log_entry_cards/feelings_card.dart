import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/data/drug_use_catalog.dart';

/// Feelings selection card with emoji buttons
class FeelingsCard extends StatelessWidget {
  final List<String> feelings;
  final Map<String, List<String>> secondaryFeelings;
  final ValueChanged<List<String>> onFeelingsChanged;
  final ValueChanged<Map<String, List<String>>> onSecondaryFeelingsChanged;

  const FeelingsCard({
    required this.feelings,
    required this.secondaryFeelings,
    required this.onFeelingsChanged,
    required this.onSecondaryFeelingsChanged,
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
            'How are you feeling?',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Primary feelings
          GridView.count(
            crossAxisCount: 2,  // 2 buttons per row
            shrinkWrap: true,    // Fits content height
            physics: const NeverScrollableScrollPhysics(),  // No scrolling
            childAspectRatio: 3.0,  // Adjust for button height (taller for wider buttons)
            mainAxisSpacing: ThemeConstants.space8,  // Vertical spacing between rows
            crossAxisSpacing: ThemeConstants.space8, // Horizontal spacing between buttons
            children: DrugUseCatalog.primaryEmotions.map((emotion) {
              final emotionName = emotion['name']!;
              final emoji = emotion['emoji']!;
              final isSelected = feelings.contains(emotionName);
              final accentColor = _getEmotionColor(emotionName, isDark);
              
              return _buildFeelingButton(
                context,
                isDark,
                emotionName,
                emoji,
                isSelected,
                accentColor,
              );
            }).toList(),
          ),
          
          // Secondary feelings for selected primary feelings
          if (feelings.isNotEmpty) ...[
            const SizedBox(height: ThemeConstants.space16),
            ...feelings.map((primaryFeeling) {
              final secondaryOptions = DrugUseCatalog.secondaryEmotions[primaryFeeling] ?? [];
              final selectedSecondary = secondaryFeelings[primaryFeeling] ?? [];
              
              if (secondaryOptions.isEmpty) return const SizedBox.shrink();
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More specific ($primaryFeeling):',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      color: isDark 
                          ? UIColors.darkTextSecondary 
                          : UIColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.space8),
                  Wrap(
                    spacing: ThemeConstants.space8,
                    runSpacing: ThemeConstants.space8,
                    children: secondaryOptions.map((secondary) {
                      final isSelected = selectedSecondary.contains(secondary);
                      
                      return _buildSecondaryChip(
                        context,
                        isDark,
                        secondary,
                        isSelected,
                        primaryFeeling,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: ThemeConstants.space12),
                ],
              );
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildFeelingButton(
    BuildContext context,
    bool isDark,
    String emotionName,
    String emoji,
    bool isSelected,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: () {
        final newFeelings = List<String>.from(feelings);
        if (isSelected) {
          newFeelings.remove(emotionName);
          // Also remove secondary feelings for this primary
          final newSecondary = Map<String, List<String>>.from(secondaryFeelings);
          newSecondary.remove(emotionName);
          onSecondaryFeelingsChanged(newSecondary);
        } else {
          newFeelings.add(emotionName);
        }
        onFeelingsChanged(newFeelings);
      },
      child: AnimatedContainer(
        duration: ThemeConstants.animationFast,
        width: double.infinity,  // Fill the grid cell width (50%)
        padding: const EdgeInsets.symmetric(
          horizontal: ButtonConstants.buttonPaddingHorizontal,
          vertical: ButtonConstants.buttonPaddingVertical,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? accentColor.withOpacity(0.15) : accentColor.withOpacity(0.1))
              : (isDark ? const Color(0x08FFFFFF) : UIColors.lightSurface),
          borderRadius: BorderRadius.circular(ButtonConstants.buttonBorderRadius),
          border: Border.all(
            color: isSelected
                ? accentColor
                : (isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? UIColors.createNeonGlow(accentColor, intensity: 0.2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: ThemeConstants.space8),
            Text(
              emotionName.toUpperCase(),
              style: TextStyle(
                fontSize: ButtonConstants.buttonFontSize,
                fontWeight: ButtonConstants.buttonFontWeight,
                color: isSelected
                    ? (isDark ? UIColors.darkText : UIColors.lightText)
                    : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryChip(
    BuildContext context,
    bool isDark,
    String secondary,
    bool isSelected,
    String primaryFeeling,
  ) {
    final accentColor = _getEmotionColor(primaryFeeling, isDark);
    
    return GestureDetector(
      onTap: () {
        final newSecondary = Map<String, List<String>>.from(secondaryFeelings);
        final currentList = List<String>.from(newSecondary[primaryFeeling] ?? []);
        
        if (isSelected) {
          currentList.remove(secondary);
        } else {
          currentList.add(secondary);
        }
        
        newSecondary[primaryFeeling] = currentList;
        onSecondaryFeelingsChanged(newSecondary);
      },
      child: AnimatedContainer(
        duration: ThemeConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space12,
          vertical: ThemeConstants.space8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? accentColor.withOpacity(0.1) : accentColor.withOpacity(0.08))
              : (isDark ? const Color(0x05FFFFFF) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          border: Border.all(
            color: isSelected
                ? accentColor.withOpacity(0.5)
                : (isDark ? const Color(0x0AFFFFFF) : Colors.grey.shade300),
            width: 1,
          ),
        ),
        child: Text(
          secondary,
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
  }

  Color _getEmotionColor(String emotion, bool isDark) {
    if (isDark) {
      switch (emotion) {
        case 'Happy': return UIColors.darkNeonGreen;
        case 'Calm': return UIColors.darkNeonCyan;
        case 'Anxious': return UIColors.darkNeonOrange;
        case 'Surprised': return UIColors.darkNeonLavender;
        case 'Sad': return UIColors.darkNeonBlue;
        case 'Disgusted': return UIColors.darkNeonTeal;
        case 'Angry': return const Color(0xFFFF6B6B);
        case 'Excited': return UIColors.darkNeonPink;
        default: return UIColors.darkNeonBlue;
      }
    } else {
      switch (emotion) {
        case 'Happy': return UIColors.lightAccentGreen;
        case 'Calm': return UIColors.lightAccentTeal;
        case 'Anxious': return UIColors.lightAccentOrange;
        case 'Surprised': return UIColors.lightAccentPurple;
        case 'Sad': return UIColors.lightAccentBlue;
        case 'Disgusted': return Colors.teal;
        case 'Angry': return UIColors.lightAccentRed;
        case 'Excited': return Colors.pink;
        default: return UIColors.lightAccentBlue;
      }
    }
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
