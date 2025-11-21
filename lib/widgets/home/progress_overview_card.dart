import 'package:flutter/material.dart';
import '../../styles/app_theme.dart';
import '../../constants/app_theme_constants.dart';

/// Stats card showing key metrics
class StatsCard extends StatelessWidget {
  final AppTheme theme;
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatsCard({
    required this.theme,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? theme.accent.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(theme.spacing.lg),
        decoration: theme.cardDecoration(),
        child: Row(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(theme.spacing.sm),
              decoration: BoxDecoration(
                color: color.withOpacity(theme.isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(AppThemeConstants.radiusSm),
              ),
              child: Icon(
                icon,
                size: AppThemeConstants.iconMd,
                color: color,
              ),
            ),
            
            SizedBox(width: theme.spacing.md),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.typography.bodySmall,
                  ),
                  SizedBox(height: theme.spacing.xs),
                  Text(
                    value,
                    style: theme.typography.heading3,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: theme.spacing.xs),
                    Text(
                      subtitle!,
                      style: theme.typography.caption,
                    ),
                  ],
                ],
              ),
            ),
            
            // Arrow if tappable
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: theme.colors.textTertiary,
                size: AppThemeConstants.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}

/// Progress overview card
class ProgressOverviewCard extends StatelessWidget {
  final AppTheme theme;
  final List<StatsData> stats;

  const ProgressOverviewCard({
    required this.theme,
    required this.stats,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: theme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.only(bottom: theme.spacing.md),
            child: Text(
              'Your Progress',
              style: theme.typography.heading3,
            ),
          ),
          
          // Stats cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            separatorBuilder: (context, index) => SizedBox(height: theme.spacing.md),
            itemBuilder: (context, index) {
              final stat = stats[index];
              return StatsCard(
                theme: theme,
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
