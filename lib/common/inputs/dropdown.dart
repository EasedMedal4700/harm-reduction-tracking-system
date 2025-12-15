import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

/// Dropdown selector with consistent styling
class CommonDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabel;
  final String? hintText;
  final FormFieldValidator<T>? validator;
  final bool enabled;

  const CommonDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
    this.hintText,
    this.validator,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel != null ? itemLabel!(item) : item.toString(),
            style: t.text.body.copyWith(
              color: t.colors.textPrimary,
            ),
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: t.text.body.copyWith(
          color: t.colors.textSecondary.withOpacity(0.5),
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
        filled: true,
        fillColor: t.colors.surfaceVariant.withOpacity(0.3),
        contentPadding: EdgeInsets.symmetric(
          horizontal: t.spacing.md,
          vertical: t.spacing.md,
        ),
      ),
      style: t.text.body.copyWith(
        color: t.colors.textPrimary,
      ),
      dropdownColor: t.colors.surface,
      icon: Icon(
        Icons.arrow_drop_down,
        color: t.colors.textSecondary,
      ),
    );
  }
}
