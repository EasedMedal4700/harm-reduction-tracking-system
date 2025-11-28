import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';
import '../services/admin_service.dart';
import '../services/cache_service.dart';
import '../services/performance_service.dart';
import '../utils/error_reporter.dart';
import '../widgets/admin/admin_stats_section.dart';
import '../widgets/admin/admin_user_list.dart';
import '../widgets/admin_panel/admin_app_bar.dart';
import '../widgets/admin_panel/cache_management_section.dart';

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
          const SnackBar(content: Text('Error loading admin data')),
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
          const SnackBar(content: Text('Failed to toggle admin status')),
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
          const SnackBar(
            content: Text('✓ All cache cleared successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to clear cache')),
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
          const SnackBar(
            content: Text('✓ Drug profiles cache cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to clear drug cache')),
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
          const SnackBar(
            content: Text('✓ Expired cache entries cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to clear expired cache')),
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
          const SnackBar(
            content: Text('✓ Cache refreshed - data will reload from database'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh from database')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        isLoading: _isLoading,
        onRefresh: _loadData,
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Dashboard
                    AdminStatsSection(
                      stats: _stats,
                      perfStats: _perfStats,
                      cacheStats: _cacheStats,
                    ),
                    const SizedBox(height: 24),

                    // Cache Management Section
                    CacheManagementSection(
                      cacheStats: _cacheStats,
                      onClearAll: _clearAllCache,
                      onClearDrugCache: _clearDrugCache,
                      onClearExpired: _clearExpiredCache,
                      onRefreshFromDatabase: _refreshFromDatabase,
                    ),
                    const SizedBox(height: 24),

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
