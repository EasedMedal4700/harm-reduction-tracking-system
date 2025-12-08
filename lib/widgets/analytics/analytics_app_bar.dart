// MIGRATION — Replaces all legacy colors & spacing with AppTheme system.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/emus/time_period.dart';

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
    final t = context.theme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + t.spacing.md,
        left: t.spacing.lg,
        right: t.spacing.lg,
        bottom: t.spacing.md,
      ),
      decoration: BoxDecoration(
        color: t.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: t.colors.border,
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
                    borderRadius: BorderRadius.circular(t.spacing.sm),
                    boxShadow: t.cardShadow,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.menu, color: t.accent.primary, size: 24),
                    padding: EdgeInsets.all(t.spacing.sm),
                    constraints: const BoxConstraints(),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),

                SizedBox(width: t.spacing.md),

                /// Title
                Expanded(
                  child: Text(
                    'DRUG USE ANALYTICS',
                    style: t.typography.heading3.copyWith(
                      color: t.colors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                /// Export button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(t.spacing.sm),
                    boxShadow: t.cardShadow,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.file_download_outlined,
                        color: t.accent.primary, size: 20),
                    padding: EdgeInsets.all(t.spacing.sm),
                    constraints: const BoxConstraints(),
                    onPressed: onExport,
                  ),
                ),
              ],
            ),

            SizedBox(height: t.spacing.sm),

            /// Subtitle
            Text(
              'Analyze your pharmacological activity',
              style: t.typography.caption.copyWith(
                color: t.colors.textSecondary,
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
