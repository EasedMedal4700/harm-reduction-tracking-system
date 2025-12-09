import 'package:flutter/material.dart';
class NotesInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const NotesInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notes (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Any thoughts or observations?',
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Review for theme/context migration if needed.
