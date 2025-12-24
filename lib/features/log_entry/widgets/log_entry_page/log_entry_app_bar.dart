// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
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
    final th = context.theme;
    return AppBar(
      elevation: th.sizes.elevationNone,
      backgroundColor: th.colors.surface,
      foregroundColor: th.colors.textPrimary,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text("Log Entry", style: th.text.heading2),
          Text(
            "Add a new substance record",
            style: th.text.bodySmall.copyWith(color: th.colors.textSecondary),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: th.spacing.lg),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: th.spacing.md,
              vertical: th.spacing.xs,
            ),
            decoration: BoxDecoration(
              color: th.colors.surfaceVariant,
              borderRadius: BorderRadius.circular(th.shapes.radiusMd),
              border: Border.all(color: th.colors.border),
            ),
            child: Row(
              children: [
                Text(
                  "Simple",
                  style: th.typography.bodySmall.copyWith(
                    color: th.colors.textSecondary,
                  ),
                ),
                CommonSpacer.horizontal(th.spacing.sm),
                Switch(
                  value: isSimpleMode,
                  onChanged: onSimpleModeChanged,
                  activeTrackColor: th.colors.info,
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
