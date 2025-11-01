// filepath: c:\Users\user\Desktop\Power BI\mobile_drug_use_app\lib\widgets\log_entry\substance_autocomplete.dart
import 'package:flutter/material.dart';
import '../../constants/drug_use_catalog.dart';
import '../../utils/entry_validation.dart';

class SubstanceAutocomplete extends StatelessWidget {
  final String substance;
  final ValueChanged<String> onSubstanceChanged;

  const SubstanceAutocomplete({
    super.key,
    required this.substance,
    required this.onSubstanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return DrugUseCatalog.substances.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (selection) => onSubstanceChanged(selection),
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(labelText: 'Substance'),
          validator: ValidationUtils.validateSubstance,
          onChanged: onSubstanceChanged,
        );
      },
    );
  }
}