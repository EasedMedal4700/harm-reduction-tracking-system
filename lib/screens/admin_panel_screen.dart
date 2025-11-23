import 'package:flutter/material.dart';

import '../services/admin_service.dart';
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
  List<Map<String, dynamic>> _users = [];
  Map<String, dynamic> _stats = {};
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
      if (!mounted) return;
      setState(() {
        _users = users;
        _stats = stats;
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
