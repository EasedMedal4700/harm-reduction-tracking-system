// MIGRATION:
// State: LEGACY
// Navigation: LEGACY
// Models: LEGACY
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Check-In History using Provider.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:provider/provider.dart';
import '../../common/layout/common_drawer.dart';
import 'widgets/checkin_card.dart';
import 'providers/daily_checkin_provider.dart';
import '../../constants/theme/app_theme_extension.dart';

class CheckinHistoryScreen extends StatefulWidget {
  const CheckinHistoryScreen({super.key});
  @override
  State<CheckinHistoryScreen> createState() => _CheckinHistoryScreenState();
}

class _CheckinHistoryScreenState extends State<CheckinHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<DailyCheckinProvider>().loadRecentCheckins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final c = context.colors;
    final ac = context.accent;
    final sp = context.spacing;
    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text('Check-In History', style: th.typography.heading3),
        backgroundColor: c.surface,
        elevation: th.sizes.elevationNone,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      drawer: const CommonDrawer(),
      body: Consumer<DailyCheckinProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: ac.primary));
          }
          if (provider.recentCheckins.isEmpty) {
            return Center(
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
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(sp.lg),
            itemCount: provider.recentCheckins.length,
            itemBuilder: (context, index) {
              final checkin = provider.recentCheckins[index];
              return CheckinCard(checkin: checkin);
            },
          );
        },
      ),
    );
  }
}
