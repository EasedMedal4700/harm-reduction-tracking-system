import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Modern card widget for form sections with glassmorphism effect
class ModernFormCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color? accentColor;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ModernFormCard({
    super.key,
    this.title,
    this.icon,
    this.accentColor,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveAccentColor = accentColor ??
        (isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue);

    return Container(
      margin: margin ??
          EdgeInsets.only(
            bottom: ThemeConstants.space16,
            left: ThemeConstants.space16,
            right: ThemeConstants.space16,
          ),
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: effectiveAccentColor,
              radius: ThemeConstants.radiusLarge,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLarge),
              border: Border.all(color: UIColors.lightBorder),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || icon != null)
            Container(
              padding: EdgeInsets.all(ThemeConstants.space16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(ThemeConstants.space8),
                      decoration: BoxDecoration(
                        color: effectiveAccentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: effectiveAccentColor,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                  ],
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: ThemeConstants.fontLarge,
                          fontWeight: ThemeConstants.fontSemiBold,
                          color: isDark ? UIColors.darkText : UIColors.lightText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Padding(
            padding: padding ?? EdgeInsets.all(ThemeConstants.space16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Modern text field with consistent styling
class ModernTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const ModernTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
        ],
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          style: TextStyle(
            color: isDark ? UIColors.darkText : UIColors.lightText,
            fontSize: ThemeConstants.fontMedium,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDark
                ? UIColors.darkSurface.withValues(alpha: 0.3)
                : UIColors.lightSurface,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space16,
              vertical: ThemeConstants.space12,
            ),
          ),
        ),
      ],
    );
  }
}

/// Modern dropdown field with consistent styling
class ModernDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  const ModernDropdownField({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              fontWeight: ThemeConstants.fontMediumWeight,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          SizedBox(height: ThemeConstants.space8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemLabel(item)),
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark
                  ? UIColors.darkTextSecondary
                  : UIColors.lightTextSecondary,
            ),
            filled: true,
            fillColor: isDark
                ? UIColors.darkSurface.withValues(alpha: 0.3)
                : UIColors.lightSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
              borderSide: BorderSide(
                color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space16,
              vertical: ThemeConstants.space12,
            ),
          ),
          style: TextStyle(
            color: isDark ? UIColors.darkText : UIColors.lightText,
            fontSize: ThemeConstants.fontMedium,
          ),
          dropdownColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        ),
      ],
    );
  }
}

/// Modern slider with label and value display
class ModernSlider extends StatelessWidget {
  final String? label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final String Function(double)? valueLabel;
  final Color? accentColor;

  const ModernSlider({
    super.key,
    this.label,
    required this.value,
    this.min = 0.0,
    this.max = 10.0,
    this.divisions,
    this.onChanged,
    this.valueLabel,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveAccentColor = accentColor ??
        (isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontMediumWeight,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              Text(
                valueLabel?.call(value) ?? value.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                  color: effectiveAccentColor,
                ),
              ),
            ],
          ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: effectiveAccentColor,
          inactiveColor: effectiveAccentColor.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
