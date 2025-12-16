import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class ComplexFields extends StatelessWidget {
  final TextEditingController notesController;
  final TextEditingController locationController;
  final TextEditingController peopleController;
  final TextEditingController costController;
  final String? selectedRoa;
  final List<String> roaOptions;
  final ValueChanged<String?> onRoaChanged;

  const ComplexFields({
    super.key,
    required this.notesController,
    required this.locationController,
    required this.peopleController,
    required this.costController,
    required this.selectedRoa,
    required this.roaOptions,
    required this.onRoaChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final acc = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ROA Dropdown
        DropdownButtonFormField<String>(
          value: selectedRoa,
          decoration: InputDecoration(
            labelText: 'Route of Administration',
            prefixIcon: Icon(Icons.route, color: acc.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: acc.primary, width: 2),
            ),
            filled: true,
            fillColor: c.surface,
          ),
          items: roaOptions.map((String roa) {
            return DropdownMenuItem<String>(
              value: roa,
              child: Text(roa, style: TextStyle(color: c.textPrimary)),
            );
          }).toList(),
          onChanged: onRoaChanged,
          dropdownColor: c.surface,
          style: TextStyle(color: c.textPrimary),
        ),
        SizedBox(height: sp.md),

        // Location Field
        TextFormField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            prefixIcon: Icon(Icons.place, color: acc.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: acc.primary, width: 2),
            ),
            filled: true,
            fillColor: c.surface,
            labelStyle: TextStyle(color: c.textSecondary),
          ),
          style: TextStyle(color: c.textPrimary),
        ),
        SizedBox(height: sp.md),

        // People Field
        TextFormField(
          controller: peopleController,
          decoration: InputDecoration(
            labelText: 'People (comma separated)',
            prefixIcon: Icon(Icons.people, color: acc.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: acc.primary, width: 2),
            ),
            filled: true,
            fillColor: c.surface,
            labelStyle: TextStyle(color: c.textSecondary),
          ),
          style: TextStyle(color: c.textPrimary),
        ),
        SizedBox(height: sp.md),

        // Cost Field
        TextFormField(
          controller: costController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Cost',
            prefixIcon: Icon(Icons.attach_money, color: acc.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: acc.primary, width: 2),
            ),
            filled: true,
            fillColor: c.surface,
            labelStyle: TextStyle(color: c.textSecondary),
          ),
          style: TextStyle(color: c.textPrimary),
        ),
        SizedBox(height: sp.md),

        // Notes Field
        TextFormField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Notes',
            prefixIcon: Icon(Icons.note, color: acc.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: c.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sh.radiusMd),
              borderSide: BorderSide(color: acc.primary, width: 2),
            ),
            filled: true,
            fillColor: c.surface,
            labelStyle: TextStyle(color: c.textSecondary),
          ),
          style: TextStyle(color: c.textPrimary),
        ),
      ],
    );
  }
}
