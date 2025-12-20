// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Error analytics screen. Migrated to use AppTheme and CommonLoader.

import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import '../../../services/admin_service.dart';
import '../../../utils/error_reporter.dart';
import '../widgets/errors/error_analytics_section.dart';
import '../widgets/errors/error_cleanup_dialog.dart';
import '../widgets/errors/error_log_detail_dialog.dart';

class ErrorAnalyticsScreen extends StatefulWidget {
  const ErrorAnalyticsScreen({super.key});

  @override
  State<ErrorAnalyticsScreen> createState() => _ErrorAnalyticsScreenState();
}

class _ErrorAnalyticsScreenState extends State<ErrorAnalyticsScreen> {
  final AdminService _adminService = AdminService();
  final ErrorReporter _errorReporter = ErrorReporter.instance;

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
      final errorAnalytics = await _adminService.getErrorAnalytics();
      if (!mounted) return;
      setState(() {
        _errorAnalytics = errorAnalytics;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      await _errorReporter.reportError(
        error: e,
        stackTrace: stackTrace,
        screenName: 'ErrorAnalyticsScreen',
        extraData: {'context': 'load_data'},
      );
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading analytics data')),
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
        screenName: 'ErrorAnalyticsScreen',
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
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text('Error Analytics'),
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: context.sizes.elevationNone,
        actions: [
          IconButton(
            icon: _isLoading
                ? CommonLoader(size: context.sizes.iconSm, color: c.textPrimary)
                : const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const CommonLoader()
          : RefreshIndicator(
              onRefresh: _loadData,
              color: a.primary,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp.md),
                child: ErrorAnalyticsSection(
                  errorAnalytics: _errorAnalytics,
                  isClearingErrors: _isClearingErrors,
                  onCleanLogs: _showErrorCleanupDialog,
                  onShowLogDetails: _showLogDetails,
                ),
              ),
            ),
    );
  }
}
