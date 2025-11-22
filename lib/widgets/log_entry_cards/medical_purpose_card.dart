import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Simple medical purpose toggle card for simple mode
class MedicalPurposeCard extends StatelessWidget {
  final bool isMedicalPurpose;
  final ValueChanged<bool> onChanged;

  const MedicalPurposeCard({
    required this.isMedicalPurpose,
    required this.onChanged,
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
            'Purpose',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          
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
              onChanged: onChanged,
              activeColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
            ),
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
