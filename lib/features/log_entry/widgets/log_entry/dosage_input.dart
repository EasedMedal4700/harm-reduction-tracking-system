// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Dosage input widget.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class DosageInput extends StatelessWidget {
  final TextEditingController controller;
  final String unit;
  final List<String>? units;
  final ValueChanged<String>? onUnitChanged;

  const DosageInput({
    super.key,
    required this.controller,
    required this.unit,
    this.units,
    this.onUnitChanged,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;
    // sp unused
    final sh = context.shapes;
    // If unit options are provided, render a combined control (text field + dropdown)
    if (units != null && onUnitChanged != null) {
      return Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(color: c.border),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.scale, color: ac.primary),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration.collapsed(
                  hintText: 'Dosage',
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
              ),
            ),
            Container(
              height: 32,
              width: 1,
              color: c.border,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: units!.contains(unit) ? unit : units!.first,
                items: units!
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onUnitChanged!(v);
                },
                style: TextStyle(color: c.textPrimary),
                iconEnabledColor: c.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    // Fallback: render single text field with inline unit label
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Dosage ($unit)',
        prefixIcon: Icon(Icons.scale, color: ac.primary),
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
            width: context.borders.medium,
          ),
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
