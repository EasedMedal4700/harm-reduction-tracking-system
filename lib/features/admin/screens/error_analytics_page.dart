// MIGRATION:
// State: MODERN
// Navigation: GOROUTER
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod-driven error analytics.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import 'package:mobile_drug_use_app/constants/strings/app_strings.dart';
import '../widgets/errors/error_analytics_section.dart';
import '../widgets/errors/error_cleanup_dialog.dart';
import '../widgets/errors/error_log_detail_dialog.dart';

import '../providers/admin_providers.dart';
import '../models/error_cleanup_filters.dart';
import '../models/error_log_entry.dart';

class ErrorAnalyticsScreen extends ConsumerWidget {
  const ErrorAnalyticsScreen({super.key});
  Future<void> _showErrorCleanupDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final state = ref.read(errorAnalyticsControllerProvider);
      final platformOptions = state.analytics.platformBreakdown
          .map((item) => item.label)
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList();
      final screenOptions = state.analytics.screenBreakdown
          .map((item) => item.label)
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList();
      final result = await showDialog<ErrorCleanupFilters?>(
        context: context,
        builder: (context) => ErrorCleanupDialog(
          platformOptions: platformOptions,
          screenOptions: screenOptions,
        ),
      );
      if (result == null || !context.mounted) return;
      final deleteAll = result.deleteAll;
      final olderThanDays = result.olderThanDays;
      final platform = result.platform;
      final screen = result.screenName;
      if (!deleteAll &&
          olderThanDays == null &&
          (platform?.isEmpty ?? true) &&
          (screen?.isEmpty ?? true)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.errorAnalyticsFilterRequired),
            ),
          );
        }
        return;
      }
      await ref
          .read(errorAnalyticsControllerProvider.notifier)
          .clearErrorLogs(
            deleteAll: deleteAll,
            olderThanDays: olderThanDays,
            platform: platform,
            screenName: screen,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorLogsCleaned)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorCleaningLogs)),
        );
      }
    }
  }

  void _showLogDetails(BuildContext context, ErrorLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ErrorLogDetailDialog(log: log),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;

    final state = ref.watch(errorAnalyticsControllerProvider);
    final controller = ref.read(errorAnalyticsControllerProvider.notifier);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: const Text(AppStrings.errorAnalyticsTitle),
        backgroundColor: c.surface,
        foregroundColor: c.textPrimary,
        elevation: context.sizes.elevationNone,
        actions: [
          Semantics(
            button: true,
            enabled: !state.isLoading,
            label: state.isLoading ? 'Loading data' : 'Refresh data',
            child: IconButton(
              icon: state.isLoading
                  ? CommonLoader(
                      size: context.sizes.iconSm,
                      color: c.textPrimary,
                    )
                  : const Icon(Icons.refresh),
              onPressed: () {
                if (!state.isLoading) controller.refresh();
              },
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
      body: state.isLoading
          ? const CommonLoader()
          : RefreshIndicator(
              onRefresh: controller.refresh,
              color: ac.primary,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(sp.md),
                child: ErrorAnalyticsSection(
                  analytics: state.analytics,
                  isClearingErrors: state.isClearingErrors,
                  onCleanLogs: () => _showErrorCleanupDialog(context, ref),
                  onShowLogDetails: (log) => _showLogDetails(context, log),
                ),
              ),
            ),
    );
  }
}
