import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/app_theme.dart';
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
            backgroundColor: AppTheme.of(context).colors.error,
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
            content: Text('Failed to update ""'),
            backgroundColor: AppTheme.of(context).colors.error,
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
    final t = AppTheme.of(context);

    if (!_isAdmin && !_isLoading) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: t.colors.surface,
      appBar: AppBar(
        title: Text(
          'Feature Flags',
          style: t.typography.titleLarge,
        ),
        backgroundColor: t.colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: t.colors.onSurface),
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
    final t = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: t.colors.error,
            ),
            SizedBox(height: t.spacing.m),
            Text(
              'Error Loading Flags',
              style: t.typography.headlineMedium,
            ),
            SizedBox(height: t.spacing.s),
            Text(
              _errorMessage ?? 'Unknown error',
              style: t.typography.bodyMedium.copyWith(color: t.colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: t.spacing.l),
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
    final t = AppTheme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(t.spacing.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: t.colors.onSurfaceVariant,
            ),
            SizedBox(height: t.spacing.m),
            Text(
              'No Feature Flags',
              style: t.typography.headlineMedium,
            ),
            SizedBox(height: t.spacing.s),
            Text(
              'No feature flags found in the database.',
              style: t.typography.bodyMedium.copyWith(color: t.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagsList(BuildContext context, List<FeatureFlag> flags) {
    final t = AppTheme.of(context);
    // Group flags by category
    final categories = _categorizeFlags(flags);

    return ListView(
      padding: EdgeInsets.all(t.spacing.m),
      children: [
        // Info banner
        _buildInfoBanner(context),
        SizedBox(height: t.spacing.m),
        
        // Flag categories
        for (final entry in categories.entries) ...[
          _buildCategoryHeader(context, entry.key),
          SizedBox(height: t.spacing.s),
          ...entry.value.map((flag) => _buildFlagTile(context, flag)),
          SizedBox(height: t.spacing.m),
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
    final t = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.all(t.spacing.m),
      decoration: BoxDecoration(
        color: t.colors.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(t.shapes.radiusM),
        border: Border.all(
          color: t.colors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: t.colors.primary,
          ),
          SizedBox(width: t.spacing.m),
          Expanded(
            child: Text(
              'Disabled features will be hidden from regular users. '
              'Admins can always access all features.',
              style: t.typography.bodySmall.copyWith(
                color: t.colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String category) {
    final t = AppTheme.of(context);
    return Text(
      category,
      style: t.typography.titleMedium.copyWith(
        fontWeight: FontWeight.bold,
        color: t.colors.onSurface,
      ),
    );
  }

  Widget _buildFlagTile(BuildContext context, FeatureFlag flag) {
    final t = AppTheme.of(context);
    final isPending = _pendingUpdates.containsKey(flag.featureName);
    final displayName = FeatureFlags.getDisplayName(flag.featureName);

    return Container(
      margin: EdgeInsets.only(bottom: t.spacing.s),
      decoration: BoxDecoration(
        color: t.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(t.shapes.radiusM),
        border: Border.all(
          color: t.colors.outlineVariant,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          displayName,
          style: t.typography.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: t.colors.onSurface,
          ),
        ),
        subtitle: Text(
          flag.featureName,
          style: t.typography.bodySmall.copyWith(
            color: t.colors.onSurfaceVariant,
          ),
        ),
        value: flag.enabled,
        onChanged: isPending 
            ? null 
            : (value) => _toggleFlag(flag.featureName, value),
        secondary: isPending
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                flag.enabled ? Icons.check_circle : Icons.cancel,
                color: flag.enabled
                    ? t.colors.success
                    : t.colors.onSurfaceVariant,
              ),
        activeColor: t.colors.primary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: t.spacing.m,
          vertical: t.spacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.shapes.radiusM),
        ),
      ),
    );
  }
}
