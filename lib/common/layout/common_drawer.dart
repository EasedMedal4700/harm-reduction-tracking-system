import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../constants/config/feature_flags.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../routes/app_routes.dart';
import '../../services/feature_flag_service.dart';
import '../../services/user_service.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Replaces old_common/drawer_menu.dart. Fully themed.
class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});
  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  late Timer _timer;
  DateTime _now = DateTime.now();
  bool _isAdmin = false;
  @override
  void initState() {
    super.initState();
    // Update every second to keep time live
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
    _loadAdminStatus();
  }

  Future<void> _loadAdminStatus() async {
    final isAdmin = await UserService.isAdmin();
    if (mounted) {
      setState(() => _isAdmin = isAdmin);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = context.text;
    // Section 1: Main Navigation (with feature flag keys)
    final List<Map<String, dynamic>> mainPages = [
      {
        'icon': Icons.home,
        'title': 'Home',
        'builder': AppRoutes.buildHomePage,
        'flag': FeatureFlags.homePage,
      },
      {
        'icon': Icons.bloodtype,
        'title': 'Blood Levels',
        'builder': AppRoutes.buildBloodLevelsPage,
        'flag': FeatureFlags.bloodLevelsPage,
      },
      {
        'icon': Icons.directions_run,
        'title': 'Activity',
        'builder': AppRoutes.buildActivityPage,
        'flag': FeatureFlags.activityPage,
      },
      {
        'icon': Icons.local_fire_department,
        'title': 'Cravings',
        'builder': AppRoutes.buildCravingsPage,
        'flag': FeatureFlags.cravingsPage,
      },
      {
        'icon': Icons.self_improvement,
        'title': 'Reflection',
        'builder': AppRoutes.buildReflectionPage,
        'flag': FeatureFlags.reflectionPage,
      },
    ];
    // Section 2: Data & Resources
    final List<Map<String, dynamic>> dataPages = [
      {
        'icon': Icons.menu_book,
        'title': 'Library',
        'builder': AppRoutes.buildLibraryPage,
        'flag': FeatureFlags.personalLibraryPage,
      },
      {
        'icon': Icons.analytics,
        'title': 'Analytics',
        'builder': AppRoutes.buildAnalyticsPage,
        'flag': FeatureFlags.analyticsPage,
      },
      {
        'icon': Icons.inventory,
        'title': 'Catalog',
        'builder': AppRoutes.buildCatalogPage,
        'flag': FeatureFlags.catalogPage,
      },
    ];
    // Section 3: Advanced Features
    final List<Map<String, dynamic>> advancedPages = [
      {
        'icon': Icons.favorite,
        'title': 'Physiological',
        'builder': AppRoutes.buildPhysiologicalPage,
        'flag': FeatureFlags.physiologicalPage,
      },
      {
        'icon': Icons.compare_arrows,
        'title': 'Interactions',
        'builder': AppRoutes.buildInteractionsPage,
        'flag': FeatureFlags.interactionsPage,
      },
      {
        'icon': Icons.speed,
        'title': 'Tolerance',
        'builder': AppRoutes.buildToleranceDashboardPage,
        'flag': FeatureFlags.toleranceDashboardPage,
      },
      {
        'icon': Icons.watch,
        'title': 'WearOS',
        'builder': AppRoutes.buildWearOSPage,
        'flag': FeatureFlags.wearosPage,
      },
    ];
    return Consumer<FeatureFlagService>(
      builder: (context, flags, _) {
        // Filter pages based on feature flags
        final filteredMainPages = mainPages
            .where(
              (p) => flags.isEnabled(p['flag'] as String, isAdmin: _isAdmin),
            )
            .toList();
        final filteredDataPages = dataPages
            .where(
              (p) => flags.isEnabled(p['flag'] as String, isAdmin: _isAdmin),
            )
            .toList();
        final filteredAdvancedPages = advancedPages
            .where(
              (p) => flags.isEnabled(p['flag'] as String, isAdmin: _isAdmin),
            )
            .toList();
        return Drawer(
          backgroundColor: c.surface,
          child: Column(
            children: [
              // Modern gradient header
              _buildModernHeader(context),
              // Use Expanded so the time stays at the bottom
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Section 1: Main Navigation
                    if (filteredMainPages.isNotEmpty) ...[
                      ...filteredMainPages.map(
                        (page) => _buildMenuItem(context, page),
                      ),
                      _buildSleekDivider(context),
                    ],
                    // Section 2: Data & Resources
                    if (filteredDataPages.isNotEmpty) ...[
                      ...filteredDataPages.map(
                        (page) => _buildMenuItem(context, page),
                      ),
                      _buildSleekDivider(context),
                    ],
                    // Section 3: Advanced Features
                    if (filteredAdvancedPages.isNotEmpty) ...[
                      ...filteredAdvancedPages.map(
                        (page) => _buildMenuItem(context, page),
                      ),
                      _buildSleekDivider(context),
                    ],
                    // Daily Check-In
                    if (flags.isEnabled(
                      FeatureFlags.dailyCheckin,
                      isAdmin: _isAdmin,
                    ))
                      _buildMenuItem(context, {
                        'icon': Icons.mood,
                        'title': 'Daily Check-In',
                        'builder': AppRoutes.buildDailyCheckinPage,
                      }),
                    // Log Entry
                    if (flags.isEnabled(
                      FeatureFlags.logEntryPage,
                      isAdmin: _isAdmin,
                    ))
                      _buildMenuItem(context, {
                        'icon': Icons.note_add,
                        'title': 'Log Entry',
                        'builder': AppRoutes.buildLogEntryPage,
                      }),
                    // Settings (always visible)
                    _buildMenuItem(context, {
                      'icon': Icons.settings,
                      'title': 'Settings',
                      'builder': AppRoutes.buildSettingsPage,
                    }),
                    // Bug Report (always visible)
                    _buildMenuItem(context, {
                      'icon': Icons.report_problem,
                      'title': 'Report a Bug',
                      'builder': AppRoutes.buildBugReportPage,
                    }),
                    // Admin: Feature Flags (admin only)
                    if (_isAdmin) _buildAdminFeatureFlagsItem(context),
                  ],
                ),
              ),
              // Live time at the bottom of the drawer
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: c.divider)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDate(_now),
                      style: tx.bodyMedium.copyWith(color: c.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(_now),
                      style: tx.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    final c = context.colors;
    final tx = context.text;

    final ac = context.accent;
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Guest';
    final username = email.split('@')[0];
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ac.primary, ac.primaryVariant],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: c.surface.withValues(alpha: 0.2),
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: tx.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: c.textInverse,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                username,
                style: tx.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: c.textInverse,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: tx.bodySmall.copyWith(
                  color: c.textInverse.withValues(alpha: 0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> page) {
    final c = context.colors;
    final tx = context.text;

    return ListTile(
      leading: Icon(page['icon'], color: c.textSecondary),
      title: Text(
        page['title'],
        style: tx.bodyMedium.copyWith(color: c.textPrimary),
      ),
      onTap: () async {
        Navigator.pop(context);
        // Navigate and wait for result - triggers refresh on return
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page['builder']()),
        );
        // Trigger rebuild of current page by popping/pushing context
        if (context.mounted) {
          // This causes the calling page to rebuild
          (context as Element).markNeedsBuild();
        }
      },
    );
  }

  Widget _buildSleekDivider(BuildContext context) {
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              c.divider.withValues(alpha: 0.5),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminFeatureFlagsItem(BuildContext context) {
    final c = context.colors;
    final tx = context.text;

    return ListTile(
      leading: Icon(Icons.flag, color: c.warning),
      title: Text(
        'Feature Flags',
        style: tx.bodyMedium.copyWith(
          color: c.warning,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: c.warning.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Admin',
          style: tx.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: c.warning,
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/admin/feature-flags');
      },
    );
  }
}
