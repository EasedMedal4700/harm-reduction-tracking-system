// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod-driven admin panel.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../common/layout/common_drawer.dart';
import '../widgets/stats/admin_stats_section.dart';
import '../widgets/users/admin_user_list.dart';
import '../widgets/app_bar/admin_app_bar.dart';
import '../widgets/cache/cache_management_section.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import 'package:mobile_drug_use_app/constants/strings/app_strings.dart';

import '../providers/admin_providers.dart';

/// Admin panel screen for managing users and monitoring system health
class AdminPanelScreen extends ConsumerWidget {
  const AdminPanelScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final th = context.theme;
    final sp = context.spacing;
    final c = context.colors;

    final adminState = ref.watch(adminPanelControllerProvider);
    final controller = ref.read(adminPanelControllerProvider.notifier);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AdminAppBar(
        isLoading: adminState.isLoading,
        onRefresh: controller.refresh,
      ),
      drawer: const CommonDrawer(),
      body: adminState.isLoading
          ? const CommonLoader()
          : RefreshIndicator(
              color: th.accent.primary,
              onRefresh: controller.refresh,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp.lg),
                child: Column(
                  crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                  children: [
                    // Stats Dashboard
                    AdminStatsSection(
                      stats: adminState.systemStats,
                      perfStats: adminState.performanceStats,
                    ),
                    SizedBox(height: sp.xl),
                    // Cache Management Section
                    CacheManagementSection(
                      cacheStats: adminState.cacheStats,
                      onClearAll: () async {
                        try {
                          await controller.clearAllCache();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.cacheClearedSuccess,
                                ),
                                backgroundColor: th.colors.success,
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.errorClearingCache,
                                ),
                                backgroundColor: th.colors.error,
                              ),
                            );
                          }
                        }
                      },
                      onClearDrugCache: () async {
                        try {
                          await controller.clearDrugCache();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.drugCacheCleared,
                                ),
                                backgroundColor: th.colors.success,
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.errorClearingDrugCache,
                                ),
                                backgroundColor: th.colors.error,
                              ),
                            );
                          }
                        }
                      },
                      onClearExpired: () async {
                        try {
                          await controller.clearExpiredCache();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.expiredCacheCleared,
                                ),
                                backgroundColor: th.colors.success,
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.errorClearingExpiredCache,
                                ),
                                backgroundColor: th.colors.error,
                              ),
                            );
                          }
                        }
                      },
                      onRefreshFromDatabase: () async {
                        try {
                          await controller.refreshFromDatabase();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  '✓ Cache refreshed - data will reload from database',
                                ),
                                backgroundColor: th.colors.success,
                                duration: context.animations.toast,
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.errorRefreshingDatabase,
                                ),
                                backgroundColor: th.colors.error,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(height: sp.xl),
                    // User Management
                    AdminUserList(
                      users: adminState.users,
                      onToggleAdmin: (authUserId, currentlyAdmin) async {
                        try {
                          await controller.toggleAdmin(
                            authUserId: authUserId,
                            currentlyAdmin: currentlyAdmin,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  currentlyAdmin
                                      ? AppStrings.userDemoted
                                      : AppStrings.userPromoted,
                                ),
                              ),
                            );
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  AppStrings.errorToggleAdmin,
                                ),
                                backgroundColor: th.colors.error,
                              ),
                            );
                          }
                        }
                      },
                      onRefresh: controller.refresh,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
