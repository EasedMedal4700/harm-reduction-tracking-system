// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonPrimaryButton.
import 'package:flutter/material.dart';
import '../../../../common/buttons/common_primary_button.dart';

class SaveButton extends StatelessWidget {
  final bool isSaving;
  final bool isDisabled;
  final VoidCallback onPressed;
  const SaveButton({
    super.key,
    required this.isSaving,
    required this.isDisabled,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return CommonPrimaryButton(
      label: 'Save Check-In',
      onPressed: onPressed,
      isLoading: isSaving,
      isEnabled: !isDisabled,
      width: double.infinity,
    );
  }
}
