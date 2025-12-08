import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/config/feature_flags.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../services/feature_flag_service.dart';
import '../../services/user_service.dart';
import '../../common/old_common/drawer_menu.dart';

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
          const SnackBar(
            content: Text('Admin access required'),
            backgroundColor: Colors.red,
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
            backgroundColor: Colors.red,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_isAdmin && !_isLoading) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Feature Flags',
          style: TextStyle(
            fontWeight: ThemeConstants.fontSemiBold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshFlags,
            tooltip: 'Refresh flags',
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState(isDark);
    }

    return Consumer<FeatureFlagService>(
      builder: (context, flags, _) {
        if (flags.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final allFlags = flags.allFlags;
        if (allFlags.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return _buildFlagsList(isDark, allFlags);
      },
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: isDark ? UIColors.darkNeonOrange : UIColors.lightAccentAmber,
            ),
            const SizedBox(height: ThemeConstants.space16),
            Text(
              'Error Loading Flags',
              style: TextStyle(
                fontSize: ThemeConstants.fontXLarge,
                fontWeight: ThemeConstants.fontSemiBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            const SizedBox(height: ThemeConstants.space8),
            Text(
              _errorMessage ?? 'Unknown error',
              style: TextStyle(
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConstants.space24),
            ElevatedButton.icon(
              onPressed: _refreshFlags,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 64,
              color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
            ),
            const SizedBox(height: ThemeConstants.space16),
            Text(
              'No Feature Flags',
              style: TextStyle(
                fontSize: ThemeConstants.fontXLarge,
                fontWeight: ThemeConstants.fontSemiBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            const SizedBox(height: ThemeConstants.space8),
            Text(
              'No feature flags found in the database.',
              style: TextStyle(
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlagsList(bool isDark, List<FeatureFlag> flags) {
    // Group flags by category
    final categories = _categorizeFlags(flags);

    return ListView(
      padding: const EdgeInsets.all(ThemeConstants.space16),
      children: [
        // Info banner
        _buildInfoBanner(isDark),
        const SizedBox(height: ThemeConstants.space16),
        
        // Flag categories
        for (final entry in categories.entries) ...[
          _buildCategoryHeader(isDark, entry.key),
          const SizedBox(height: ThemeConstants.space8),
          ...entry.value.map((flag) => _buildFlagTile(isDark, flag)),
          const SizedBox(height: ThemeConstants.space16),
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

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark 
            ? UIColors.darkNeonBlue.withValues(alpha: 0.1) 
            : UIColors.lightAccentBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark 
              ? UIColors.darkNeonBlue.withValues(alpha: 0.3) 
              : UIColors.lightAccentBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
          ),
          const SizedBox(width: ThemeConstants.space12),
          Expanded(
            child: Text(
              'Disabled features will be hidden from regular users. '
              'Admins can always access all features.',
              style: TextStyle(
                fontSize: ThemeConstants.fontSmall,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(bool isDark, String category) {
    return Text(
      category,
      style: TextStyle(
        fontSize: ThemeConstants.fontLarge,
        fontWeight: ThemeConstants.fontSemiBold,
        color: isDark ? UIColors.darkText : UIColors.lightText,
      ),
    );
  }

  Widget _buildFlagTile(bool isDark, FeatureFlag flag) {
    final isPending = _pendingUpdates.containsKey(flag.featureName);
    final displayName = FeatureFlags.getDisplayName(flag.featureName);

    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space8),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        border: Border.all(
          color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          displayName,
          style: TextStyle(
            fontWeight: ThemeConstants.fontMediumWeight,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        subtitle: Text(
          flag.featureName,
          style: TextStyle(
            fontSize: ThemeConstants.fontXSmall,
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        value: flag.enabled,
        onChanged: isPending 
            ? null 
            : (value) => _toggleFlag(flag.featureName, value),
        secondary: isPending
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                flag.enabled ? Icons.check_circle : Icons.cancel,
                color: flag.enabled
                    ? (isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen)
                    : (isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary),
              ),
        activeThumbColor: isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space16,
          vertical: ThemeConstants.space4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
        ),
      ),
    );
  }
}
