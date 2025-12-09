// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Initial migration header added. Not migrated yet.
import 'package:flutter/material.dart';

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
    return Column(
      children: [
        // Title
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Bug Title *',
            hintText: 'Brief description of the issue',
            prefixIcon: const Icon(Icons.title),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLength: 100,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Severity
        DropdownButtonFormField<String>(
          value: severity,
          decoration: InputDecoration(
            labelText: 'Severity',
            prefixIcon: const Icon(Icons.priority_high),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: severityLevels.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Row(
                children: [
                  getSeverityIcon(level),
                  const SizedBox(width: 8),
                  Text(level),
                ],
              ),
            );
          }).toList(),
          onChanged: onSeverityChanged,
        ),
        const SizedBox(height: 16),

        // Category
        DropdownButtonFormField<String>(
          value: category,
          decoration: InputDecoration(
            labelText: 'Category',
            prefixIcon: const Icon(Icons.category),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat),
            );
          }).toList(),
          onChanged: onCategoryChanged,
        ),
        const SizedBox(height: 16),

        // Description
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'Description *',
            hintText: 'What happened? What did you expect to happen?',
            prefixIcon: const Icon(Icons.description),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          maxLength: 500,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please describe the bug';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Steps to Reproduce
        TextFormField(
          controller: stepsController,
          decoration: InputDecoration(
            labelText: 'Steps to Reproduce (Optional)',
            hintText: '1. Go to...\n2. Click on...\n3. See error...',
            prefixIcon: const Icon(Icons.format_list_numbered),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          maxLength: 300,
        ),
      ],
    );
  }
}
