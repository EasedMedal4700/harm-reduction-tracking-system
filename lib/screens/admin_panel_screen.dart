import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/admin_service.dart';
import '../utils/error_handler.dart';
import '../widgets/admin/admin_stats_section.dart';
import '../widgets/admin/admin_user_list.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AdminService _adminService = AdminService();
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
      ErrorHandler.logError('AdminPanelScreen._loadData', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
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
      _loadData();
    } catch (e, stackTrace) {
      ErrorHandler.logError('AdminPanelScreen._toggleAdmin', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
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
                    _buildErrorAnalyticsSection(),
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

  Widget _buildErrorAnalyticsSection() {
    final totalErrors = _errorAnalytics['total_errors'] ?? 0;
    final last24h = _errorAnalytics['last_24h'] ?? 0;
    final platformBreakdown = _getBreakdown('platform_breakdown');
    final screenBreakdown = _getBreakdown('screen_breakdown');
    final messageBreakdown = _getBreakdown('message_breakdown');
    final recentLogs = _getBreakdown('recent_logs');

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.deepOrange),
                const SizedBox(width: 8),
                const Text(
                  'Error Monitoring',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _isClearingErrors ? null : _showErrorCleanupDialog,
                  icon: const Icon(Icons.cleaning_services_outlined),
                  label: const Text('Clean Logs'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildErrorStatChip(
                  label: 'Total Errors',
                  value: totalErrors.toString(),
                  icon: Icons.warning_amber_outlined,
                  color: Colors.red.shade600,
                ),
                _buildErrorStatChip(
                  label: 'Last 24h',
                  value: last24h.toString(),
                  icon: Icons.timer_outlined,
                  color: Colors.orange.shade600,
                ),
                _buildErrorStatChip(
                  label: 'Tracked Screens',
                  value: screenBreakdown.length.toString(),
                  icon: Icons.devices_other,
                  color: Colors.blueGrey.shade600,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (platformBreakdown.isNotEmpty)
              _buildBreakdownSection(
                title: 'Top Platforms',
                data: platformBreakdown,
                labelKey: 'platform',
                countKey: 'count',
              ),
            if (screenBreakdown.isNotEmpty)
              _buildBreakdownSection(
                title: 'Top Screens',
                data: screenBreakdown,
                labelKey: 'screen_name',
                countKey: 'count',
              ),
            if (messageBreakdown.isNotEmpty)
              _buildBreakdownSection(
                title: 'Frequent Errors',
                data: messageBreakdown,
                labelKey: 'error_message',
                countKey: 'count',
              ),
            const SizedBox(height: 16),
            Text(
              'Recent Events',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (recentLogs.isEmpty)
              const Text(
                'No recent error logs available.',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: recentLogs.map((log) {
                  final createdRaw = log['created_at'];
                  final createdAt = createdRaw is String
                      ? DateTime.tryParse(createdRaw)
                      : createdRaw is DateTime
                          ? createdRaw
                          : null;
                  final timestamp = createdAt != null
                      ? DateFormat('MMM dd, HH:mm').format(createdAt)
                      : 'Unknown time';
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.bug_report_outlined),
                    title: Text(
                      log['error_message'] ?? 'Unknown error',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${log['platform'] ?? 'unknown'} • ${log['screen_name'] ?? 'Unknown screen'}\n$timestamp',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.devices),
                        Text(
                          log['device_model'] ?? 'unavailable',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    onTap: () => _showLogDetails(log),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorStatChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection({
    required String title,
    required List<Map<String, dynamic>> data,
    required String labelKey,
    required String countKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...data.take(5).map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item[labelKey]?.toString() ?? 'Unknown',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${item[countKey] ?? 0} hits',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
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

  Future<void> _showErrorCleanupDialog() async {
    final daysController = TextEditingController();
    String? platform;
    String? screen;
    bool deleteAll = false;

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

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Clean Error Logs'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      value: deleteAll,
                      title: const Text('Delete entire table'),
                      subtitle: const Text('This action cannot be undone'),
                      onChanged: (value) {
                        setModalState(() {
                          deleteAll = value;
                        });
                      },
                    ),
                    if (!deleteAll) ...[
                      TextField(
                        controller: daysController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Older than (days)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: platform,
                        decoration: const InputDecoration(labelText: 'Platform (optional)'),
                        items: platformOptions
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setModalState(() {
                            platform = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: screen,
                        decoration: const InputDecoration(labelText: 'Screen (optional)'),
                        items: screenOptions
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setModalState(() {
                            screen = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true) return;

    final olderThanDays = int.tryParse(daysController.text);

    if (!deleteAll &&
        olderThanDays == null &&
        ((platform?.isEmpty ?? true)) &&
        ((screen?.isEmpty ?? true))) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add at least one filter or enable delete all.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _isClearingErrors = true;
    });

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
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clean logs: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isClearingErrors = false;
        });
      }
    }
  }

  void _showLogDetails(Map<String, dynamic> log) {
    final createdAtString = log['created_at']?.toString();
    final createdAt = createdAtString != null
        ? DateTime.tryParse(createdAtString)
        : null;
    final extra = _parseExtraData(log['extra_data']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, controller) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                controller: controller,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bug_report, color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          log['error_message'] ?? 'Unknown error',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildKeyValue('Created', createdAt != null
                      ? DateFormat('MMM dd, yyyy HH:mm:ss').format(createdAt.toLocal())
                      : 'Unknown'),
                  _buildKeyValue('Platform', log['platform'] ?? 'Unknown'),
                  _buildKeyValue('OS Version', log['os_version'] ?? 'Unknown'),
                  _buildKeyValue('Device', log['device_model'] ?? 'Unknown'),
                  _buildKeyValue('App Version', log['app_version'] ?? 'Unknown'),
                  _buildKeyValue('Screen', log['screen_name'] ?? 'Unknown'),
                  const SizedBox(height: 12),
                  Text(
                    'Stacktrace',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      log['stacktrace'] ?? 'Unavailable',
                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                  ),
                  if (extra != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Extra Data',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        const JsonEncoder.withIndent('  ').convert(extra),
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKeyValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _parseExtraData(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = json.decode(data);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {
        return {'raw': data};
      }
    }
    return null;
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    if (_users.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No users found'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isAdmin = user['is_admin'] as bool? ?? false;
    final entryCount = user['entry_count'] as int? ?? 0;
    final createdAt = user['created_at'] != null
        ? DateTime.parse(user['created_at'])
        : null;
    final updatedAt = user['updated_at'] != null
        ? DateTime.parse(user['updated_at'])
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isAdmin ? Colors.deepPurple : Colors.grey,
          child: Icon(
            isAdmin ? Icons.admin_panel_settings : Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(
          user['display_name'] ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email'] ?? 'No email'),
            const SizedBox(height: 4),
            Row(
              children: [
                if (isAdmin)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ADMIN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  '$entryCount entries',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('User ID', user['user_id']?.toString() ?? 'N/A'),
                _buildInfoRow('Email', user['email'] ?? 'N/A'),
                _buildInfoRow('Display Name', user['display_name'] ?? 'N/A'),
                _buildInfoRow('Total Entries', entryCount.toString()),
                _buildInfoRow(
                  'Date Joined',
                  createdAt != null
                      ? DateFormat('MMM dd, yyyy').format(createdAt)
                      : 'N/A',
                ),
                _buildInfoRow(
                  'Last Updated',
                  updatedAt != null
                      ? DateFormat('MMM dd, yyyy HH:mm').format(updatedAt)
                      : 'N/A',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _toggleAdmin(
                          user['user_id'] as int,
                          isAdmin,
                        ),
                        icon: Icon(isAdmin ? Icons.remove_circle : Icons.add_circle),
                        label: Text(isAdmin ? 'Demote' : 'Promote to Admin'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAdmin ? Colors.orange : Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
