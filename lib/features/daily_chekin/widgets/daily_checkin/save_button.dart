import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

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
    final c = context.colors;
    final sh = context.shapes;
    final text = context.text;
    final acc = context.accent;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isSaving || isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: acc.primary,
          foregroundColor: c.textInverse,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              sh.radiusLg,
            ),
          ),
          disabledBackgroundColor: c.surfaceVariant,
        ),
        child: isSaving
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    c.textInverse,
                  ),
                ),
              )
            : Text(
                'Save Check-In',
                style: text.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}


