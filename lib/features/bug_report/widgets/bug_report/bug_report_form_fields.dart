import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Uses CommonInputField and CommonSpacer.
import 'package:mobile_drug_use_app/common/inputs/input_field.dart';
import 'package:mobile_drug_use_app/common/inputs/dropdown.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';

class BugReportFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController stepsController;
  final String severity;
  final String category;
  final List<String> severityLevels;
  final List<String> categories;
  final ValueChanged<String?> onSeverityChanged;
  final ValueChanged<String?> onCategoryChanged;
  final Widget Function(String) getSeverityIcon;
  const BugReportFormFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.stepsController,
    required this.severity,
    required this.category,
    required this.severityLevels,
    required this.categories,
    required this.onSeverityChanged,
    required this.onCategoryChanged,
    required this.getSeverityIcon,
  });
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    return Column(
      children: [
        // Title
        CommonInputField(
          controller: titleController,
          labelText: 'Bug Title *',
          hintText: 'Brief description of the issue',
          prefixIcon: Icon(Icons.title, color: c.textSecondary),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const CommonSpacer.vertical(16),
        // Severity
        CommonDropdown<String>(
          value: severity,
          items: severityLevels,
          onChanged: onSeverityChanged,
          itemBuilder: (context, level) {
            return Row(
              children: [
                getSeverityIcon(level),
                const CommonSpacer.horizontal(8),
                Text(level, style: tx.body.copyWith(color: c.textPrimary)),
              ],
            );
          },
          hintText: 'Severity',
        ),
        const CommonSpacer.vertical(16),
        // Category
        CommonDropdown<String>(
          value: category,
          items: categories,
          onChanged: onCategoryChanged,
          hintText: 'Category',
        ),
        const CommonSpacer.vertical(16),
        // Description
        CommonInputField(
          controller: descriptionController,
          labelText: 'Description',
          hintText: 'Detailed explanation of what happened',
          maxLines: 3,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: 48), // Align icon to top
            child: Icon(Icons.description, color: c.textSecondary),
          ),
        ),
        const CommonSpacer.vertical(16),
        // Steps to Reproduce
        CommonInputField(
          controller: stepsController,
          labelText: 'Steps to Reproduce',
          hintText: '1. Go to screen X\n2. Click button Y',
          maxLines: 3,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: 48), // Align icon to top
            child: Icon(Icons.format_list_numbered, color: c.textSecondary),
          ),
        ),
      ],
    );
  }
}
