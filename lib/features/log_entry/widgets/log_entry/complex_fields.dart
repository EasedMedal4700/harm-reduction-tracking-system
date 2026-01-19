// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Complex fields for log entry.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';

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
    final th = context.theme;
    final c = th.c;
    final ac = th.accent;
    final sh = th.shapes;
    return Column(
      crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
      children: [
        // ROA Dropdown
        CommonDropdown<String>(
          value: selectedRoa,
          items: roaOptions,
          onChanged: onRoaChanged,
          hintText: 'Route of Administration',
        ),
        SizedBox(height: th.sp.md),
        // Location Field
        TextFormField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            prefixIcon: Icon(Icons.place, color: ac.primary),
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
            labelStyle: th.tx.label.copyWith(color: c.textSecondary),
          ),
          style: th.tx.bodyMedium.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: th.sp.md),
        // People Field
        TextFormField(
          controller: peopleController,
          decoration: InputDecoration(
            labelText: 'People (comma separated)',
            prefixIcon: Icon(Icons.people, color: ac.primary),
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
            labelStyle: th.tx.label.copyWith(color: c.textSecondary),
          ),
          style: th.tx.bodyMedium.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: th.sp.md),
        // Cost Field
        TextFormField(
          controller: costController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Cost',
            prefixIcon: Icon(Icons.attach_money, color: ac.primary),
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
            labelStyle: th.tx.label.copyWith(color: c.textSecondary),
          ),
          style: th.tx.bodyMedium.copyWith(color: c.textPrimary),
        ),
        SizedBox(height: th.sp.md),
        // Notes Field
        TextFormField(
          controller: notesController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Notes',
            prefixIcon: Icon(Icons.note, color: ac.primary),
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
            labelStyle: th.tx.label.copyWith(color: c.textSecondary),
          ),
          style: th.tx.bodyMedium.copyWith(color: c.textPrimary),
        ),
      ],
    );
  }
}
