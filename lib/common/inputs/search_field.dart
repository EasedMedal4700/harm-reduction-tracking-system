// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class CommonSearchField<T extends Object> extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
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
    this.labelText,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.focusNode,
    super.key,
  });

  @override
  State<CommonSearchField<T>> createState() => _CommonSearchFieldState<T>();
}

class _CommonSearchFieldState<T extends Object> extends State<CommonSearchField<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _ownsController = widget.controller == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _ownsFocusNode = widget.focusNode == null;
  }

  @override
  void didUpdateWidget(covariant CommonSearchField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      final previousText = _controller.text;
      if (_ownsController) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController(text: previousText);
      _ownsController = widget.controller == null;
    }

    if (oldWidget.focusNode != widget.focusNode) {
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _ownsFocusNode = widget.focusNode == null;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    return RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Never>.empty();
        }
        return await widget.optionsBuilder(textEditingValue.text);
      },
      displayStringForOption: widget.displayStringForOption,
      onSelected: widget.onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search...',
                labelText: widget.labelText,
                hintStyle: th.text.body.copyWith(
                  color: th.colors.textSecondary.withValues(alpha: 0.5),
                ),
                labelStyle: th.text.body.copyWith(color: th.colors.textSecondary),
                prefixIcon:
                    widget.prefixIcon ??
                    Icon(Icons.search, color: th.colors.textSecondary),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: th.colors.textSecondary),
                        onPressed: () {
                          controller.clear();
                          widget.onChanged?.call('');
                          focusNode.requestFocus();
                        },
                      )
                    : null,
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
                filled: true,
                fillColor: th.colors.surfaceVariant.withValues(alpha: 0.3),
              ),
              style: th.text.bodyLarge.copyWith(
                color: th.colors.textPrimary,
                fontSize: 18.0,
              ),
              onChanged: widget.onChanged,
              onFieldSubmitted: (_) => onFieldSubmitted(),
              cursorColor: th.accent.primary,
            );
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(th.shapes.radiusMd),
            color: th.colors.surface,
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
                      child: widget.itemBuilder(context, option),
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
