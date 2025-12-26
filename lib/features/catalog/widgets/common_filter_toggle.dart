// MIGRATION: COMPLETE
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Migrated to CommonCard and CommonSpacer.
import 'package:flutter/material.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../common/cards/common_card.dart';
import '../../../common/layout/common_spacer.dart';

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
    final tx = context.text;
    final th = context.theme;
    final accentColor = th.accent.primary;
    return CommonCard(
      padding: EdgeInsets.symmetric(
        horizontal: th.spacing.md,
        vertical: th.spacing.sm,
      ),
      borderColor: showCommonOnly ? accentColor : th.colors.border,
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            color: showCommonOnly ? accentColor : th.colors.textSecondary,
            size: th.sizes.iconSm,
          ),
          const CommonSpacer.horizontal(16),
          Expanded(
            child: Text(
              'Common Only',
              style: th.tx.body.copyWith(
                color: th.colors.textPrimary,
                fontWeight: tx.bodyMedium.fontWeight,
              ),
            ),
          ),
          Switch(
            value: showCommonOnly,
            onChanged: onChanged,
            activeThumbColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: th.opacities.slow),
          ),
        ],
      ),
    );
  }
}
