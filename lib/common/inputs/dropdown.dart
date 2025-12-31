// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class CommonDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T)? itemLabel;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String? hintText;
  final FormFieldValidator<T>? validator;
  final Color? accentColor;
  final bool enabled;
  const CommonDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
    this.itemBuilder,
    this.hintText,
    this.validator,
    this.accentColor,
    this.enabled = true,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final accent = accentColor;
    final baseFill = th.colors.surfaceVariant.withValues(alpha: 0.3);
    final fillColor = accent == null
        ? baseFill
        : Color.alphaBlend(
            accent.withValues(alpha: th.isDark ? 0.14 : 0.10),
            baseFill,
          );
    final uniqueItems = <T>[];
    for (final item in items) {
      if (!uniqueItems.contains(item)) {
        uniqueItems.add(item);
      }
    }
    final selectedMatches = value == null
        ? 0
        : uniqueItems.where((item) => item == value).length;
    final safeValue = selectedMatches == 1 ? value : null;
    return DropdownButtonFormField<T>(
      initialValue: safeValue,
      items: uniqueItems.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: itemBuilder != null
              ? itemBuilder!(context, item)
              : Text(
                  itemLabel != null ? itemLabel!(item) : item.toString(),
                  style: th.text.body.copyWith(color: th.colors.textPrimary),
                ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
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
          borderSide: BorderSide(color: accent ?? th.accent.primary, width: 2),
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(
          horizontal: th.spacing.md,
          vertical: th.spacing.md,
        ),
      ),
      style: th.text.body.copyWith(color: th.colors.textPrimary),
      dropdownColor: th.colors.surface,
      icon: Icon(Icons.arrow_drop_down, color: th.colors.textSecondary),
    );
  }
}
