// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Main activity page with tabs. Uses AppThemeExtension. No hardcoded values.

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/old_common/drawer_menu.dart';
import 'widgets/activity/activity_drug_use_tab.dart';
import 'widgets/activity/activity_cravings_tab.dart';
import 'widgets/activity/activity_reflections_tab.dart';
import 'widgets/activity/activity_delete_dialog.dart';
import 'widgets/activity/activity_detail_helpers.dart';
import 'widgets/activity/activity_helpers.dart';
import '../../services/activity_service.dart';
import '../../services/user_service.dart';
import '../../constants/theme/app_theme_constants.dart';
import '../../constants/theme/app_theme_extension.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> with SingleTickerProviderStateMixin {
  final ActivityService _service = ActivityService();
  Map<String, dynamic> _activity = {};
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchActivity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchActivity() async {
    try {
      final data = await _service.fetchRecentActivity();
      if (mounted) {
        setState(() {
          _activity = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load activity: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return Scaffold(
      backgroundColor: t.colors.background,
      appBar: AppBar(
        title: Text(
          'Recent Activity',
          style: t.typography.heading3.copyWith(color: t.colors.textPrimary),
        ),
        backgroundColor: t.colors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchActivity,
            tooltip: 'Refresh',
            color: t.colors.textPrimary,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: t.accent.primary,
          labelColor: t.colors.textPrimary,
          unselectedLabelColor: t.colors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.medication, size: AppThemeConstants.iconMd), text: 'Drug Use'),
            Tab(icon: Icon(Icons.favorite, size: AppThemeConstants.iconMd), text: 'Cravings'),
            Tab(icon: Icon(Icons.notes, size: AppThemeConstants.iconMd), text: 'Reflections'),
          ],
        ),
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: t.accent.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDrugUseTab(),
                _buildCravingsTab(),
                _buildReflectionsTab(),
              ],
            ),
    );
  }

  Widget _buildDrugUseTab() {
    final entries = _activity['entries'] as List? ?? [];
    return ActivityDrugUseTab(
      entries: entries,
      onEntryTap: (entry) => ActivityDetailHelpers.showDrugUseDetail(
        context: context,
        entry: entry,
        onDelete: _handleDelete,
        onUpdate: _fetchActivity,
      ),
      onRefresh: _fetchActivity,
    );
  }

  Widget _buildCravingsTab() {
    final cravings = _activity['cravings'] as List? ?? [];
    return ActivityCravingsTab(
      cravings: cravings,
      onCravingTap: (craving) => ActivityDetailHelpers.showCravingDetail(
        context: context,
        craving: craving,
        onDelete: _handleDelete,
        onUpdate: _fetchActivity,
      ),
      onRefresh: _fetchActivity,
    );
  }

  Widget _buildReflectionsTab() {
    final reflections = _activity['reflections'] as List? ?? [];
    return ActivityReflectionsTab(
      reflections: reflections,
      onReflectionTap: (reflection) => ActivityDetailHelpers.showReflectionDetail(
        context: context,
        reflection: reflection,
        onDelete: _handleDelete,
        onUpdate: _fetchActivity,
      ),
      onRefresh: _fetchActivity,
    );
  }

  void _handleDelete(String entryId, String entryType, String serviceName) {
    _confirmDelete(
      context,
      entryId: entryId,
      entryType: entryType,
      serviceName: serviceName,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context, {
    required String entryId,
    required String entryType,
    required String serviceName,
  }) async {
    final confirmed = await ActivityDeleteDialog.show(context, entryType);

    if (confirmed && context.mounted) {
      Navigator.pop(context); // Close bottom sheet
      await _deleteEntry(context, entryId, serviceName);
    }
  }

  Future<void> _deleteEntry(
      BuildContext context, String entryId, String serviceName) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = UserService.getCurrentUserId();
      final idColumn = ActivityHelpers.getIdColumn(serviceName);

      await supabase
          .from(serviceName)
          .delete()
          .eq('uuid_user_id', userId)
          .eq(idColumn, entryId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Entry deleted successfully'),
            backgroundColor: context.theme.colors.success,
          ),
        );
        _fetchActivity();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete entry: $e'),
            backgroundColor: context.theme.colors.error,
          ),
        );
      }
    }
  }
}
