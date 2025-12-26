// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Common UI component.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

class CommonBottomBar extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const CommonBottomBar({required this.child, this.padding, super.key});
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return Container(
      padding: padding ?? EdgeInsets.all(th.spacing.lg),
      decoration: BoxDecoration(
        color: th.colors.surface,
        border: Border(top: BorderSide(color: th.colors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: child,
    );
  }
}
