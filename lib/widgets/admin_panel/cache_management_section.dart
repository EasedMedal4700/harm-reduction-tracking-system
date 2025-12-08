// MIGRATION — Replaced all isDark checks & hardcoded colors with theme system.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
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
    final t = context.theme;

    final totalEntries = cacheStats['total_entries'] ?? 0;
    final activeEntries = cacheStats['active_entries'] ?? 0;
    final expiredEntries = cacheStats['expired_entries'] ?? 0;

    return Container(
      decoration: t.cardDecoration(),
      child: Padding(
        padding: EdgeInsets.all(t.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(Icons.storage_rounded, color: t.colors.info, size: 24),
                SizedBox(width: t.spacing.md),
                Text(
                  'Cache Management',
                  style: t.typography.heading3.copyWith(
                    color: t.colors.textPrimary,
                  ),
                ),
              ],
            ),

            SizedBox(height: t.spacing.lg),

            /// Cache Stats
            Container(
              padding: EdgeInsets.all(t.spacing.md),
              decoration: BoxDecoration(
                color: t.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(t.spacing.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CacheStatWidget(
                    label: 'Total',
                    value: totalEntries.toString(),
                    icon: Icons.data_usage,
                    color: t.colors.info,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: t.colors.divider,
                  ),
                  CacheStatWidget(
                    label: 'Active',
                    value: activeEntries.toString(),
                    icon: Icons.check_circle,
                    color: t.colors.success,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: t.colors.divider,
                  ),
                  CacheStatWidget(
                    label: 'Expired',
                    value: expiredEntries.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: t.colors.warning,
                  ),
                ],
              ),
            ),

            SizedBox(height: t.spacing.lg),

            /// Cache Actions
            Wrap(
              spacing: t.spacing.md,
              runSpacing: t.spacing.md,
              children: [
                CacheActionButton(
                  label: 'Clear All Cache',
                  icon: Icons.delete_sweep,
                  color: t.colors.error,
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
                  color: t.colors.warning,
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
                  color: t.colors.info,
                  onPressed: onClearExpired,
                ),
                CacheActionButton(
                  label: 'Refresh from DB',
                  icon: Icons.refresh,
                  color: t.colors.success,
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
    final t = context.theme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: t.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.spacing.md),
          side: BorderSide(color: t.colors.border),
        ),
        title: Text(
          title,
          style: t.typography.heading4.copyWith(color: t.colors.textPrimary),
        ),
        content: Text(
          message,
          style: t.typography.body.copyWith(color: t.colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: t.typography.button.copyWith(color: t.colors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: t.colors.error,
              foregroundColor: t.colors.textInverse,
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing.lg,
                vertical: t.spacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(t.spacing.sm),
              ),
            ),
            child: Text(
              'Clear',
              style: t.typography.button.copyWith(color: t.colors.textInverse),
            ),
          ),
        ],
      ),
    );
  }
}
