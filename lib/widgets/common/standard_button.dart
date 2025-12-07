import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

class StandardButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  
  const StandardButton({
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? ButtonConstants.getPrimaryColor(isDark) : ButtonConstants.getSecondaryColor(isDark),
        padding: const EdgeInsets.symmetric(
          horizontal: ButtonConstants.buttonPaddingHorizontal,
          vertical: ButtonConstants.buttonPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ButtonConstants.buttonBorderRadius),
        ),
      ),
      child: Text(text, style: TextStyle(fontSize: ButtonConstants.buttonFontSize, fontWeight: ButtonConstants.buttonFontWeight)),
    );
  }
}