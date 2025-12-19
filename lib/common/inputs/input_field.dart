import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

/// Single-line text input field with consistent styling
/// Used for dosage, location, etc.
class CommonInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
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
    this.initialValue,
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
    final t = context.theme;
    
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
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
        hintStyle: t.text.body.copyWith(
          color: t.colors.textSecondary.withValues(alpha: 0.5),
        ),
        labelStyle: t.text.body.copyWith(
          color: t.colors.textSecondary,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          borderSide: BorderSide(
            color: t.colors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          borderSide: BorderSide(
            color: t.colors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          borderSide: BorderSide(
            color: t.accent.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          borderSide: BorderSide(
            color: t.colors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          borderSide: BorderSide(
            color: t.colors.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: t.colors.surfaceVariant.withValues(alpha: 0.3),
        contentPadding: EdgeInsets.symmetric(
          horizontal: t.spacing.md,
          vertical: t.spacing.md,
        ),
      ),
      style: t.text.bodyLarge.copyWith(
        color: t.colors.textPrimary,
        fontSize: 18.0,
      ),
      cursorColor: t.accent.primary,
    );
  }
}
