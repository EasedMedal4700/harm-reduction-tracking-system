import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';

import '../services/admin_service.dart';
import '../services/cache_service.dart';
import '../utils/error_reporter.dart';
import '../widgets/admin/admin_stats_section.dart';
import '../widgets/admin/admin_user_list.dart';
import 'admin/error_analytics_screen.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final users = await _adminService.fetchAllUsers();
      final stats = await _adminService.getSystemStats();
      final cacheStats = _cacheService.getStats();
      if (!mounted) return;
      setState(() {
        _users = users;
        _stats = stats;
        _cacheStats = cacheStats;
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

  Future<void> _toggleAdmin(int userId, bool currentlyAdmin) async {
    try {
      if (currentlyAdmin) {
        await _adminService.demoteUser(userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User demoted from admin')),
          );
        }
      } else {
        await _adminService.promoteUser(userId);
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
        extraData: {'context': 'toggle_admin', 'user_id': userId},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to toggle admin status')),
        );
      }
    }
  }

  void _openErrorAnalytics() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ErrorAnalyticsScreen()),
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: _openErrorAnalytics,
            tooltip: 'Error Analytics',
          ),
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
            tooltip: 'Refresh',
          ),
        ],
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
                    AdminStatsSection(stats: _stats),
                    const SizedBox(height: 24),

                    // Cache Management Section
                    _buildCacheManagementSection(isDark),
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

  Widget _buildCacheManagementSection(bool isDark) {
    final totalEntries = _cacheStats['total_entries'] ?? 0;
    final activeEntries = _cacheStats['active_entries'] ?? 0;
    final expiredEntries = _cacheStats['expired_entries'] ?? 0;

    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? const BorderSide(color: Color(0xFF2A2A3E), width: 1)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storage_rounded,
                  color: isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Cache Management',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cache Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF252538)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCacheStat(
                    'Total',
                    totalEntries.toString(),
                    Icons.data_usage,
                    isDark ? Colors.blue.shade300 : Colors.blue,
                    isDark,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                  _buildCacheStat(
                    'Active',
                    activeEntries.toString(),
                    Icons.check_circle,
                    isDark ? Colors.green.shade300 : Colors.green,
                    isDark,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                  _buildCacheStat(
                    'Expired',
                    expiredEntries.toString(),
                    Icons.warning_amber_rounded,
                    isDark ? Colors.orange.shade300 : Colors.orange,
                    isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cache Actions
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildCacheActionButton(
                  label: 'Clear All Cache',
                  icon: Icons.delete_sweep,
                  color: Colors.red,
                  onPressed: () => _showClearCacheDialog(
                    'Clear All Cache',
                    'This will remove all cached data. Users may experience slower load times temporarily.',
                    _clearAllCache,
                  ),
                  isDark: isDark,
                ),
                _buildCacheActionButton(
                  label: 'Clear Drug Profiles',
                  icon: Icons.medication_outlined,
                  color: Colors.orange,
                  onPressed: () => _showClearCacheDialog(
                    'Clear Drug Profiles',
                    'This will clear cached drug profile data. It will be reloaded on next access.',
                    _clearDrugCache,
                  ),
                  isDark: isDark,
                ),
                _buildCacheActionButton(
                  label: 'Clear Expired',
                  icon: Icons.cleaning_services,
                  color: Colors.blue,
                  onPressed: _clearExpiredCache,
                  isDark: isDark,
                ),
                _buildCacheActionButton(
                  label: 'Refresh from DB',
                  icon: Icons.refresh,
                  color: Colors.green,
                  onPressed: _refreshFromDatabase,
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheStat(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildCacheActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.5), width: 1),
        ),
      ),
    );
  }

  void _showClearCacheDialog(
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
