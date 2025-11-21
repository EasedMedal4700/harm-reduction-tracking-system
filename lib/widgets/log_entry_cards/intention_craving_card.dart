import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';
import '../../constants/body_and_mind_catalog.dart';

/// Intention and craving intensity card
class IntentionCravingCard extends StatelessWidget {
  final String? intention;
  final double cravingIntensity;
  final bool isMedicalPurpose;
  final ValueChanged<String?> onIntentionChanged;
  final ValueChanged<double> onCravingIntensityChanged;
  final ValueChanged<bool> onMedicalPurposeChanged;

  const IntentionCravingCard({
    required this.intention,
    required this.cravingIntensity,
    required this.isMedicalPurpose,
    required this.onIntentionChanged,
    required this.onCravingIntensityChanged,
    required this.onMedicalPurposeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final validIntention = intentions.contains(intention) ? intention : null;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
      decoration: _buildDecoration(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Intention & Purpose',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Medical purpose toggle
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0x08FFFFFF) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              border: Border.all(
                color: isMedicalPurpose
                    ? (isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen)
                    : (isDark ? const Color(0x14FFFFFF) : UIColors.lightBorder),
                width: isMedicalPurpose ? 2 : 1,
              ),
            ),
            child: SwitchListTile(
              title: Text(
                'Medical Purpose',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: isMedicalPurpose 
                      ? ThemeConstants.fontSemiBold 
                      : ThemeConstants.fontRegular,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              subtitle: Text(
                'Prescribed or therapeutic use',
                style: TextStyle(
                  fontSize: ThemeConstants.fontSmall,
                  color: isDark 
                      ? UIColors.darkTextSecondary 
                      : UIColors.lightTextSecondary,
                ),
              ),
              value: isMedicalPurpose,
              onChanged: onMedicalPurposeChanged,
              activeColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space16),
          
          // Intention dropdown
          DropdownButtonFormField<String>(
            value: validIntention,
            decoration: InputDecoration(
              labelText: 'Intention',
              hintText: 'Select your intention',
              hintStyle: TextStyle(
                color: isDark 
                    ? UIColors.darkTextSecondary.withOpacity(0.5)
                    : UIColors.lightTextSecondary.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              ),
            ),
            style: TextStyle(
              color: isDark ? UIColors.darkText : UIColors.lightText,
              fontSize: ThemeConstants.fontMedium,
            ),
            dropdownColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
            items: intentions.map((i) {
              return DropdownMenuItem(
                value: i,
                child: Text(i),
              );
            }).toList(),
            onChanged: onIntentionChanged,
          ),
          
          const SizedBox(height: ThemeConstants.space16),
          
          // Craving intensity slider
          Text(
            'Craving Intensity',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: isDark 
                        ? UIColors.darkNeonOrange 
                        : UIColors.lightAccentOrange,
                    inactiveTrackColor: isDark 
                        ? const Color(0x14FFFFFF) 
                        : Colors.grey.shade300,
                    thumbColor: isDark 
                        ? UIColors.darkNeonOrange 
                        : UIColors.lightAccentOrange,
                    overlayColor: isDark 
                        ? UIColors.darkNeonOrange.withOpacity(0.2)
                        : UIColors.lightAccentOrange.withOpacity(0.2),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: cravingIntensity,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: onCravingIntensityChanged,
                  ),
                ),
              ),
              const SizedBox(width: ThemeConstants.space12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space12,
                  vertical: ThemeConstants.space8,
                ),
                decoration: BoxDecoration(
                  color: isDark 
                      ? UIColors.darkNeonOrange.withOpacity(0.15)
                      : UIColors.lightAccentOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                  border: Border.all(
                    color: isDark 
                        ? UIColors.darkNeonOrange 
                        : UIColors.lightAccentOrange,
                  ),
                ),
                child: Text(
                  cravingIntensity.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: ThemeConstants.fontMedium,
                    fontWeight: ThemeConstants.fontSemiBold,
                    color: isDark ? UIColors.darkText : UIColors.lightText,
                  ),
                ),
              ),
            ],
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
