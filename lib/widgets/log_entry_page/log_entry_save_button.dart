import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

class LogEntrySaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const LogEntrySaveButton({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save),
            const SizedBox(width: ThemeConstants.space8),
            Text(
              'Save Entry',
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
