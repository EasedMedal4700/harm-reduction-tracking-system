
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-based. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/cards/common_card.dart';
import 'package:mobile_drug_use_app/common/buttons/common_primary_button.dart';
import '../stats/cache_stat_widget.dart';
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
    final c = context.colors;
    final t = context.theme;
    final sp = context.spacing;
    final text = context.text;
    final sh = context.shapes;

    final totalEntries = cacheStats['total_entries'] ?? 0;
    final activeEntries = cacheStats['active_entries'] ?? 0;
    final expiredEntries = cacheStats['expired_entries'] ?? 0;

    return CommonCard(
      borderRadius: sh.radiusMd,
      padding: EdgeInsets.all(sp.lg),
      showBorder: false,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Icon(Icons.storage_rounded, color: c.info, size: sp.lg),
                SizedBox(width: sp.md),
                Text(
                  'Cache Management',
                  style: text.heading3.copyWith(color: c.textPrimary),
                ),
              ],
            ),

            SizedBox(height: sp.lg),

            /// Cache Stats
            Container(
              padding: EdgeInsets.all(sp.md),
              decoration: BoxDecoration(
                color: c.surfaceVariant,
                borderRadius: BorderRadius.circular(sp.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CacheStatWidget(
                    label: 'Total',
                    value: totalEntries.toString(),
                    icon: Icons.data_usage,
                    color: c.info,
                  ),
                  Container(
                    width: 1,
                    height: sp.xl3,
                    color: c.divider,
                  ),
                  CacheStatWidget(
                    label: 'Active',
                    value: activeEntries.toString(),
                    icon: Icons.check_circle,
                    color: c.success,
                  ),
                  Container(
                    width: 1,
                    height: sp.xl3,
                    color: c.divider,
                  ),
                  CacheStatWidget(
                    label: 'Expired',
                    value: expiredEntries.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: c.warning,
                  ),
                ],
              ),
            ),

            SizedBox(height: sp.lg),

            /// Cache Actions
            Wrap(
              spacing: sp.md,
              runSpacing: sp.md,
              children: [
                CacheActionButton(
                  label: 'Clear All Cache',
                  icon: Icons.delete_sweep,
                  color: c.error,
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
                  color: c.warning,
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
                  color: c.info,
                  onPressed: onClearExpired,
                ),
                CacheActionButton(
                  label: 'Refresh from DB',
                  icon: Icons.refresh,
                  color: c.success,
                  onPressed: onRefreshFromDatabase,
                ),
              ],
            ),
          ],
        ),
    );
  }

  void _showClearCacheDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sp.md),
          side: BorderSide(color: c.border),
        ),
        title: Text(
          title,
          style: text.heading4.copyWith(color: c.textPrimary),
        ),
        content: Text(
          message,
          style: text.body.copyWith(color: c.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: text.button.copyWith(color: c.textSecondary),
            ),
          ),
          CommonPrimaryButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            label: 'Clear',
            backgroundColor: c.error,
            textColor: c.textInverse,
          ),
        ],
      ),
    );
  }
}
