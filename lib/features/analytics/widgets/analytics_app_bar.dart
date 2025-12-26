// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-compliant. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../constants/theme/app_theme_extension.dart';
import '../../../constants/enums/time_period.dart';
import 'package:mobile_drug_use_app/common/buttons/common_icon_button.dart';
import '../../../common/layout/common_spacer.dart';

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
    final tx = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final ac = context.accent;
    final th = context.theme;
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
          bottom: BorderSide(color: c.border, width: context.borders.thin),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
          mainAxisSize: AppLayout.mainAxisSizeMin,
          children: [
            /// TOP ROW
            Row(
              children: [
                /// Hamburger (drawer)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp.sm),
                    boxShadow: th.cardShadow,
                  ),
                  child: CommonIconButton(
                    icon: Icons.menu,
                    color: ac.primary,
                    size: context.sizes.iconMd,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                CommonSpacer.horizontal(sp.md),

                /// Title
                Expanded(
                  child: Text(
                    'DRUG USE ANALYTICS',
                    style: tx.heading3.copyWith(
                      color: c.textPrimary,
                      letterSpacing: context.sizes.letterSpacingMd,
                    ),
                    maxLines: 1,
                    overflow: AppLayout.textOverflowEllipsis,
                  ),
                ),

                /// Export button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp.sm),
                    boxShadow: th.cardShadow,
                  ),
                  child: CommonIconButton(
                    icon: Icons.file_download_outlined,
                    color: ac.primary,
                    size: context.sizes.iconMd,
                    onPressed: onExport,
                  ),
                ),
              ],
            ),
            CommonSpacer.vertical(sp.sm),

            /// Subtitle
            Text(
              'Analyze your pharmacological activity',
              style: tx.caption.copyWith(color: c.textSecondary),
              maxLines: 1,
              overflow: AppLayout.textOverflowEllipsis,
            ),
          ],
        ),
      ),
    );
  }
}
