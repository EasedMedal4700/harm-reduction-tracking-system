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
    final th = context.theme;
    final sh = th.sh;
    // If unit options are provided, render a combined control (text field + dropdown)
    if (units != null && onUnitChanged != null) {
      return Container(
        decoration: BoxDecoration(
          color: th.c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(color: th.c.border, width: th.borders.thin),
        ),
        padding: EdgeInsets.symmetric(horizontal: th.sp.md, vertical: th.sp.sm),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: th.sp.sm),
              child: Icon(
                Icons.scale,
                color: th.ac.primary,
                size: th.sizes.iconMd,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration.collapsed(hintText: 'Dosage'),
                style: th.tx.bodyMedium.copyWith(color: th.c.textPrimary),
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
              height: th.sizes.iconMd + th.sp.md,
              width: th.borders.thin,
              color: th.c.border,
              margin: EdgeInsets.symmetric(horizontal: th.sp.md),
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
                style: th.tx.bodyMedium.copyWith(color: th.c.textPrimary),
                iconEnabledColor: th.c.textSecondary,
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
        prefixIcon: Icon(Icons.scale, color: th.ac.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
          borderSide: BorderSide(color: th.c.border, width: th.borders.thin),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
          borderSide: BorderSide(
            color: th.ac.primary,
            width: th.borders.medium,
          ),
        ),
        filled: true,
        fillColor: th.c.surface,
        labelStyle: th.tx.label.copyWith(color: th.c.textSecondary),
      ),
      style: th.tx.bodyMedium.copyWith(color: th.c.textPrimary),
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
