import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../common/layout/common_drawer.dart';
import '../../../common/layout/common_spacer.dart';
import 'home_redesign/header_card.dart';
import 'home_redesign/daily_checkin_card.dart';
import 'home_page/home_quick_actions_grid.dart';
import 'home_page/home_progress_stats.dart';
import 'home_page/home_navigation_methods.dart';
import '../../../providers/daily_checkin_provider.dart';


import '../../../services/daily_checkin_service.dart';
import '../../../services/user_service.dart';
import '../../../services/encryption_service_v2.dart';
import '../profile/profile_screen.dart';
import '../admin/screens/admin_panel_screen.dart';

/// Redesigned Home Page with modular architecture
/// Supports Light (wellness) and Dark (futuristic) themes
/// 
/// NOTE: Lifecycle handling (background/foreground) is managed centrally.
/// This page does NOT have its own lifecycle observer.
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.dailyCheckinRepository});

  final DailyCheckinRepository? dailyCheckinRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, HomeNavigationMethods {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final _encryptionService = EncryptionServiceV2();
  final _userService = UserService();
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _checkEncryptionStatus();
    _loadUserProfile();
    
    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _userService.loadUserProfile();
      if (mounted) {
        setState(() {
          _userName = profile.displayName;
        });
      }
    } catch (e) {
      // Fallback to default
    }
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

  Future<void> _checkEncryptionStatus() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final hasEncryption = await _encryptionService.hasEncryptionSetup(user.id);
      if (hasEncryption && !_encryptionService.isReady) {
        _requireUnlock();
      }
    } catch (e) {
      print('⚠️ Error checking encryption status: $e');
    }
  }

  void _requireUnlock() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/pin-unlock');
    }
  }

  void _openDailyCheckin(BuildContext context) async {
    // Navigate to daily check-in and wait for result
    await Navigator.pushNamed(context, '/daily-checkin');
    
    // Refresh the daily check-in status when returning
    if (context.mounted) {
      final provider = Provider.of<DailyCheckinProvider>(context, listen: false);
      await provider.checkExistingCheckin();
      
      // Trigger rebuild to show updated status
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final c = context.colors;
    final sp = context.spacing;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text(
          'Home',
          style: text.headlineSmall.copyWith(
            color: c.textPrimary,
          ),
        ),
        backgroundColor: c.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: c.textPrimary),
        actions: [
          // Profile Button
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            tooltip: 'Profile',
          ),
          // Admin Panel Button (shown only for admins)
          FutureBuilder<bool>(
            future: UserService.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                    );
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
        color: context.accent.primary,
        backgroundColor: c.surface,
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(sp.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with greeting
                HeaderCard(
                  userName: _userName,
                  greeting: _getGreeting(),
                  onProfileTap: () => Navigator.pushNamed(context, '/profile'),
                ),
              
              CommonSpacer.vertical(sp.lg),
              
              // Daily Check-in Card
              ChangeNotifierProvider(
                create: (_) {
                  final provider = DailyCheckinProvider(repository: widget.dailyCheckinRepository);
                  provider.initialize();
                  // Schedule check to avoid setState during build
                  Future.microtask(() => provider.checkExistingCheckin());
                  return provider;
                },
                child: Consumer<DailyCheckinProvider>(
                  builder: (context, provider, _) {
                    final hasCompleted = provider.existingCheckin != null;
                    final timeSlot = provider.existingCheckin?.timeOfDay;
                    return DailyCheckinCard(
                      isCompleted: hasCompleted,
                      onTap: () => _openDailyCheckin(context),
                      completedMessage: 'Keep up the great work!',
                      completedTimeSlot: timeSlot,
                    );
                  },
                ),
              ),
              
              CommonSpacer.vertical(sp.lg),
              
              // Section Title - Professional typography
              Text(
                'Quick Actions',
                style: text.headlineMedium.copyWith(
                  color: c.textPrimary,
                ),
              ),
              
              CommonSpacer.vertical(sp.md),
              
              // Quick Actions Grid - Always 2 columns for consistency
              HomeQuickActionsGrid(
                onLogEntry: () => openLogEntry(context),
                onReflection: () => openReflection(context),
                onAnalytics: () => openAnalytics(context),
                onCravings: () => openCravings(context),
                onActivity: () => openActivity(context),
                onLibrary: () => openLibrary(context),
                onCatalog: () => openCatalog(context),
                onBloodLevels: () => openBloodLevels(context),
              ),
              
              CommonSpacer.vertical(sp.lg),
              
              // Progress Section
              Text(
                'Your Progress',
                style: text.headlineMedium.copyWith(
                  color: c.textPrimary,
                ),
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
    final a = context.accent;
    final sh = context.shapes;

    // Using primary color for FAB in both themes for consistency, or could use accent if defined.
    // Assuming primary is the main action color.
    return FloatingActionButton(
      onPressed: () => openLogEntry(context),
      backgroundColor: a.primary,
      foregroundColor: c.textInverse,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sh.radiusMd)),
      child: const Icon(Icons.add),
    );
  }
}




