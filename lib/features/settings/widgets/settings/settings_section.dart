import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:flutter/material.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../common/widgets/common_spacer.dart';
import '../../../../common/cards/common_card.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm),
      child: CommonCard(
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          children: [
          Padding(
            padding: EdgeInsets.all(sp.md),
            child: Row(
              children: [
                Icon(icon, color: a.primary, size: t.sizes.iconMd),
                CommonSpacer.horizontal(sp.sm),
                Text(
                  title,
                  style: t.typography.heading4.copyWith(
                    color: c.textPrimary,
                    fontWeight: text.bodyBold.fontWeight,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: t.borders.thin, color: c.border),
          ...children,
        ],
      ),
      ),
    );
  }
}
