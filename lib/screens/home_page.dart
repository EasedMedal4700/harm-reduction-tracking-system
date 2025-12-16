import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/old_common/drawer_menu.dart';
import '../widgets/home_redesign/header_card.dart';
import '../widgets/home_redesign/daily_checkin_card.dart';
import '../widgets/home_page/home_quick_actions_grid.dart';
import '../widgets/home_page/home_progress_stats.dart';
import '../widgets/home_page/home_navigation_methods.dart';
import '../providers/daily_checkin_provider.dart';
import '../constants/colors/ui_colors.dart';
import '../constants/theme/app_theme_constants.dart';
import '../services/daily_checkin_service.dart';
import '../services/user_service.dart';
import '../services/encryption_service_v2.dart';
import '../services/security_manager.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_panel_screen.dart';

/// Redesigned Home Page with modular architecture
/// Supports Light (wellness) and Dark (futuristic) themes
/// 
/// NOTE: Lifecycle handling (background/foreground) is managed centrally
/// by SecurityManager in main.dart. This page does NOT have its own
/// lifecycle observer to prevent fighting/duplicate lock/unlock cycles.
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

  @override
  void initState() {
    super.initState();
    _checkEncryptionStatus();
    
    // Record interaction when home page is opened
    securityManager.recordInteraction();
    
    // Setup animations
    _animationController = AnimationController(
      duration: ThemeConstants.animationNormal,
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
    // Record interaction
    securityManager.recordInteraction();
    
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? UIColors.darkBackground : UIColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontWeight: ThemeConstants.fontSemiBold,
            color: isDark ? UIColors.darkText : UIColors.lightText,
          ),
        ),
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
      drawer: const DrawerMenu(),
      floatingActionButton: _buildFAB(isDark),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with greeting
                const HeaderCard(),
              
              const SizedBox(height: ThemeConstants.cardSpacing),
              
              // Daily Check-in Card
              ChangeNotifierProvider(
                create: (_) {
                  final provider = DailyCheckinProvider(repository: widget.dailyCheckinRepository);
                  provider.initialize();
                  provider.checkExistingCheckin();
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
              
              const SizedBox(height: ThemeConstants.cardSpacing),
              
              // Section Title - Professional typography
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: ThemeConstants.fontXLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space16),
              
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
              
              const SizedBox(height: ThemeConstants.cardSpacing),
              
              // Progress Section
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: ThemeConstants.fontXLarge,
                  fontWeight: ThemeConstants.fontSemiBold,
                  color: isDark ? UIColors.darkText : UIColors.lightText,
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space16),
              
              // Stats Grid
              const HomeProgressStats(),
              
              const SizedBox(height: ThemeConstants.cardSpacing),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildFAB(bool isDark) {
    if (isDark) {
      // Dark theme: subtle blue-purple gradient
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [UIColors.darkFabStart, UIColors.darkFabEnd],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: UIColors.darkFabStart.withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => openLogEntry(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      );
    } else {
      // Light theme: blue
      return FloatingActionButton(
        onPressed: () => openLogEntry(context),
        child: const Icon(Icons.add),
      );
    }
  }
}


