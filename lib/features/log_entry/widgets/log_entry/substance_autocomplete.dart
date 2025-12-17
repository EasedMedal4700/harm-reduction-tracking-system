// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_constants.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class SubstanceAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final List<String> options;

  const SubstanceAutocomplete({
    super.key,
    required this.controller,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Keep the field seeded from the external controller.
        // Avoid attaching listeners here (build can run many times).
        if (fieldTextEditingController.text != controller.text) {
          fieldTextEditingController.text = controller.text;
          fieldTextEditingController.selection = TextSelection.collapsed(
            offset: fieldTextEditingController.text.length,
          );
        }

        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onChanged: (value) {
            if (controller.text != value) {
              controller.text = value;
            }
          },
          decoration: InputDecoration(
            labelText: 'Substance',
            prefixIcon: Icon(Icons.science, color: acc.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: acc.primary, width: AppThemeConstants.borderMedium),
            ),
            filled: true,
            fillColor: c.surface,
            labelStyle: TextStyle(color: c.textSecondary),
          ),
          style: TextStyle(color: c.textPrimary),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a substance';
            }
            return null;
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(sh.radiusMd),
            color: c.surface,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - (sp.md * 2), // Adjust width based on padding
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      onSelected(option);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        option,
                        style: TextStyle(color: c.textPrimary),
                      ),
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
