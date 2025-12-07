import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DropdownButtonFormField<T>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel != null ? itemLabel!(item) : item.toString(),
            style: TextStyle(
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
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
        filled: true,
        fillColor: isDark 
            ? const Color(0x08FFFFFF)
            : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space12,
          vertical: ThemeConstants.space12,
        ),
      ),
      style: TextStyle(
        color: isDark ? UIColors.darkText : UIColors.lightText,
        fontSize: ThemeConstants.fontMedium,
      ),
      dropdownColor: isDark ? UIColors.darkSurface : Colors.white,
      icon: Icon(
        Icons.arrow_drop_down,
        color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
      ),
    );
  }
}
