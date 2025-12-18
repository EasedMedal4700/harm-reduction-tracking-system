import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.md,
        vertical: t.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(
          color: showCommonOnly ? accentColor : t.colors.border,
        ),
        boxShadow: t.cardShadow,
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list_rounded,
            color: showCommonOnly
                ? accentColor
                : t.colors.textSecondary,
            size: 20,
          ),
          SizedBox(width: t.spacing.md),
          Expanded(
            child: Text(
              'Common Only',
              style: t.text.body.copyWith(
                color: t.colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: showCommonOnly,
            onChanged: onChanged,
            activeThumbColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
