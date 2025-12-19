
// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';

class LogEntryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSimpleMode;
  final ValueChanged<bool> onSimpleModeChanged;

  const LogEntryAppBar({
    super.key,
    required this.isSimpleMode,
    required this.onSimpleModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return AppBar(
      elevation: t.sizes.elevationNone,
      backgroundColor: t.colors.surface,
      foregroundColor: t.colors.textPrimary,
      centerTitle: false,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Log Entry",
            style: t.text.heading2,
          ),
          Text(
            "Add a new substance record",
            style: t.text.bodySmall.copyWith(
              color: t.colors.textSecondary,
            ),
          ),
        ],
      ),

      actions: [
        Padding(
          padding: EdgeInsets.only(
            right: t.spacing.lg,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.md,
              vertical: t.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: t.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(t.shapes.radiusMd),
              border: Border.all(
                color: t.colors.border,
              ),
            ),
            child: Row(
              children: [
                Text(
                  "Simple",
                  style: t.typography.bodySmall.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
                CommonSpacer.horizontal(t.spacing.sm),
                Switch(
                  value: isSimpleMode,
                  onChanged: onSimpleModeChanged,
                  activeTrackColor: t.colors.info,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
