import 'package:flutter/material.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/activity/activity_card.dart';
import '../services/activity_service.dart';
import '../constants/ui_colors.dart';
import '../constants/theme_constants.dart';
import '../constants/drug_theme.dart';
import 'edit/edit_log_entry_page.dart';
import 'edit/edit_refelction_page.dart';
import 'edit/edit_craving_page.dart';

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
    
    if (entries.isEmpty) {
      return _buildEmptyState(
        icon: Icons.medication_outlined,
        title: 'No Drug Use Records',
        subtitle: 'Your recent drug use entries will appear here',
        isDark: isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchActivity,
      child: ListView.builder(
        padding: EdgeInsets.all(ThemeConstants.space16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          final timestamp = _parseTimestamp(entry['start_time'] ?? entry['time']);
          
          return ActivityCard(
            title: entry['name'] ?? 'Unknown Substance',
            subtitle: '${entry['dose'] ?? 'Unknown dose'} • ${entry['place'] ?? 'No location'}',
            timestamp: timestamp,
            icon: Icons.medication,
            accentColor: DrugCategoryColors.stimulant,
            badge: entry['is_medical_purpose'] == true ? 'Medical' : null,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditDrugUsePage(entry: entry),
              ),
            ).then((_) => _fetchActivity()),
          );
        },
      ),
    );
  }

  Widget _buildCravingsTab(bool isDark) {
    final cravings = _activity['cravings'] as List? ?? [];
    
    if (cravings.isEmpty) {
      return _buildEmptyState(
        icon: Icons.favorite_border,
        title: 'No Cravings Logged',
        subtitle: 'Your craving records will appear here',
        isDark: isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchActivity,
      child: ListView.builder(
        padding: EdgeInsets.all(ThemeConstants.space16),
        itemCount: cravings.length,
        itemBuilder: (context, index) {
          final craving = cravings[index];
          final timestamp = _parseTimestamp(craving['time'] ?? craving['created_at']);
          final intensity = craving['intensity'] ?? 0;
          
          return ActivityCard(
            title: craving['substance'] ?? 'Unknown Substance',
            subtitle: 'Intensity: ${_getIntensityLabel(intensity)} • ${craving['trigger'] ?? 'No trigger noted'}',
            timestamp: timestamp,
            icon: Icons.favorite,
            accentColor: _getCravingColor(intensity),
            badge: 'Level $intensity',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditCravingPage(entry: craving),
              ),
            ).then((_) => _fetchActivity()),
          );
        },
      ),
    );
  }

  Widget _buildReflectionsTab(bool isDark) {
    final reflections = _activity['reflections'] as List? ?? [];
    
    if (reflections.isEmpty) {
      return _buildEmptyState(
        icon: Icons.notes_outlined,
        title: 'No Reflections',
        subtitle: 'Your reflection entries will appear here',
        isDark: isDark,
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchActivity,
      child: ListView.builder(
        padding: EdgeInsets.all(ThemeConstants.space16),
        itemCount: reflections.length,
        itemBuilder: (context, index) {
          final reflection = reflections[index];
          final timestamp = _parseTimestamp(reflection['created_at'] ?? reflection['time']);
          final notes = reflection['notes'] ?? '';
          
          return ActivityCard(
            title: 'Reflection Entry',
            subtitle: notes.isNotEmpty ? notes : 'No notes',
            timestamp: timestamp,
            icon: Icons.notes,
            accentColor: isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditReflectionPage(entry: reflection),
              ),
            ).then((_) => _fetchActivity()),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ThemeConstants.space32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(ThemeConstants.space24),
              decoration: BoxDecoration(
                color: isDark
                    ? UIColors.darkBorder.withValues(alpha: 0.2)
                    : UIColors.lightBorder.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
            ),
            SizedBox(height: ThemeConstants.space20),
            Text(
              title,
              style: TextStyle(
                fontSize: ThemeConstants.fontLarge,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
            SizedBox(height: ThemeConstants.space8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: ThemeConstants.fontMedium,
                color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _parseTimestamp(dynamic dateStr) {
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr.toString()).toLocal();
    } catch (e) {
      return null;
    }
  }

  String _getIntensityLabel(int intensity) {
    if (intensity <= 2) return 'Mild';
    if (intensity <= 4) return 'Moderate';
    if (intensity <= 7) return 'Strong';
    return 'Severe';
  }

  Color _getCravingColor(int intensity) {
    if (intensity <= 2) return Colors.green;
    if (intensity <= 4) return Colors.yellow.shade700;
    if (intensity <= 7) return Colors.orange;
    return Colors.red;
  }
}