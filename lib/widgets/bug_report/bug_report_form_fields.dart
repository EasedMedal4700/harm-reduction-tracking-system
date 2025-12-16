import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';

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
    final t = AppTheme.of(context);
    
    return Column(
      children: [
        // Title
        TextFormField(
          controller: titleController,
          style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          decoration: InputDecoration(
            labelText: 'Bug Title *',
            hintText: 'Brief description of the issue',
            prefixIcon: Icon(Icons.title, color: t.colors.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.primary, width: 2),
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
        SizedBox(height: t.spacing.m),

        // Severity
        DropdownButtonFormField<String>(
          value: severity,
          style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          decoration: InputDecoration(
            labelText: 'Severity',
            prefixIcon: Icon(Icons.priority_high, color: t.colors.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.primary, width: 2),
            ),
          ),
          items: severityLevels.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Row(
                children: [
                  getSeverityIcon(level),
                  SizedBox(width: t.spacing.s),
                  Text(level, style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface)),
                ],
              ),
            );
          }).toList(),
          onChanged: onSeverityChanged,
        ),
        SizedBox(height: t.spacing.m),

        // Category
        DropdownButtonFormField<String>(
          value: category,
          style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          decoration: InputDecoration(
            labelText: 'Category',
            prefixIcon: Icon(Icons.category, color: t.colors.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.primary, width: 2),
            ),
          ),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat, style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface)),
            );
          }).toList(),
          onChanged: onCategoryChanged,
        ),
        SizedBox(height: t.spacing.m),
        
        // Description
        TextFormField(
          controller: descriptionController,
          style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description',
            hintText: 'Detailed explanation of what happened',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 48), // Align icon to top
              child: Icon(Icons.description, color: t.colors.onSurfaceVariant),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.primary, width: 2),
            ),
          ),
        ),
        SizedBox(height: t.spacing.m),
        
        // Steps to Reproduce
        TextFormField(
          controller: stepsController,
          style: t.typography.bodyMedium.copyWith(color: t.colors.onSurface),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Steps to Reproduce',
            hintText: '1. Go to screen X\n2. Click button Y',
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 48), // Align icon to top
              child: Icon(Icons.format_list_numbered, color: t.colors.onSurfaceVariant),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.shapes.radiusM),
              borderSide: BorderSide(color: t.colors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
