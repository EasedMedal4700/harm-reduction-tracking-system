import 'package:flutter/material.dart';
import '../../states/log_entry_state.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

class SaveButton extends StatelessWidget {
  final bool isDark;
  final LogEntryState state;

  const SaveButton({
    super.key,
    required this.isDark,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
        onPressed: () => state.save(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? UIColors.darkNeonBlue
              : UIColors.lightAccentBlue,
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
              'Save Changes',
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
