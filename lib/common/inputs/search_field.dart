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
  final Color? accentColor;
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
    this.accentColor,
    this.focusNode,
    super.key,
  });

  @override
  State<CommonSearchField<T>> createState() => _CommonSearchFieldState<T>();
}

class _CommonSearchFieldState<T extends Object>
    extends State<CommonSearchField<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  bool _autoSelecting = false;
  String? _lastAutoSelectQuery;
  bool _suppressOptionsUntilUserInput = false;
  String? _suppressedText;

  void _suppressOptions() {
    if (!mounted) return;
    setState(() {
      _suppressOptionsUntilUserInput = true;
      _suppressedText = _controller.text;
    });
  }

  void _clearSuppressionIfUserInput(String newText) {
    if (!_suppressOptionsUntilUserInput) return;
    if (newText == _suppressedText) return;
    if (!mounted) return;
    setState(() {
      _suppressOptionsUntilUserInput = false;
      _suppressedText = null;
    });
  }

  void _handleSelected(T selection) {
    // Forward selection first (callers may normalize controller text).
    widget.onSelected(selection);
    // After a selection/normalization, keep the overlay closed until
    // the user types again.
    _suppressOptions();
  }

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
      _controller =
          widget.controller ?? TextEditingController(text: previousText);
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
    final accentColor = widget.accentColor ?? th.accent.primary;
    final baseFill = th.colors.surfaceVariant.withValues(alpha: 0.3);
    // If caller provided an explicit accentColor, use it exactly for the
    // fill so the field matches other UI elements (e.g., Save button).
    final fillColor = widget.accentColor == null
        ? Color.alphaBlend(
            accentColor.withValues(alpha: th.isDark ? 0.14 : 0.10),
            baseFill,
          )
        : accentColor;
    // Choose readable text/icon color on top of the fill when accent provided.
    final bool accentIsDark = widget.accentColor != null
        ? accentColor.computeLuminance() < 0.5
        : false;
    final fillTextColor = widget.accentColor != null
        ? (accentIsDark ? Colors.white : Colors.black87)
        : th.colors.textPrimary;

    return RawAutocomplete<T>(
      textEditingController: _controller,
      focusNode: _focusNode,
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<Never>.empty();
        }
        // If the text was set programmatically via selection/normalization,
        // don't immediately re-open suggestions until the user types again.
        if (_suppressOptionsUntilUserInput &&
            textEditingValue.text == _suppressedText) {
          return const Iterable<Never>.empty();
        }
        return await widget.optionsBuilder(textEditingValue.text);
      },
      displayStringForOption: widget.displayStringForOption,
      onSelected: _handleSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            // Auto-select behavior: when the user has typed text and either
            // only one option is returned or the typed text exactly matches
            // a single option, auto-select it. Guard with `_autoSelecting`
            // to avoid recursive selection loops.
            final query = value.text;
            if (query.isNotEmpty &&
                !_autoSelecting &&
                !_suppressOptionsUntilUserInput &&
                query != _lastAutoSelectQuery) {
              // Prevent rescheduling on rebuilds (e.g. cursor blink) when
              // the query hasn't changed.
              _lastAutoSelectQuery = query;

              // Run async check off the build frame.
              Future.microtask(() async {
                try {
                  final opts = await widget.optionsBuilder(query);
                  final list = opts.toList(growable: false);
                  T? match;
                  if (list.length == 1) {
                    match = list.first;
                  } else {
                    final lower = query.trim().toLowerCase();
                    for (final o in list) {
                      final label = widget
                          .displayStringForOption(o)
                          .trim()
                          .toLowerCase();
                      if (label == lower) {
                        match = o;
                        break;
                      }
                    }
                  }
                  if (match != null) {
                    _autoSelecting = true;
                    final display = widget.displayStringForOption(match);
                    // Update controller text to canonical display and notify
                    // selection.
                    controller.text = display;
                    controller.selection = TextSelection.collapsed(
                      offset: controller.text.length,
                    );
                    _handleSelected(match);
                    // Ensure subsequent rebuilds for the same display text
                    // don't reschedule auto-select work.
                    _lastAutoSelectQuery = controller.text;
                    _autoSelecting = false;
                  }
                } catch (_) {
                  // ignore
                }
              });
            }
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search...',
                labelText: widget.labelText,
                hintStyle: th.text.body.copyWith(
                  color: (widget.accentColor != null)
                      ? fillTextColor.withValues(alpha: 0.85)
                      : th.colors.textSecondary.withValues(alpha: 0.5),
                ),
                labelStyle: th.text.body.copyWith(
                  color: widget.accentColor != null
                      ? fillTextColor
                      : th.colors.textSecondary,
                ),
                prefixIcon:
                    widget.prefixIcon ??
                    Icon(
                      Icons.search,
                      color: widget.accentColor != null
                          ? fillTextColor
                          : th.colors.textSecondary,
                    ),
                suffixIcon: value.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: fillTextColor),
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
                  borderSide: BorderSide(color: accentColor, width: 2),
                ),
                filled: true,
                fillColor: fillColor,
              ),
              style: th.text.bodyLarge.copyWith(
                color: fillTextColor,
                fontSize: 18.0,
              ),
              onChanged: (v) {
                _clearSuppressionIfUserInput(v);
                widget.onChanged?.call(v);
              },
              onFieldSubmitted: (_) => onFieldSubmitted(),
              cursorColor: accentColor,
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
