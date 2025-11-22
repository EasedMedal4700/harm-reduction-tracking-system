import 'package:flutter/material.dart';

import '../services/admin_service.dart';
import '../utils/error_reporter.dart';
import '../widgets/admin/admin_stats_section.dart';
import '../widgets/admin/admin_user_list.dart';
import '../widgets/admin/error_analytics_section.dart';
import '../widgets/admin/error_cleanup_dialog.dart';
import '../widgets/admin/error_log_detail_dialog.dart';

/// Admin panel screen for managing users and monitoring system health
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AdminService _adminService = AdminService();
  final ErrorReporter _errorReporter = ErrorReporter.instance;
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic> _stats = {};
  Map<String, dynamic> _errorAnalytics = {};
  bool _isClearingErrors = false;
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
      final errorAnalytics = await _adminService.getErrorAnalytics();
      if (!mounted) return;
      setState(() {
        _users = users;
        _stats = stats;
        _errorAnalytics = errorAnalytics;
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

  Future<void> _showErrorCleanupDialog() async {
    try {
      final platformOptions = _getBreakdown('platform_breakdown')
          .map((item) => item['platform']?.toString() ?? 'unknown')
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList();

      final screenOptions = _getBreakdown('screen_breakdown')
          .map((item) => item['screen_name']?.toString() ?? 'Unknown Screen')
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList();

      final result = await showDialog<Map<String, dynamic>?>(
        context: context,
        builder: (context) => ErrorCleanupDialog(
          platformOptions: platformOptions,
          screenOptions: screenOptions,
        ),
      );

      if (result == null || !mounted) return;

      final deleteAll = result['deleteAll'] as bool? ?? false;
      final olderThanDays = result['olderThanDays'] as int?;
      final platform = result['platform'] as String?;
      final screen = result['screen'] as String?;

      if (!deleteAll &&
          olderThanDays == null &&
          (platform?.isEmpty ?? true) &&
          (screen?.isEmpty ?? true)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add at least one filter or enable delete all.'),
            ),
          );
        }
        return;
      }

      setState(() => _isClearingErrors = true);

      try {
        await _adminService.clearErrorLogs(
          deleteAll: deleteAll,
          olderThanDays: olderThanDays,
          platform: platform,
          screenName: screen,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error logs cleaned successfully')),
          );
        }
        await _loadData();
      } finally {
        if (mounted) {
          setState(() => _isClearingErrors = false);
        }
      }
    } catch (e, stackTrace) {
      await _errorReporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'AdminPanelScreen',
        extraData: {'context': 'error_cleanup_dialog'},
      );
      if (mounted) {
        setState(() => _isClearingErrors = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to clean error logs')),
        );
      }
    }
  }

  void _showLogDetails(Map<String, dynamic> log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ErrorLogDetailDialog(log: log),
    );
  }

  List<Map<String, dynamic>> _getBreakdown(String key) {
    final raw = _errorAnalytics[key];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return <Map<String, dynamic>>[];
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

                    // Error Analytics Dashboard
                    ErrorAnalyticsSection(
                      errorAnalytics: _errorAnalytics,
                      isClearingErrors: _isClearingErrors,
                      onCleanLogs: _showErrorCleanupDialog,
                      onShowLogDetails: _showLogDetails,
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
