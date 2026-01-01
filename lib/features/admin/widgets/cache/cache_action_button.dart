// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Wrapper around common buttons (no custom button styling).
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/buttons/common_outlined_button.dart';

/// Action button for cache management operations
class CacheActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const CacheActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return CommonOutlinedButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      height: context.sizes.buttonHeightSm,
      color: color,
      borderColor: color.withValues(alpha: context.opacities.border),
    );
  }
}
