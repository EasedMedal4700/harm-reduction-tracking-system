// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class DosageInput extends StatelessWidget {
  final TextEditingController controller;
  final String unit;

  const DosageInput({
    super.key,
    required this.controller,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    // sp unused
    final sh = context.shapes;

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Dosage ($unit)',
        prefixIcon: Icon(Icons.scale, color: acc.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
          borderSide: BorderSide(color: acc.primary, width: context.borders.medium),
        ),
        filled: true,
        fillColor: c.surface,
        labelStyle: TextStyle(color: c.textSecondary),
      ),
      style: TextStyle(color: c.textPrimary),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter dosage';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
