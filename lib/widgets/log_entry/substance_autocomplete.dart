import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/app_theme.dart';
import '../../providers/drug/drug_names_provider.dart';
import '../../providers/drug/substance_controller.dart';
import '../../providers/drug/substance_normalization_provider.dart';
import '../../providers/drug/substance_validation_provider.dart';

class SubstanceAutocomplete extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onSubstanceChanged;

  const SubstanceAutocomplete({
    super.key,
    this.controller,
    required this.onSubstanceChanged,
  });

  @override
  ConsumerState<SubstanceAutocomplete> createState() => _SubstanceAutocompleteState();
}

class _SubstanceAutocompleteState extends ConsumerState<SubstanceAutocomplete> {
  @override
  Widget build(BuildContext context) {
    final t = AppTheme.of(context);
    final currentValue = ref.watch(substanceControllerProvider);

    // Get validator function using the current value
    final validatorFn = ref.watch(substanceValidationProvider(currentValue));

    // Execute validator function
    final validationError = validatorFn(currentValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          initialValue: widget.controller != null
              ? TextEditingValue(text: widget.controller!.text)
              : TextEditingValue(text: currentValue),

          optionsBuilder: (TextEditingValue query) {
            final q = query.text.trim();

            // empty -> return all names
            return ref
                .read(drugNamesProvider)
                .maybeWhen(
                  data: (names) => names,
                  orElse: () => const <String>[],
                )
                .where((name) =>
                    q.isEmpty || name.toLowerCase().contains(q.toLowerCase()))
                .take(30)
                .toList();
          },

          onSelected: (selection) async {
            // Normalize alias  canonical
            final results = await ref.read(substanceSearchProvider(selection).future);
            
            if (!mounted) return;

            if (results.isNotEmpty) {
              final normalized = results.first.canonicalName;

              ref
                  .read(substanceControllerProvider.notifier)
                  .setSubstance(normalized);

              widget.onSubstanceChanged(normalized);

              if (widget.controller != null) {
                widget.controller!.text = normalized;
              }

              // Show alias normalization message
              final isAlias = results.first.isAlias;
              if (isAlias) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Normalized "\" to "\"',
                      style: t.typography.bodyMedium.copyWith(color: t.colors.onInverseSurface),
                    ),
                    backgroundColor: t.colors.inverseSurface,
                  ),
                );
              }
            }
          },

          displayStringForOption: (option) => option,

          fieldViewBuilder: (context, textCtrl, focusNode, onSubmit) {
            // Sync external controller (if passed)
            if (widget.controller != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && widget.controller!.text != textCtrl.text) {
                  textCtrl.text = widget.controller!.text;
                }
              });
            }

            return TextFormField(
              controller: widget.controller ?? textCtrl,
              focusNode: focusNode,
              style: t.typography.bodyLarge,
              decoration: InputDecoration(
                labelText: 'Substance',
                suffixIcon: Icon(Icons.search, color: t.colors.onSurfaceVariant),
                errorText: validationError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusM),
                ),
              ),
              onChanged: (value) {
                ref.read(substanceControllerProvider.notifier).setSubstance(value);
                widget.onSubstanceChanged(value);
              },
            );
          },

          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                color: t.colors.surfaceContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusM),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - (t.spacing.m * 2),
                  height: 250,
                  child: ListView(
                    padding: EdgeInsets.all(t.spacing.xs),
                    children: options
                        .map(
                          (opt) => ListTile(
                            title: Text(opt, style: t.typography.bodyMedium),
                            leading: Icon(Icons.medication, color: t.colors.primary),
                            onTap: () => onSelected(opt),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(t.shapes.radiusS),
                            ),
                            hoverColor: t.colors.surfaceContainerHighest,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
