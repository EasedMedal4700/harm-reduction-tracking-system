import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../constants/config/feature_flags.dart';

import '../../services/feature_flag_service.dart';
import '../../services/user_service.dart';
import '../home_redesign/quick_action_card.dart';

class HomeQuickActionsGrid extends StatefulWidget {
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
  State<HomeQuickActionsGrid> createState() => _HomeQuickActionsGridState();
}

class _HomeQuickActionsGridState extends State<HomeQuickActionsGrid> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadAdminStatus();
  }

  Future<void> _loadAdminStatus() async {
    final isAdmin = await UserService.isAdmin();
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define all quick actions with their feature flags
    final allActions = [
      _QuickAction('log_usage', Icons.note_add, 'Log Entry', 
          widget.onLogEntry, FeatureFlags.logEntryPage),
      _QuickAction('reflection', Icons.self_improvement, 'Reflection', 
          widget.onReflection, FeatureFlags.reflectionPage),
      _QuickAction('analytics', Icons.analytics, 'Analytics', 
          widget.onAnalytics, FeatureFlags.analyticsPage),
      _QuickAction('cravings', Icons.local_fire_department, 'Cravings', 
          widget.onCravings, FeatureFlags.cravingsPage),
      _QuickAction('activity', Icons.directions_run, 'Activity', 
          widget.onActivity, FeatureFlags.activityPage),
      _QuickAction('library', Icons.menu_book, 'Library', 
          widget.onLibrary, FeatureFlags.personalLibraryPage),
      _QuickAction('catalog', Icons.inventory, 'Catalog', 
          widget.onCatalog, FeatureFlags.catalogPage),
      _QuickAction('blood_levels', Icons.bloodtype, 'Blood Levels', 
          widget.onBloodLevels, FeatureFlags.bloodLevelsPage),
    ];

    return Consumer<FeatureFlagService>(
      builder: (context, flags, _) {
        // Filter actions based on feature flags
        final enabledActions = allActions.where((action) =>
          flags.isEnabled(action.flagName, isAdmin: _isAdmin)).toList();

        if (enabledActions.isEmpty) {
          return const SizedBox.shrink();
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: context.spacing.md,
          mainAxisSpacing: context.spacing.md,
          childAspectRatio: 1.1,
          children: enabledActions.map((action) => QuickActionCard(
            actionKey: action.key,
            icon: action.icon,
            label: action.label,
            onTap: action.onTap,
          )).toList(),
        );
      },
    );
  }
}

/// Helper class to hold quick action data.
class _QuickAction {
  final String key;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String flagName;

  const _QuickAction(this.key, this.icon, this.label, this.onTap, this.flagName);
}


