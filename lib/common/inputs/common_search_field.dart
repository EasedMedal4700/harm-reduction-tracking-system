import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
            hintStyle: TextStyle(
              color: isDark 
                  ? UIColors.darkTextSecondary.withOpacity(0.5)
                  : UIColors.lightTextSecondary.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: isDark 
                  ? UIColors.darkTextSecondary 
                  : UIColors.lightTextSecondary,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: isDark 
                          ? UIColors.darkTextSecondary 
                          : UIColors.lightTextSecondary,
                    ),
                    onPressed: () {
                      controller.clear();
                      focusNode.requestFocus();
                    },
                  )
                : null,
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
          ),
          style: TextStyle(
            color: isDark ? UIColors.darkText : UIColors.lightText,
            fontSize: ThemeConstants.fontLarge,
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
            color: isDark ? UIColors.darkSurface : Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 200,
                maxWidth: 400,
              ),
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
