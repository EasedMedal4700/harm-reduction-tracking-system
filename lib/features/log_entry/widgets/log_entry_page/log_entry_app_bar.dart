// MIGRATION:
// State: MODERN
// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Pill-style log entry app bar (no magic numbers).

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
    final th = context.theme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.all(th.sp.md),
        child: Container(
          height: preferredSize.height,
          decoration: BoxDecoration(
            color: th.c.surface,
            borderRadius: BorderRadius.circular(th.sh.radiusLg),
            boxShadow: [
              BoxShadow(
                color: th.c.overlayHeavy,
                blurRadius: th.sizes.blurRadiusMd,
                offset: Offset(0, th.sizes.elevationSm),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: th.sp.lg,
              vertical: th.sp.md,
            ),
            child: Row(
              children: [
                // Menu
                Icon(
                  Icons.menu,
                  color: th.c.textPrimary,
                  size: th.sizes.iconMd,
                ),

                CommonSpacer.horizontal(th.sp.md),

                // Icon badge
                Container(
                  padding: EdgeInsets.all(th.sp.sm),
                  decoration: BoxDecoration(
                    color: th.c.info.withValues(alpha: th.opacities.veryLow),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medication,
                    color: th.c.info,
                    size: th.sizes.iconSm,
                  ),
                ),

                CommonSpacer.horizontal(th.sp.md),

                // Title
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log use',
                        style: th.text.heading3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Add a new substance record',
                        style: th.text.bodySmall.copyWith(
                          color: th.c.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Simple toggle pill
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: th.sp.md,
                    vertical: th.sp.xs,
                  ),
                  decoration: BoxDecoration(
                    color: th.c.surfaceVariant,
                    borderRadius: BorderRadius.circular(th.sh.radiusFull),
                    border: Border.all(color: th.c.border),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Simple',
                        style: th.text.bodySmall.copyWith(
                          color: th.c.textSecondary,
                        ),
                      ),
                      CommonSpacer.horizontal(th.sp.xs),
                      Switch(
                        value: isSimpleMode,
                        onChanged: onSimpleModeChanged,
                        activeThumbColor: th.c.info,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(96.0);
}
