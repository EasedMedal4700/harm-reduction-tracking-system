// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Refactored to use CommonBottomBar and CommonPrimaryButton.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/common/layout/common_bottom_bar.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';

/// Riverpod-ready Save Button
/// Accepts callback instead of state
class SaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const SaveButton({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return CommonBottomBar(
      child: CommonPrimaryButton(
        onPressed: onSave,
        label: 'Save Changes',
        icon: Icons.save,
      ),
    );
  }
}

