// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

class CommonLoader extends StatelessWidget {
  final Color? color;
  final double? size;
  const CommonLoader({this.color, this.size, super.key});
  @override
  Widget build(BuildContext context) {
    final ac = context.accent;
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(color: color ?? ac.primary),
      ),
    );
  }
}
