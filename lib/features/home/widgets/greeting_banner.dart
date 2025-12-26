// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully migrated to AppThemeExtension. AppTheme parameter removed.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
/// Animated greeting banner with time-based message
class GreetingBanner extends StatelessWidget {
  final String? userName;
  const GreetingBanner({super.key, this.userName});
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
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    final greeting = _getGreeting();
    final displayName = userName ?? 'there';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: sp.lg, vertical: sp.md),
      padding: EdgeInsets.all(sp.xl),
      decoration: BoxDecoration(
        gradient: th.accent.gradient,
        borderRadius: BorderRadius.circular(sh.radiusLg),
        boxShadow: th.cardShadow,
      ),
      child: Row(
        children: [
          // Greeting icon
          Container(
            padding: EdgeInsets.all(sp.md),
            decoration: BoxDecoration(
              color: c.surface.withValues(alpha: th.isDark ? 0.3 : 0.5),
              borderRadius: BorderRadius.circular(sh.radiusMd),
            ),
            child: Icon(_getGreetingIcon(), size: sp.lg, color: c.textInverse),
          ),
          SizedBox(width: sp.lg),
          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
              children: [
                Text(
                  greeting,
                  style: tx.heading3.copyWith(color: c.textInverse),
                ),
                SizedBox(height: sp.xs),
                Text(
                  displayName,
                  style: tx.bodyLarge.copyWith(
                    color: c.textInverse.withValues(alpha: 0.9),
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
