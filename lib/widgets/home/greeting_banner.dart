// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';
import '../../constants/theme/app_theme_constants.dart';

/// Animated greeting banner with time-based message
class GreetingBanner extends StatelessWidget {
  final AppTheme theme;
  final String? userName;

  const GreetingBanner({
    required this.theme,
    this.userName,
    super.key,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 17) return Icons.wb_sunny_outlined;
    if (hour < 21) return Icons.nights_stay;
    return Icons.bedtime;
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final displayName = userName ?? 'there';

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: theme.spacing.lg,
        vertical: theme.spacing.md,
      ),
      padding: EdgeInsets.all(theme.spacing.xl),
      decoration: theme.gradientCardDecoration(useAccentGradient: true),
      child: Row(
        children: [
          // Greeting icon
          Container(
            padding: EdgeInsets.all(theme.spacing.md),
            decoration: BoxDecoration(
              color: theme.colors.surface.withOpacity(theme.isDark ? 0.3 : 0.5),
              borderRadius: BorderRadius.circular(AppThemeConstants.radiusMd),
            ),
            child: Icon(
              _getGreetingIcon(),
              size: AppThemeConstants.iconLg,
              color: theme.colors.textInverse,
            ),
          ),
          
          SizedBox(width: theme.spacing.lg),
          
          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.typography.heading3.copyWith(
                    color: theme.colors.textInverse,
                  ),
                ),
                SizedBox(height: theme.spacing.xs),
                Text(
                  displayName,
                  style: theme.typography.bodyLarge.copyWith(
                    color: theme.colors.textInverse.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
