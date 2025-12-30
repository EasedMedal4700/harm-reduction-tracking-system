// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: FREEZED
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Riverpod-managed orchestration; widgets emit intent only.
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/constants/theme/app_animations.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/layout/common_drawer.dart';
import '../../common/layout/common_spacer.dart';
import 'home_redesign/header_card.dart';
import 'home_redesign/daily_checkin_card.dart';
import 'home_page/home_quick_actions_grid.dart';
import 'home_page/home_progress_stats.dart';
import 'package:mobile_drug_use_app/core/services/user_service.dart';

import '../daily_chekin/providers/daily_checkin_providers.dart';
import 'providers/home_providers.dart';

/// Redesigned Home Page with modular architecture
/// Supports Light (wellness) and Dark (futuristic) themes
///
/// NOTE: Lifecycle handling (background/foreground) is managed centrally.
/// This page does NOT have its own lifecycle observer.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).initialize();
    });
    // Setup animations - duration will be set in didChangeDependencies
    _animationController = AnimationController(
      duration: const AppAnimations().normal,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ac = context.accent;
    final tx = context.text;
    final c = context.colors;
    final sp = context.spacing;

    final homeState = ref.watch(homeControllerProvider);
    final checkin = ref.watch(dailyCheckinForNowProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'Home',
          style: tx.headlineSmall.copyWith(color: c.textPrimary),
        ),
        backgroundColor: c.surface,
        elevation: context.sizes.elevationNone,
        iconTheme: IconThemeData(color: c.textPrimary),
        actions: [
          // Profile Button
          IconButton(
            icon: const Icon(Icons.account_circle, semanticLabel: 'Profile'),
            onPressed: () {
              ref.read(homeControllerProvider.notifier).openProfile();
            },
            tooltip: 'Profile',
          ),
          // Admin Panel Button (shown only for admins)
          FutureBuilder<bool>(
            future: UserService.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(
                    Icons.admin_panel_settings,
                    semanticLabel: 'Admin Panel',
                  ),
                  onPressed: () {
                    ref.read(homeControllerProvider.notifier).openAdminPanel();
                  },
                  tooltip: 'Admin Panel',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      floatingActionButton: _buildFAB(context),
      body: RefreshIndicator(
        color: ac.primary,
        backgroundColor: c.surface,
        onRefresh: () async {
          await Future.delayed(context.animations.slow);
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(sp.lg),
            child: Column(
              crossAxisAlignment: AppLayout.crossAxisAlignmentStretch,
              children: [
                // Header with greeting
                HeaderCard(
                  userName: homeState.userName,
                  greeting: _getGreeting(),
                  onProfileTap: () =>
                      ref.read(homeControllerProvider.notifier).openProfile(),
                ),
                CommonSpacer.vertical(sp.lg),
                // Daily Check-in Card
                DailyCheckinCard(
                  isCompleted: checkin.valueOrNull != null,
                  onTap: () => ref
                      .read(homeControllerProvider.notifier)
                      .openDailyCheckin(),
                  completedMessage: 'Keep up the great work!',
                  completedTimeSlot: checkin.valueOrNull?.timeOfDay,
                ),
                CommonSpacer.vertical(sp.lg),
                // Section Title - Professional typography
                Text(
                  'Quick Actions',
                  style: tx.headlineMedium.copyWith(color: c.textPrimary),
                ),
                CommonSpacer.vertical(sp.md),
                // Quick Actions Grid - Always 2 columns for consistency
                HomeQuickActionsGrid(
                  onLogEntry: () =>
                      ref.read(homeControllerProvider.notifier).openLogEntry(),
                  onReflection: () => ref
                      .read(homeControllerProvider.notifier)
                      .openReflection(),
                  onAnalytics: () =>
                      ref.read(homeControllerProvider.notifier).openAnalytics(),
                  onCravings: () =>
                      ref.read(homeControllerProvider.notifier).openCravings(),
                  onActivity: () =>
                      ref.read(homeControllerProvider.notifier).openActivity(),
                  onLibrary: () =>
                      ref.read(homeControllerProvider.notifier).openLibrary(),
                  onCatalog: () =>
                      ref.read(homeControllerProvider.notifier).openCatalog(),
                  onBloodLevels: () => ref
                      .read(homeControllerProvider.notifier)
                      .openBloodLevels(),
                ),
                CommonSpacer.vertical(sp.lg),
                // Progress Section
                Text(
                  'Your Progress',
                  style: tx.headlineMedium.copyWith(color: c.textPrimary),
                ),
                CommonSpacer.vertical(sp.md),
                // Stats Grid
                const HomeProgressStats(),
                CommonSpacer.vertical(sp.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    final c = context.colors;
    final ac = context.accent;

    final sh = context.shapes;
    // Using primary color for FAB in both themes for consistency, or could use accent if defined.
    // Assuming primary is the main action color.
    return FloatingActionButton(
      onPressed: () => ref.read(homeControllerProvider.notifier).openLogEntry(),
      backgroundColor: ac.primary,
      foregroundColor: c.textInverse,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sh.radiusMd),
      ),
      child: const Icon(Icons.add, semanticLabel: 'Add Entry'),
    );
  }
}
