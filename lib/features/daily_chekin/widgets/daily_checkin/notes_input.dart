// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonInputField.
import 'package:flutter/material.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/inputs/input_field.dart';
import '../../../../common/layout/common_spacer.dart';

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
    return CommonCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes (optional)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const CommonSpacer.vertical(12),
          CommonInputField(
            controller: controller,
            hintText: 'Any thoughts or observations?',
            maxLines: 3,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
