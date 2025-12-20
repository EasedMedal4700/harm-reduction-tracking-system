import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

/// Search field with autocomplete support
class CommonSearchField<T extends Object> extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Future<Iterable<T>> Function(String) optionsBuilder;
  final Widget Function(BuildContext, T) itemBuilder;
  final ValueChanged<T> onSelected;
  final String Function(T) displayStringForOption;
  final FocusNode? focusNode;

  const CommonSearchField({
    required this.optionsBuilder,
    required this.itemBuilder,
    required this.onSelected,
    required this.displayStringForOption,
    this.controller,
    this.hintText,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Never>.empty();
        }
        return await optionsBuilder(textEditingValue.text);
      },
      displayStringForOption: displayStringForOption,
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText ?? 'Search...',
            hintStyle: t.text.body.copyWith(
              color: t.colors.textSecondary.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(Icons.search, color: t.colors.textSecondary),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: t.colors.textSecondary),
                    onPressed: () {
                      controller.clear();
                      focusNode.requestFocus();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.colors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.colors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              borderSide: BorderSide(color: t.accent.primary, width: 2),
            ),
            filled: true,
            fillColor: t.colors.surfaceVariant.withValues(alpha: 0.3),
          ),
          style: t.text.bodyLarge.copyWith(
            color: t.colors.textPrimary,
            fontSize: 18.0,
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
          cursorColor: t.accent.primary,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(t.shapes.radiusMd),
            color: t.colors.surface,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200, maxWidth: 400),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: itemBuilder(context, option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
