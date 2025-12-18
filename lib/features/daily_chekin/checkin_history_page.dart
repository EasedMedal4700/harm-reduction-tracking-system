import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/old_common/drawer_menu.dart';
import 'widgets/checkin_history/checkin_card.dart';
import '../../providers/daily_checkin_provider.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../constants/theme/app_theme_constants.dart';

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
    final t = context.theme;
    final c = context.colors;
    final a = context.accent;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text('Check-In History', style: t.typography.heading3),
        backgroundColor: c.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      drawer: const DrawerMenu(),
      body: Consumer<DailyCheckinProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: a.primary));
          }

          if (provider.recentCheckins.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: AppThemeConstants.icon2xl, color: c.textSecondary),
                  SizedBox(height: sp.lg),
                  Text(
                    'No check-ins yet',
                    style: t.typography.heading3.copyWith(color: c.textSecondary),
                  ),
                  SizedBox(height: sp.sm),
                  Text(
                    'Start tracking your daily mood!',
                    style: t.typography.body.copyWith(color: c.textSecondary),
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
