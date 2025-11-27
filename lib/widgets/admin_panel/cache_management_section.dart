import 'package:flutter/material.dart';
import 'cache_stat_widget.dart';
import 'cache_action_button.dart';

/// Cache management section showing stats and actions for cache control
class CacheManagementSection extends StatelessWidget {
  final Map<String, dynamic> cacheStats;
  final VoidCallback onClearAll;
  final VoidCallback onClearDrugCache;
  final VoidCallback onClearExpired;
  final VoidCallback onRefreshFromDatabase;

  const CacheManagementSection({
    super.key,
    required this.cacheStats,
    required this.onClearAll,
    required this.onClearDrugCache,
    required this.onClearExpired,
    required this.onRefreshFromDatabase,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalEntries = cacheStats['total_entries'] ?? 0;
    final activeEntries = cacheStats['active_entries'] ?? 0;
    final expiredEntries = cacheStats['expired_entries'] ?? 0;

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
                  CacheStatWidget(
                    label: 'Total',
                    value: totalEntries.toString(),
                    icon: Icons.data_usage,
                    color: isDark ? Colors.blue.shade300 : Colors.blue,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                  CacheStatWidget(
                    label: 'Active',
                    value: activeEntries.toString(),
                    icon: Icons.check_circle,
                    color: isDark ? Colors.green.shade300 : Colors.green,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                  CacheStatWidget(
                    label: 'Expired',
                    value: expiredEntries.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: isDark ? Colors.orange.shade300 : Colors.orange,
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
                CacheActionButton(
                  label: 'Clear All Cache',
                  icon: Icons.delete_sweep,
                  color: Colors.red,
                  onPressed: () => _showClearCacheDialog(
                    context,
                    'Clear All Cache',
                    'This will remove all cached data. Users may experience slower load times temporarily.',
                    onClearAll,
                  ),
                ),
                CacheActionButton(
                  label: 'Clear Drug Profiles',
                  icon: Icons.medication_outlined,
                  color: Colors.orange,
                  onPressed: () => _showClearCacheDialog(
                    context,
                    'Clear Drug Profiles',
                    'This will clear cached drug profile data. It will be reloaded on next access.',
                    onClearDrugCache,
                  ),
                ),
                CacheActionButton(
                  label: 'Clear Expired',
                  icon: Icons.cleaning_services,
                  color: Colors.blue,
                  onPressed: onClearExpired,
                ),
                CacheActionButton(
                  label: 'Refresh from DB',
                  icon: Icons.refresh,
                  color: Colors.green,
                  onPressed: onRefreshFromDatabase,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(
    BuildContext context,
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
