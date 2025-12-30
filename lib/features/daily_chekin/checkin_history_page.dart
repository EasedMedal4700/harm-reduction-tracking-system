// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod-driven history list.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/checkin_card.dart';
import '../../constants/theme/app_theme_extension.dart';
import 'providers/daily_checkin_providers.dart';

class CheckinHistoryScreen extends ConsumerStatefulWidget {
  const CheckinHistoryScreen({super.key});
  @override
  ConsumerState<CheckinHistoryScreen> createState() =>
      _CheckinHistoryScreenState();
}

class _CheckinHistoryScreenState extends ConsumerState<CheckinHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailyCheckinControllerProvider.notifier).loadRecentCheckins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;

    final state = ref.watch(dailyCheckinControllerProvider);
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text('Check-In History', style: th.typography.heading3),
        backgroundColor: c.surface,
        elevation: th.sizes.elevationNone,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      drawer: const CommonDrawer(),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator(color: ac.primary))
          : state.recentCheckins.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: AppLayout.mainAxisAlignmentCenter,
                children: [
                  Icon(
                    Icons.history,
                    size: context.sizes.icon2xl,
                    color: c.textSecondary,
                  ),
                  SizedBox(height: sp.lg),
                  Text(
                    'No check-ins yet',
                    style: th.typography.heading3.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                  SizedBox(height: sp.sm),
                  Text(
                    'Start tracking your daily mood!',
                    style: th.typography.body.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(sp.lg),
              itemCount: state.recentCheckins.length,
              itemBuilder: (context, index) {
                final checkin = state.recentCheckins[index];
                return CheckinCard(checkin: checkin);
              },
            ),
    );
  }
}
