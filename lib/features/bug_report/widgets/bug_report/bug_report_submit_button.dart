// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonPrimaryButton.

import 'package:flutter/material.dart';
import '../../../../common/buttons/common_primary_button.dart';

class BugReportSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const BugReportSubmitButton({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CommonPrimaryButton(
      label: 'Submit Bug Report',
      onPressed: onSubmit,
      isLoading: isSubmitting,
      icon: Icons.bug_report,
      width: double.infinity,
    );
  }
}

