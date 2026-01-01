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
  final Color? categoryAccent;
  final IconData? categoryIcon;

  const LogEntryAppBar({
    super.key,
    required this.isSimpleMode,
    required this.onSimpleModeChanged,
    this.categoryAccent,
    this.categoryIcon,
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
            // Blend the category accent over the surface with a medium opacity
            // to create a stronger but still matte background without magic numbers.
            color: categoryAccent == null
                ? th.c.surface
                : Color.alphaBlend(
                    categoryAccent!.withValues(alpha: th.opacities.medium),
                    th.c.surface,
                  ),
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
                // Menu (clickable)
                Builder(
                  builder: (ctx) => IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.menu,
                      color: th.c.textPrimary,
                      size: th.sizes.iconMd,
                    ),
                    onPressed: () {
                      final scaffold = Scaffold.maybeOf(ctx);
                      if (scaffold != null && scaffold.hasDrawer) {
                        scaffold.openDrawer();
                      }
                    },
                  ),
                ),

                CommonSpacer.horizontal(th.sp.md),

                // Icon badge
                Container(
                  padding: EdgeInsets.all(th.sp.sm),
                  decoration: BoxDecoration(
                    color: categoryAccent == null
                        ? th.c.info.withValues(alpha: th.opacities.veryLow)
                        : Color.alphaBlend(
                            categoryAccent!.withValues(
                              alpha: th.opacities.high,
                            ),
                            th.c.surface,
                          ),
                    shape: BoxShape.circle,
                  ),
                  child: Builder(
                    builder: (ctx) {
                      final accent = categoryAccent;
                      final badgeIconColor = accent == null
                          ? th.c.info
                          : (accent.computeLuminance() < 0.5
                                ? th.c.textInverse
                                : th.c.textPrimary);
                      return Icon(
                        categoryIcon ?? Icons.medication,
                        color: badgeIconColor,
                        size: th.sizes.iconSm,
                      );
                    },
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
                      // subtitle removed per design
                    ],
                  ),
                ),

                // simple toggle removed — show full form
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
