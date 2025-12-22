// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonInputField.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
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
    final t = context.theme;
    final text = context.text;
    return CommonCard(
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Notes (optional)', style: t.typography.heading4),
          CommonSpacer.vertical(t.spacing.md),
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
