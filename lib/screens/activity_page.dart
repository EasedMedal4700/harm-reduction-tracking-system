import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/activity/activity_card.dart';
import '../services/activity_service.dart';
import '../services/user_service.dart';
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
            onTap: () => _showDrugUseDetail(context, entry, isDark),
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
            onTap: () => _showCravingDetail(context, craving, isDark),
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
            onTap: () => _showReflectionDetail(context, reflection, isDark),
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

  void _showDrugUseDetail(BuildContext context, Map<String, dynamic> entry, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailSheet(
        context: context,
        isDark: isDark,
        title: entry['name'] ?? 'Unknown Substance',
        icon: Icons.medication,
        accentColor: DrugCategoryColors.stimulant,
        details: [
          _DetailItem(label: 'Dose', value: entry['dose'] ?? 'Unknown'),
          _DetailItem(label: 'Route', value: entry['consumption'] ?? 'Not specified'),
          _DetailItem(label: 'Location', value: entry['place'] ?? 'Not specified'),
          _DetailItem(label: 'Time', value: _formatDetailTimestamp(entry['start_time'] ?? entry['time'])),
          if (entry['notes'] != null && entry['notes'].toString().isNotEmpty)
            _DetailItem(label: 'Notes', value: entry['notes']),
          if (entry['is_medical_purpose'] == true)
            _DetailItem(label: 'Purpose', value: 'Medical', highlight: true),
        ],
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditDrugUsePage(entry: entry),
            ),
          ).then((_) => _fetchActivity());
        },
        onDelete: () => _confirmDelete(
          context,
          entryId: entry['use_id']?.toString() ?? entry['id']?.toString() ?? '',
          entryType: 'drug use',
          serviceName: 'drug_use',
        ),
      ),
    );
  }

  void _showCravingDetail(BuildContext context, Map<String, dynamic> craving, bool isDark) {
    final intensity = craving['intensity'] ?? 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailSheet(
        context: context,
        isDark: isDark,
        title: craving['substance'] ?? 'Unknown Substance',
        icon: Icons.favorite,
        accentColor: _getCravingColor(intensity),
        details: [
          _DetailItem(label: 'Intensity', value: '${_getIntensityLabel(intensity)} (Level $intensity)'),
          _DetailItem(label: 'Trigger', value: craving['trigger'] ?? 'No trigger noted'),
          _DetailItem(label: 'Time', value: _formatDetailTimestamp(craving['time'] ?? craving['created_at'])),
          if (craving['notes'] != null && craving['notes'].toString().isNotEmpty)
            _DetailItem(label: 'Notes', value: craving['notes']),
        ],
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditCravingPage(entry: craving),
            ),
          ).then((_) => _fetchActivity());
        },
        onDelete: () => _confirmDelete(
          context,
          entryId: craving['craving_id']?.toString() ?? craving['id']?.toString() ?? '',
          entryType: 'craving',
          serviceName: 'cravings',
        ),
      ),
    );
  }

  void _showReflectionDetail(BuildContext context, Map<String, dynamic> reflection, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildDetailSheet(
        context: context,
        isDark: isDark,
        title: 'Reflection Entry',
        icon: Icons.notes,
        accentColor: isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple,
        details: [
          _DetailItem(label: 'Time', value: _formatDetailTimestamp(reflection['created_at'] ?? reflection['time'])),
          if (reflection['notes'] != null && reflection['notes'].toString().isNotEmpty)
            _DetailItem(label: 'Notes', value: reflection['notes']),
        ],
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditReflectionPage(entry: reflection),
            ),
          ).then((_) => _fetchActivity());
        },
        onDelete: () => _confirmDelete(
          context,
          entryId: reflection['reflection_id']?.toString() ?? reflection['id']?.toString() ?? '',
          entryType: 'reflection',
          serviceName: 'reflections',
        ),
      ),
    );
  }

  Widget _buildDetailSheet({
    required BuildContext context,
    required bool isDark,
    required String title,
    required IconData icon,
    required Color accentColor,
    required List<_DetailItem> details,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ThemeConstants.radiusLarge)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: ThemeConstants.space12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: ThemeConstants.space20),

            // Header with icon
            Container(
              padding: EdgeInsets.symmetric(horizontal: ThemeConstants.space20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(ThemeConstants.space12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                    ),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: ThemeConstants.space16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: ThemeConstants.fontXLarge,
                        fontWeight: ThemeConstants.fontBold,
                        color: isDark ? UIColors.darkText : UIColors.lightText,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ThemeConstants.space24),

            // Details list
            Container(
              padding: EdgeInsets.symmetric(horizontal: ThemeConstants.space20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details.map((detail) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: ThemeConstants.space16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.label,
                          style: TextStyle(
                            fontSize: ThemeConstants.fontSmall,
                            fontWeight: ThemeConstants.fontSemiBold,
                            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                          ),
                        ),
                        SizedBox(height: ThemeConstants.space4),
                        Container(
                          padding: detail.highlight ? EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space8,
                            vertical: ThemeConstants.space4,
                          ) : null,
                          decoration: detail.highlight ? BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                          ) : null,
                          child: Text(
                            detail.value,
                            style: TextStyle(
                              fontSize: ThemeConstants.fontMedium,
                              fontWeight: detail.highlight ? ThemeConstants.fontSemiBold : FontWeight.normal,
                              color: detail.highlight ? accentColor : (isDark ? UIColors.darkText : UIColors.lightText),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: ThemeConstants.space24),

            // Action buttons
            Container(
              padding: EdgeInsets.all(ThemeConstants.space20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ThemeConstants.space12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Entry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, {
    required String entryId,
    required String entryType,
    required String serviceName,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        title: Text(
          'Delete Entry?',
          style: TextStyle(
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this $entryType entry? This action cannot be undone.',
          style: TextStyle(
            color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      Navigator.pop(context); // Close bottom sheet
      await _deleteEntry(context, entryId, serviceName);
    }
  }

  Future<void> _deleteEntry(BuildContext context, String entryId, String serviceName) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = await UserService.getIntegerUserId();
      
      // Determine the correct ID column name based on service
      String idColumn;
      switch (serviceName) {
        case 'drug_use':
          idColumn = 'use_id';
          break;
        case 'cravings':
          idColumn = 'craving_id';
          break;
        case 'reflections':
          idColumn = 'reflection_id';
          break;
        default:
          idColumn = 'id';
      }
      
      await supabase
          .from(serviceName)
          .delete()
          .eq('user_id', userId)
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

  String _formatDetailTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final dt = DateTime.parse(timestamp.toString()).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dt);

      String relativeTime;
      if (difference.inMinutes < 1) {
        relativeTime = 'Just now';
      } else if (difference.inHours < 1) {
        relativeTime = '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        relativeTime = '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        relativeTime = '${difference.inDays}d ago';
      } else {
        relativeTime = DateFormat('MMM d, y').format(dt);
      }

      final timeStr = DateFormat('h:mm a').format(dt);
      final formattedDate = DateFormat('EEEE, MMMM d, y').format(dt);
      
      return '$relativeTime\n$formattedDate at $timeStr';
    } catch (e) {
      return 'Unknown';
    }
  }
}

class _DetailItem {
  final String label;
  final String value;
  final bool highlight;

  _DetailItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });
}