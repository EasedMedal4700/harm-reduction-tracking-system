// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Main activity page with tabs. Uses AppThemeExtension. No hardcoded values.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/common_drawer.dart';
import '../../common/feedback/common_loader.dart';
import '../../common/buttons/common_icon_button.dart';
import 'models/activity_models.dart';
import 'models/activity_state.dart';
import 'providers/activity_providers.dart';
import 'widgets/activity/activity_drug_use_tab.dart';
import 'widgets/activity/activity_cravings_tab.dart';
import 'widgets/activity/activity_reflections_tab.dart';
import 'widgets/activity/activity_detail_helpers.dart';
import '../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/strings/app_strings.dart';

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});
  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;

    ref.listen<ActivityUiEvent?>(
      activityControllerProvider.select((a) => a.valueOrNull?.event),
      (previous, next) {
        if (next == null) return;
        final controller = ref.read(activityControllerProvider.notifier);

        final (message, tone) = next.when(
          snackBar: (message, tone) => (message, tone),
        );

        final bg = switch (tone) {
          ActivityUiEventTone.success => th.colors.success,
          ActivityUiEventTone.error => th.colors.error,
          ActivityUiEventTone.neutral => th.colors.surface,
        };

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bg));
        controller.clearEvent();
      },
    );

    final activityAsync = ref.watch(activityControllerProvider);
    final activityState = activityAsync.valueOrNull ?? const ActivityState();
    final data = activityState.data;
    final showInitialLoader =
        activityAsync.isLoading && activityAsync.valueOrNull == null;

    return Scaffold(
      backgroundColor: th.colors.background,
      appBar: AppBar(
        title: Text(
          'Recent Activity',
          style: th.typography.heading3.copyWith(color: th.colors.textPrimary),
        ),
        backgroundColor: th.colors.surface,
        elevation: th.sizes.elevationNone,
        actions: [
          CommonIconButton(
            icon: Icons.refresh,
            onPressed: () =>
                ref.read(activityControllerProvider.notifier).refreshActivity(),
            tooltip: 'Refresh',
            color: th.colors.textPrimary,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: th.accent.primary,
          labelColor: th.colors.textPrimary,
          unselectedLabelColor: th.colors.textSecondary,
          tabs: [
            Tab(
              icon: Icon(
                Icons.medication,
                size: context.sizes.iconMd,
                semanticLabel: 'Drug Use',
              ),
              text: 'Drug Use',
            ),
            Tab(
              icon: Icon(
                Icons.favorite,
                size: context.sizes.iconMd,
                semanticLabel: 'Cravings',
              ),
              text: 'Cravings',
            ),
            Tab(
              icon: Icon(
                Icons.notes,
                size: context.sizes.iconMd,
                semanticLabel: 'Reflections',
              ),
              text: 'Reflections',
            ),
          ],
        ),
      ),
      drawer: const CommonDrawer(),
      body: showInitialLoader
          ? const CommonLoader()
          : activityAsync.hasError
          ? Center(
              child: Text(
                '${AppStrings.errorLoadingActivity}${activityAsync.error}',
                style: th.typography.body.copyWith(
                  color: th.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDrugUseTab(data.entries),
                _buildCravingsTab(data.cravings),
                _buildReflectionsTab(data.reflections),
              ],
            ),
    );
  }

  Widget _buildDrugUseTab(List<ActivityDrugUseEntry> entries) {
    return ActivityDrugUseTab(
      entries: entries,
      onEntryTap: (entry) => ActivityDetailHelpers.showDrugUseDetail(
        context: context,
        entry: entry,
        onDelete: _handleDelete,
        onUpdate: () =>
            ref.read(activityControllerProvider.notifier).refreshActivity(),
      ),
      onRefresh: () =>
          ref.read(activityControllerProvider.notifier).refreshActivity(),
    );
  }

  Widget _buildCravingsTab(List<ActivityCravingEntry> cravings) {
    return ActivityCravingsTab(
      cravings: cravings,
      onCravingTap: (craving) => ActivityDetailHelpers.showCravingDetail(
        context: context,
        craving: craving,
        onDelete: _handleDelete,
        onUpdate: () =>
            ref.read(activityControllerProvider.notifier).refreshActivity(),
      ),
      onRefresh: () =>
          ref.read(activityControllerProvider.notifier).refreshActivity(),
    );
  }

  Widget _buildReflectionsTab(List<ActivityReflectionEntry> reflections) {
    return ActivityReflectionsTab(
      reflections: reflections,
      onReflectionTap: (reflection) =>
          ActivityDetailHelpers.showReflectionDetail(
            context: context,
            reflection: reflection,
            onDelete: _handleDelete,
            onUpdate: () =>
                ref.read(activityControllerProvider.notifier).refreshActivity(),
          ),
      onRefresh: () =>
          ref.read(activityControllerProvider.notifier).refreshActivity(),
    );
  }

  void _handleDelete({
    required String entryId,
    required ActivityItemType type,
  }) {
    ref
        .read(activityControllerProvider.notifier)
        .deleteEntry(id: entryId, type: type);
  }
}
