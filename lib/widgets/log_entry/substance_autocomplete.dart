import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/drug/drug_names_provider.dart';
import '../../providers/drug/substance_controller.dart';
import '../../providers/drug/substance_normalization_provider.dart';
import '../../providers/drug/substance_validation_provider.dart';

class SubstanceAutocomplete extends ConsumerWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onSubstanceChanged;

  const SubstanceAutocomplete({
    super.key,
    this.controller,
    required this.onSubstanceChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final currentValue = ref.watch(substanceControllerProvider);

  // Get validator function using the current value
  final validatorFn = ref.watch(substanceValidationProvider(currentValue));

  // Execute validator function
  final validationError = validatorFn(currentValue);



    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          initialValue: controller != null
              ? TextEditingValue(text: controller!.text)
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

          onSelected: (selection) {
            // Normalize alias → canonical
            ref
                .read(substanceSearchProvider(selection).future)
                .then((results) {
              if (results.isNotEmpty) {
                final normalized = results.first.canonicalName;

                ref
                    .read(substanceControllerProvider.notifier)
                    .setSubstance(normalized);

                onSubstanceChanged(normalized);

                if (controller != null) {
                  controller!.text = normalized;
                }

                // Show alias normalization message
                final isAlias = results.first.isAlias;
                if (isAlias) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Normalized "$selection" to "$normalized"',
                      ),
                    ),
                  );
                }
              }
            });
          },

          displayStringForOption: (option) => option,

          fieldViewBuilder: (context, textCtrl, focusNode, onSubmit) {
            // Sync external controller (if passed)
            if (controller != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller!.text != textCtrl.text) {
                  textCtrl.text = controller!.text;
                }
              });
            }

            return TextFormField(
              controller: controller ?? textCtrl,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Substance',
                suffixIcon: const Icon(Icons.search),
                errorText: validationError,
              ),
              onChanged: (value) {
                ref.read(substanceControllerProvider.notifier).setSubstance(value);
                onSubstanceChanged(value);
              },
            );
          },

          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                child: SizedBox(
                  height: 250,
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: options
                        .map(
                          (opt) => ListTile(
                            title: Text(opt),
                            leading: const Icon(Icons.medication),
                            onTap: () => onSelected(opt),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          },
        ),

        if (validationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              validationError,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
