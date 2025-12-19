import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import 'package:provider/provider.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../../common/layout/common_spacer.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Admin feature flags page. Migrated to use AppTheme. No hardcoded values.
import '../../constants/config/feature_flags.dart';
import '../../services/feature_flag_service.dart';
import '../../services/user_service.dart';
// import '../../common/old_common/drawer_menu.dart'; // Removed legacy drawer

/// Admin screen for managing feature flags.
/// 
/// Allows admins to toggle feature flags on/off, which controls
/// access to various app features for non-admin users.
class FeatureFlagsScreen extends StatefulWidget {
  const FeatureFlagsScreen({super.key});

  @override
  State<FeatureFlagsScreen> createState() => _FeatureFlagsScreenState();
}

class _FeatureFlagsScreenState extends State<FeatureFlagsScreen> {
  bool _isLoading = true;
  bool _isAdmin = false;
  String? _errorMessage;
  final Map<String, bool> _pendingUpdates = {};

  @override
  void initState() {
    super.initState();
    _checkAdminAndLoad();
  }

  Future<void> _checkAdminAndLoad() async {
    final isAdmin = await UserService.isAdmin();
    
    if (!isAdmin) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Admin access required'),
            backgroundColor: context.colors.error,
          ),
        );
      }
      return;
    }

    setState(() {
      _isAdmin = isAdmin;
      _isLoading = false;
    });
  }

  Future<void> _toggleFlag(String featureName, bool newValue) async {
    setState(() {
      _pendingUpdates[featureName] = true;
    });

    try {
      final success = await featureFlagService.updateFlag(featureName, newValue);
      
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update "$featureName"'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _pendingUpdates.remove(featureName);
        });
      }
    }
  }

  Future<void> _refreshFlags() async {
    setState(() => _isLoading = true);
    await featureFlagService.refresh();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = context.text;

    if (!_isAdmin && !_isLoading) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: c.surface,
      appBar: AppBar(
        title: Text(
          'Feature Flags',
          style: text.titleLarge,
        ),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
        iconTheme: IconThemeData(color: c.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshFlags,
            tooltip: 'Refresh flags',
          ),
        ],
      ),
      // drawer: const DrawerMenu(), // Removed legacy drawer
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    return Consumer<FeatureFlagService>(
      builder: (context, flags, _) {
        if (flags.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final allFlags = flags.allFlags;
        if (allFlags.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildFlagsList(context, allFlags);
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: c.error,
            ),
            SizedBox(height: sp.md),
            Text(
              'Error Loading Flags',
              style: text.headlineMedium,
            ),
            SizedBox(height: sp.sm),
            Text(
              _errorMessage ?? 'Unknown error',
              style: text.bodyMedium.copyWith(color: c.textSecondary),
              textAlign: AppLayout.textAlignCenter,
            ),
            SizedBox(height: sp.lg),
            FilledButton.icon(
              onPressed: _refreshFlags,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(sp.lg),
        child: Column(
          mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: c.textSecondary,
            ),
            SizedBox(height: sp.md),
            Text(
              'No Feature Flags',
              style: text.headlineMedium,
            ),
            SizedBox(height: sp.sm),
            Text(
              'No feature flags found in the database.',
              style: text.bodyMedium.copyWith(color: c.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagsList(BuildContext context, List<FeatureFlag> flags) {
    final sp = context.spacing;
    // Group flags by category
    final categories = _categorizeFlags(flags);

    return ListView(
      padding: EdgeInsets.all(sp.md),
      children: [
        // Info banner
        _buildInfoBanner(context),
        SizedBox(height: sp.md),
        
        // Flag categories
        for (final entry in categories.entries) ...[
          _buildCategoryHeader(context, entry.key),
          SizedBox(height: sp.sm),
          ...entry.value.map((flag) => _buildFlagTile(context, flag)),
          SizedBox(height: sp.md),
        ],
      ],
    );
  }

  Map<String, List<FeatureFlag>> _categorizeFlags(List<FeatureFlag> flags) {
    final categories = <String, List<FeatureFlag>>{
      'Core Pages': [],
      'Data & Resources': [],
      'Advanced Features': [],
      'Authentication': [],
      'Admin': [],
    };

    for (final flag in flags) {
      final name = flag.featureName;
      if (['home_page', 'activity_page', 'cravings_page', 'reflection_page', 
           'blood_levels_page', 'log_entry_page', 'daily_checkin', 
           'checkin_history_page'].contains(name)) {
        categories['Core Pages']!.add(flag);
      } else if (['personal_library_page', 'analytics_page', 'catalog_page']
          .contains(name)) {
        categories['Data & Resources']!.add(flag);
      } else if (['physiological_page', 'interactions_page', 
           'tolerance_dashboard_page', 'wearos_page', 'bucket_details_page']
          .contains(name)) {
        categories['Advanced Features']!.add(flag);
      } else if (['login_page', 'register_page', 'onboarding_screen',
           'pin_setup_screen', 'pin_unlock_screen', 'change_pin_screen',
           'recovery_key_screen', 'encryption_migration_screen',
           'privacy_policy_screen'].contains(name)) {
        categories['Authentication']!.add(flag);
      } else if (['admin_panel'].contains(name)) {
        categories['Admin']!.add(flag);
      } else {
        // Unknown category, add to Core Pages
        categories['Core Pages']!.add(flag);
      }
    }

    // Remove empty categories
    categories.removeWhere((key, value) => value.isEmpty);
    return categories;
  }

  Widget _buildInfoBanner(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;
    final a = context.accent;

    return Container(
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: a.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: a.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: a.primary,
          ),
          CommonSpacer.horizontal(sp.md),
          Expanded(
            child: Text(
              'Disabled features will be hidden from regular users. '
              'Admins can always access all features.',
              style: text.bodySmall.copyWith(
                color: c.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String category) {
    final c = context.colors;
    final text = context.text;
    return Text(
      category,
      style: text.titleMedium.copyWith(
        fontWeight: text.bodyBold.fontWeight,
        color: c.textPrimary,
      ),
    );
  }

  Widget _buildFlagTile(BuildContext context, FeatureFlag flag) {
    final c = context.colors;
    final a = context.accent;
    final text = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final s = context.sizes;

    final isPending = _pendingUpdates.containsKey(flag.featureName);
    final displayName = FeatureFlags.getDisplayName(flag.featureName);

    return Container(
      margin: EdgeInsets.only(bottom: sp.sm),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.border,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          displayName,
          style: text.bodyMedium.copyWith(
            fontWeight: text.bodyBold.fontWeight,
            color: c.textPrimary,
          ),
        ),
        subtitle: Text(
          flag.featureName,
          style: text.bodySmall.copyWith(
            color: c.textSecondary,
          ),
        ),
        value: flag.enabled,
        onChanged: isPending 
            ? null 
            : (value) => _toggleFlag(flag.featureName, value),
        secondary: isPending
            ? SizedBox(
                width: s.iconMd,
                height: s.iconMd,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                flag.enabled ? Icons.check_circle : Icons.cancel,
                color: flag.enabled
                    ? c.success
                    : c.textSecondary,
              ),
        activeTrackColor: a.primary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: sp.md,
          vertical: sp.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sh.radiusMd),
        ),
      ),
    );
  }
}

