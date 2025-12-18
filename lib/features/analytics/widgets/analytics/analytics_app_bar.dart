
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-compliant. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../constants/enums/time_period.dart';

class AnalyticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TimePeriod selectedPeriod;
  final ValueChanged<TimePeriod> onPeriodChanged;
  final VoidCallback? onExport;

  const AnalyticsAppBar({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.onExport,
  });

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final acc = context.accent;
    final theme = context.theme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + sp.md,
        left: sp.lg,
        right: sp.lg,
        bottom: sp.md,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          bottom: BorderSide(
            color: c.border,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TOP ROW
            Row(
              children: [
                /// Hamburger (drawer)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp.sm),
                    boxShadow: theme.cardShadow,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: acc.primary, size: 24),
                    padding: EdgeInsets.all(sp.sm),
                    constraints: const BoxConstraints(),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),

                SizedBox(width: sp.md),

                /// Title
                Expanded(
                  child: Text(
                    'DRUG USE ANALYTICS',
                    style: text.heading3.copyWith(
                      color: c.textPrimary,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                /// Export button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp.sm),
                    boxShadow: theme.cardShadow,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.file_download_outlined,
                      color: acc.primary,
                      size: 20,
                    ),
                    padding: EdgeInsets.all(sp.sm),
                    constraints: const BoxConstraints(),
                    onPressed: onExport,
                  ),
                ),
              ],
            ),

            SizedBox(height: sp.sm),

            /// Subtitle
            Text(
              'Analyze your pharmacological activity',
              style: text.caption.copyWith(
                color: c.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
