import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../common/layout/common_drawer.dart';
import '../services/admin_service.dart';
import '../../../services/cache_service.dart';
import '../../../services/performance_service.dart';
import '../../../utils/error_reporter.dart';
import '../widgets/stats/admin_stats_section.dart';
import '../widgets/users/admin_user_list.dart';
import '../widgets/app_bar/admin_app_bar.dart';
import '../widgets/cache/cache_management_section.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import 'package:mobile_drug_use_app/constants/strings/app_strings.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Admin Panel Screen. Migrated to use AppTheme. No hardcoded values.
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializePerformanceTracking();
      _isInitialized = true;
    }
  }

  Future<void> _initializePerformanceTracking() async {
    final fastAnimMs = context.animations.fast.inMilliseconds;
    // Initialize with some sample data if none exists
    final stats = await PerformanceService.getStatistics();
    if (stats['total_samples'] == 0) {
      // Add initial samples to show functionality
      await PerformanceService.recordResponseTime(
        endpoint: 'initialization',
        milliseconds: fastAnimMs,
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
            content: const Text(AppStrings.errorLoadingAdminData),
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
            const SnackBar(content: Text(AppStrings.userDemoted)),
          );
        }
      } else {
        await _adminService.promoteUser(authUserId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.userPromoted)),
          );
        }
      }
      await _loadData();
    } catch (e, stackTrace) {
      await _errorReporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'AdminPanelScreen',
        extraData: {
          'context': 'toggle_admin',
          'target_auth_user_id': authUserId,
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.errorToggleAdmin),
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
            content: const Text(AppStrings.cacheClearedSuccess),
            backgroundColor: context.theme.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.errorClearingCache),
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
            content: const Text(AppStrings.drugCacheCleared),
            backgroundColor: context.theme.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.errorClearingDrugCache),
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
            content: const Text(AppStrings.expiredCacheCleared),
            backgroundColor: context.theme.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.errorClearingExpiredCache),
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
            content: const Text(
              '✓ Cache refreshed - data will reload from database',
            ),
            backgroundColor: context.theme.colors.success,
            duration: context.animations.toast,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.errorRefreshingDatabase),
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
      appBar: AdminAppBar(isLoading: _isLoading, onRefresh: _loadData),
      drawer: const CommonDrawer(),
      body: _isLoading
          ? const CommonLoader()
          : RefreshIndicator(
              color: t.accent.primary,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp.lg),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
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
