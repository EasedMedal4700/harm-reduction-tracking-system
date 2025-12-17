import 'package:flutter/material.dart';
import '../../common/old_common/drawer_menu.dart';
import '../../services/admin_service.dart';
import '../../services/cache_service.dart';
import '../../services/performance_service.dart';
import '../../utils/error_reporter.dart';
import 'widgets/admin/admin_stats_section.dart';
import 'widgets/admin/admin_user_list.dart';
import 'widgets/admin_panel/admin_app_bar.dart';
import 'widgets/admin_panel/cache_management_section.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

/// Admin panel screen for managing users and monitoring system health
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AdminService _adminService = AdminService();
  final ErrorReporter _errorReporter = ErrorReporter.instance;
  final CacheService _cacheService = CacheService();
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic> _stats = {};
  Map<String, dynamic> _cacheStats = {};
  Map<String, dynamic> _perfStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePerformanceTracking();
    _loadData();
  }

  Future<void> _initializePerformanceTracking() async {
    // Initialize with some sample data if none exists
    final stats = await PerformanceService.getStatistics();
    if (stats['total_samples'] == 0) {
      // Add initial samples to show functionality
      await PerformanceService.recordResponseTime(
        endpoint: 'initialization',
        milliseconds: 150,
        fromCache: false,
      );
      await PerformanceService.recordCacheEvent(key: 'init', hit: true);
      await PerformanceService.recordCacheEvent(key: 'init2', hit: true);
      await PerformanceService.recordCacheEvent(key: 'init3', hit: false);
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final users = await _adminService.fetchAllUsers();
      final stats = await _adminService.getSystemStats();
      final cacheStats = _cacheService.getStats();
      final perfStats = await PerformanceService.getStatistics();
      if (!mounted) return;
      setState(() {
        _users = users;
        _stats = stats;
        _cacheStats = cacheStats;
        _perfStats = perfStats;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      await _errorReporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'AdminPanelScreen',
        extraData: {'context': 'load_data'},
      );
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error loading admin data'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _toggleAdmin(String authUserId, bool currentlyAdmin) async {
    try {
      if (currentlyAdmin) {
        await _adminService.demoteUser(authUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User demoted from admin')),
          );
        }
      } else {
        await _adminService.promoteUser(authUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User promoted to admin')),
          );
        }
      }
      await _loadData();
    } catch (e, stackTrace) {
      await _errorReporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'AdminPanelScreen',
        extraData: {'context': 'toggle_admin', 'target_auth_user_id': authUserId},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to toggle admin status'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _clearAllCache() async {
    try {
      _cacheService.clearAll();
      if (mounted) {
        setState(() {
          _cacheStats = _cacheService.getStats();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ All cache cleared successfully'),
            backgroundColor: context.theme.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to clear cache'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _clearDrugCache() async {
    try {
      CacheKeys.clearDrugCache();
      if (mounted) {
        setState(() {
          _cacheStats = _cacheService.getStats();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Drug profiles cache cleared'),
            backgroundColor: context.theme.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to clear drug cache'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _clearExpiredCache() async {
    try {
      _cacheService.clearExpired();
      if (mounted) {
        setState(() {
          _cacheStats = _cacheService.getStats();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Expired cache entries cleared'),
            backgroundColor: context.theme.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to clear expired cache'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }

  Future<void> _refreshFromDatabase() async {
    try {
      // Clear drug-related cache to force fresh fetch from database
      _cacheService.removePattern('drug_profiles');
      _cacheService.removePattern('drug_use');
      
      if (mounted) {
        setState(() {
          _cacheStats = _cacheService.getStats();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✓ Cache refreshed - data will reload from database'),
            backgroundColor: context.theme.colors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to refresh from database'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final sp = context.spacing;
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AdminAppBar(
        isLoading: _isLoading,
        onRefresh: _loadData,
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: t.accent.primary))
          : RefreshIndicator(
              color: t.accent.primary,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Dashboard
                    AdminStatsSection(
                      stats: _stats,
                      perfStats: _perfStats,
                      cacheStats: _cacheStats,
                    ),
                    SizedBox(height: sp.xl),

                    // Cache Management Section
                    CacheManagementSection(
                      cacheStats: _cacheStats,
                      onClearAll: _clearAllCache,
                      onClearDrugCache: _clearDrugCache,
                      onClearExpired: _clearExpiredCache,
                      onRefreshFromDatabase: _refreshFromDatabase,
                    ),
                    SizedBox(height: sp.xl),

                    // User Management
                    AdminUserList(
                      users: _users,
                      onToggleAdmin: _toggleAdmin,
                      onRefresh: _loadData,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
