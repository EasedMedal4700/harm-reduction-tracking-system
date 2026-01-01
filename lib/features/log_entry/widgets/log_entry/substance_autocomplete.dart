// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Substance autocomplete widget.
import 'package:flutter/material.dart';
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
    final th = context.theme;
    final c = th.c;
    final ac = th.accent;
    final sh = th.shapes;
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return options.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (
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
                prefixIcon: Icon(Icons.science, color: ac.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  borderSide: BorderSide(color: c.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sh.radiusMd),
                  borderSide: BorderSide(
                    color: ac.primary,
                    width: th.borders.medium,
                  ),
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
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options,
          ) {
            return Align(
              alignment: sh.alignmentTopLeft,
              child: Material(
                elevation: th.sizes.cardElevation,
                borderRadius: BorderRadius.circular(sh.radiusMd),
                color: c.surface,
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width -
                      th.sp.xl, // Match page padding on both sides
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
                          padding: EdgeInsets.all(th.sp.lg),
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
