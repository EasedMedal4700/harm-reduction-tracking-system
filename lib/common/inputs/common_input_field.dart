import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Single-line text input field with consistent styling
/// Used for dosage, location, etc.
class CommonInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool readOnly;

  const CommonInputField({
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.obscureText = false,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.readOnly = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: TextStyle(
          color: isDark 
              ? UIColors.darkTextSecondary.withOpacity(0.5)
              : UIColors.lightTextSecondary.withOpacity(0.5),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
      ),
      style: TextStyle(
        color: isDark ? UIColors.darkText : UIColors.lightText,
        fontSize: ThemeConstants.fontLarge,
      ),
    );
  }
}
