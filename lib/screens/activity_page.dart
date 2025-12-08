import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/old_common/drawer_menu.dart';
import '../widgets/activity/activity_drug_use_tab.dart';
import '../widgets/activity/activity_cravings_tab.dart';
import '../widgets/activity/activity_reflections_tab.dart';
import '../widgets/activity/activity_delete_dialog.dart';
import '../widgets/activity/activity_detail_helpers.dart';
import '../widgets/activity/activity_helpers.dart';
import '../services/activity_service.dart';
import '../services/user_service.dart';
import '../constants/deprecated/ui_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      appBar: AppBar(
        title: const Text('Recent Activity'),
        backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchActivity,
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: isDark ? UIColors.darkNeonGreen : UIColors.lightAccentGreen,
          labelColor: isDark ? UIColors.darkText : UIColors.lightText,
          unselectedLabelColor: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.medication), text: 'Drug Use'),
            Tab(icon: Icon(Icons.favorite), text: 'Cravings'),
            Tab(icon: Icon(Icons.notes), text: 'Reflections'),
          ],
        ),
      ),
      drawer: const DrawerMenu(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDrugUseTab(isDark),
                _buildCravingsTab(isDark),
                _buildReflectionsTab(isDark),
              ],
            ),
    );
  }

  Widget _buildDrugUseTab(bool isDark) {
    final entries = _activity['entries'] as List? ?? [];
    return ActivityDrugUseTab(
      entries: entries,
      isDark: isDark,
      onEntryTap: (entry) => ActivityDetailHelpers.showDrugUseDetail(
        context: context,
        entry: entry,
        isDark: isDark,
        onDelete: _handleDelete,
        onUpdate: _fetchActivity,
      ),
      onRefresh: _fetchActivity,
    );
  }

  Widget _buildCravingsTab(bool isDark) {
    final cravings = _activity['cravings'] as List? ?? [];
    return ActivityCravingsTab(
      cravings: cravings,
      isDark: isDark,
      onCravingTap: (craving) => ActivityDetailHelpers.showCravingDetail(
        context: context,
        craving: craving,
        isDark: isDark,
        onDelete: _handleDelete,
        onUpdate: _fetchActivity,
      ),
      onRefresh: _fetchActivity,
    );
  }

  Widget _buildReflectionsTab(bool isDark) {
    final reflections = _activity['reflections'] as List? ?? [];
    return ActivityReflectionsTab(
      reflections: reflections,
      isDark: isDark,
      onReflectionTap: (reflection) => ActivityDetailHelpers.showReflectionDetail(
        context: context,
        reflection: reflection,
        isDark: isDark,
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



  Future<void> _confirmDelete(BuildContext context, {
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

  Future<void> _deleteEntry(BuildContext context, String entryId, String serviceName) async {
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
          const SnackBar(
            content: Text('Entry deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchActivity();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete entry: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}