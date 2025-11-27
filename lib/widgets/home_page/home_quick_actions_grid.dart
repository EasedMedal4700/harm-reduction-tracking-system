import 'package:flutter/material.dart';
import '../../constants/theme_constants.dart';
import '../home_redesign/quick_action_card.dart';

class HomeQuickActionsGrid extends StatelessWidget {
  final VoidCallback onLogEntry;
  final VoidCallback onReflection;
  final VoidCallback onAnalytics;
  final VoidCallback onCravings;
  final VoidCallback onActivity;
  final VoidCallback onLibrary;
  final VoidCallback onCatalog;
  final VoidCallback onBloodLevels;

  const HomeQuickActionsGrid({
    super.key,
    required this.onLogEntry,
    required this.onReflection,
    required this.onAnalytics,
    required this.onCravings,
    required this.onActivity,
    required this.onLibrary,
    required this.onCatalog,
    required this.onBloodLevels,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: ThemeConstants.quickActionSpacing,
      mainAxisSpacing: ThemeConstants.quickActionSpacing,
      childAspectRatio: 1.1,
      children: [
        QuickActionCard(
          actionKey: 'log_usage',
          icon: Icons.note_add,
          label: 'Log Entry',
          onTap: onLogEntry,
        ),
        QuickActionCard(
          actionKey: 'reflection',
          icon: Icons.self_improvement,
          label: 'Reflection',
          onTap: onReflection,
        ),
        QuickActionCard(
          actionKey: 'analytics',
          icon: Icons.analytics,
          label: 'Analytics',
          onTap: onAnalytics,
        ),
        QuickActionCard(
          actionKey: 'cravings',
          icon: Icons.local_fire_department,
          label: 'Cravings',
          onTap: onCravings,
        ),
        QuickActionCard(
          actionKey: 'activity',
          icon: Icons.directions_run,
          label: 'Activity',
          onTap: onActivity,
        ),
        QuickActionCard(
          actionKey: 'library',
          icon: Icons.menu_book,
          label: 'Library',
          onTap: onLibrary,
        ),
        QuickActionCard(
          actionKey: 'catalog',
          icon: Icons.inventory,
          label: 'Catalog',
          onTap: onCatalog,
        ),
        QuickActionCard(
          actionKey: 'blood_levels',
          icon: Icons.bloodtype,
          label: 'Blood Levels',
          onTap: onBloodLevels,
        ),
      ],
    );
  }
}
