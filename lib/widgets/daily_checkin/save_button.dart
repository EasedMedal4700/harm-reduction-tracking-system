
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';



class SaveButton extends StatelessWidget {
  final bool isSaving;
  final bool isDisabled;
  final VoidCallback onPressed;

  const SaveButton({
    super.key,
    required this.isSaving,
    required this.isDisabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSaving || isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? UIColors.darkNeonCyan
              : UIColors.lightAccentBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.radiusLarge,
            ),
          ),
          disabledBackgroundColor: isDark
              ? Colors.white10
              : Colors.grey[300],
        ),
        child: isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : const Text(
                'Save Check-In',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
      ),
    );
  }
}
