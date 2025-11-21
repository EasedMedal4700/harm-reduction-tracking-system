import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

/// Notes text field card
class NotesCard extends StatelessWidget {
  final TextEditingController notesCtrl;

  const NotesCard({
    required this.notesCtrl,
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
            'Additional Notes',
            style: TextStyle(
              fontSize: ThemeConstants.fontXLarge,
              fontWeight: ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          Text(
            'Any other details worth recording',
            style: TextStyle(
              fontSize: ThemeConstants.fontSmall,
              color: isDark 
                  ? UIColors.darkTextSecondary 
                  : UIColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: ThemeConstants.space12),
          
          // Notes text field
          TextFormField(
            controller: notesCtrl,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter any additional notes...',
              hintStyle: TextStyle(
                color: isDark 
                    ? UIColors.darkTextSecondary.withOpacity(0.5)
                    : UIColors.lightTextSecondary.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
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
              filled: true,
              fillColor: isDark ? const Color(0x08FFFFFF) : Colors.grey.shade50,
            ),
            style: TextStyle(
              color: isDark ? UIColors.darkText : UIColors.lightText,
              fontSize: ThemeConstants.fontMedium,
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
