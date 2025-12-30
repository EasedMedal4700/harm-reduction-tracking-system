// MIGRATION:
// State: MODERN (UI-only)
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: UI-only button.
import 'package:flutter/material.dart';
import '../../../common/buttons/common_primary_button.dart';

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
