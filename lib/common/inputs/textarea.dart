import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Multi-line text area for notes and longer text input
class CommonTextarea extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;

  const CommonTextarea({
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.validator,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: isDark 
              ? UIColors.darkTextSecondary.withOpacity(0.5)
              : UIColors.lightTextSecondary.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: BorderSide(
            color: isDark 
                ? const Color(0x14FFFFFF)
                : UIColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: BorderSide(
            color: isDark 
                ? const Color(0x14FFFFFF)
                : UIColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: BorderSide(
            color: isDark 
                ? UIColors.darkNeonCyan
                : UIColors.lightAccentBlue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: BorderSide(
            color: isDark 
                ? UIColors.darkNeonOrange
                : UIColors.lightAccentRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          borderSide: BorderSide(
            color: isDark 
                ? UIColors.darkNeonOrange
                : UIColors.lightAccentRed,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: isDark 
            ? const Color(0x08FFFFFF)
            : Colors.grey.shade50,
        alignLabelWithHint: true,
      ),
      style: TextStyle(
        color: isDark ? UIColors.darkText : UIColors.lightText,
        fontSize: ThemeConstants.fontMedium,
        height: 1.5,
      ),
    );
  }
}
