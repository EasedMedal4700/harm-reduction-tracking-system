// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
  final ValueChanged<String>? onFieldSubmitted;
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
    this.onFieldSubmitted,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
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
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        hintStyle: th.text.body.copyWith(
          color: th.colors.textSecondary.withValues(alpha: 0.5),
        ),
        labelStyle: th.text.body.copyWith(color: th.colors.textSecondary),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          borderSide: BorderSide(color: th.colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          borderSide: BorderSide(color: th.colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          borderSide: BorderSide(color: th.accent.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          borderSide: BorderSide(color: th.colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          borderSide: BorderSide(color: th.colors.error, width: 2),
        ),
        filled: true,
        fillColor: th.colors.surfaceVariant.withValues(alpha: 0.3),
        contentPadding: EdgeInsets.symmetric(
          horizontal: th.spacing.md,
          vertical: th.spacing.md,
        ),
      ),
      style: th.text.bodyLarge.copyWith(
        color: th.colors.textPrimary,
        fontSize: 18.0,
      ),
      cursorColor: th.accent.primary,
    );
  }
}
