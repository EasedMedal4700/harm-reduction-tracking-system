import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Reusable section widget for settings page
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;
    final sh = context.shapes;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
      color: c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sh.radiusMd),
        side: BorderSide(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(sp.md),
            child: Row(
              children: [
                Icon(icon, color: a.primary),
                SizedBox(width: sp.sm),
                Text(
                  title,
                  style: t.typography.heading4.copyWith(
                    color: c.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: c.border),
          ...children,
        ],
      ),
    );
  }
}
