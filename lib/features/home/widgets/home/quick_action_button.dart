// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Initial migration header added. No theme extension or common component usage yet.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../../../common/buttons/common_primary_button.dart';

class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    final sp = context.spacing;
    return Padding(
      padding: EdgeInsets.only(bottom: sp.sm),
      child: CommonPrimaryButton(
        onPressed: onPressed,
        icon: icon,
        label: label,
      ),
    );
  }
}
