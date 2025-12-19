// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.

import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/cards/common_card.dart';
import '../../../../common/layout/common_spacer.dart';

class CommonFilterToggle extends StatelessWidget {
  final bool showCommonOnly;
  final ValueChanged<bool> onChanged;

  const CommonFilterToggle({
    super.key,
    required this.showCommonOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final accentColor = t.accent.primary;

    return CommonCard(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.md,
        vertical: t.spacing.sm,
      ),
      borderColor: showCommonOnly ? accentColor : t.colors.border,
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            color: showCommonOnly
                ? accentColor
                : t.colors.textSecondary,
            size: t.sizes.iconSm,
          ),
          const CommonSpacer.horizontal(16),
          Expanded(
            child: Text(
              'Common Only',
              style: t.text.body.copyWith(
                color: t.colors.textPrimary,
                fontWeight: text.bodyMedium.fontWeight,
              ),
            ),
          ),
          Switch(
            value: showCommonOnly,
            onChanged: onChanged,
            activeThumbColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: t.opacities.slow),
          ),
        ],
      ),
    );
  }
}
