import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

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
    final t = context.theme;
    
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
        hintStyle: t.text.body.copyWith(
          color: t.colors.textSecondary.withValues(alpha: 0.5),
        ),
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
        alignLabelWithHint: true,
      ),
      style: t.text.body.copyWith(
        color: t.colors.textPrimary,
        height: 1.5,
      ),
      cursorColor: t.accent.primary,
    );
  }
}
