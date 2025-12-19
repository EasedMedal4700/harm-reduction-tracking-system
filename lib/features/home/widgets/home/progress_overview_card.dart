import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppThemeExtension. AppTheme parameters removed.

/// Stats card showing key metrics
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final text = context.text;

    final effectiveIconColor = iconColor ?? t.accent.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(sh.radiusMd),
      child: Container(
        padding: EdgeInsets.all(sp.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          boxShadow: t.cardShadow,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(sp.sm),
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(
                  alpha: t.isDark ? 0.2 : 0.1,
                ),
                borderRadius: BorderRadius.circular(sh.radiusSm),
              ),
              child: Icon(
                icon,
                size: sp.md,
                color: effectiveIconColor,
              ),
            ),

            SizedBox(width: sp.md),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  Text(
                    title,
                    style: text.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  SizedBox(height: sp.xs),
                  Text(
                    value,
                    style: text.heading3.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: sp.xs),
                    Text(
                      subtitle!,
                      style: text.caption.copyWith(
                        color: c.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow if tappable
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: c.textTertiary,
                size: sp.md,
              ),
          ],
        ),
      ),
    );
  }
}

/// Progress overview card
class ProgressOverviewCard extends StatelessWidget {
  final List<StatsData> stats;

  const ProgressOverviewCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;
    final text = context.text;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.only(bottom: sp.md),
            child: Text(
              'Your Progress',
              style: text.heading3,
            ),
          ),

          // Stats cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            separatorBuilder: (_, __) => SizedBox(height: sp.md),
            itemBuilder: (context, index) {
              final stat = stats[index];
              return StatsCard(
                title: stat.title,
                value: stat.value,
                subtitle: stat.subtitle,
                icon: stat.icon,
                iconColor: stat.color,
                onTap: stat.onTap,
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Data class for stats
class StatsData {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const StatsData({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color,
    this.onTap,
  });
}
