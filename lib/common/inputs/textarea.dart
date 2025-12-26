// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
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
        hintStyle: th.text.body.copyWith(
          color: th.colors.textSecondary.withValues(alpha: 0.5),
        ),
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
        alignLabelWithHint: true,
      ),
      style: th.text.body.copyWith(color: th.colors.textPrimary, height: 1.5),
      cursorColor: th.accent.primary,
    );
  }
}
