import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/home_redesign/header_card.dart';
import '../widgets/home_redesign/daily_checkin_card.dart';
import '../widgets/home_redesign/quick_action_card.dart';
import '../widgets/home_redesign/stat_card.dart';
import '../providers/daily_checkin_provider.dart';
import '../constants/ui_colors.dart';
import '../constants/theme_constants.dart';
import '../routes/app_routes.dart';
import '../services/daily_checkin_service.dart';
import '../services/user_service.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_panel_screen.dart';

/// Redesigned Home Page with modular architecture
/// Supports Light (wellness) and Dark (futuristic) themes
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.dailyCheckinRepository});

  final DailyCheckinRepository? dailyCheckinRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
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

  // Navigation methods
  void _openLogEntry(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildLogEntryPage()));
  }
  void _openAnalytics(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildAnalyticsPage()));
  }
  void _openCatalog(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildCatalogPage()));
  }
  void _openCravings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildCravingsPage()));
  }
  void _openBloodLevels(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildBloodLevelsPage()));
  }
  void _openReflection(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildReflectionPage()));
  }
  void _openActivity(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildActivityPage()));
  }
  void _openLibrary(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildLibraryPage()));
  }
  void _openToleranceDashboard(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildToleranceDashboardPage()));
  }
  void _openDailyCheckin(BuildContext context) {
    Navigator.pushNamed(context, '/daily-checkin');
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
      body: FadeTransition(
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
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: ThemeConstants.quickActionSpacing,
                mainAxisSpacing: ThemeConstants.quickActionSpacing,
                childAspectRatio: 1.1,
                children: [
                  QuickActionCard(
                    actionKey: 'log_usage',
                    icon: Icons.note_add,
                    label: 'Log Entry',
                    onTap: () => _openLogEntry(context),
                  ),
                  QuickActionCard(
                    actionKey: 'reflection',
                    icon: Icons.self_improvement,
                    label: 'Reflection',
                    onTap: () => _openReflection(context),
                  ),
                  QuickActionCard(
                    actionKey: 'analytics',
                    icon: Icons.analytics,
                    label: 'Analytics',
                    onTap: () => _openAnalytics(context),
                  ),
                  QuickActionCard(
                    actionKey: 'cravings',
                    icon: Icons.local_fire_department,
                    label: 'Cravings',
                    onTap: () => _openCravings(context),
                  ),
                  QuickActionCard(
                    actionKey: 'activity',
                    icon: Icons.directions_run,
                    label: 'Activity',
                    onTap: () => _openActivity(context),
                  ),
                  QuickActionCard(
                    actionKey: 'library',
                    icon: Icons.menu_book,
                    label: 'Library',
                    onTap: () => _openLibrary(context),
                  ),
                  QuickActionCard(
                    actionKey: 'catalog',
                    icon: Icons.inventory,
                    label: 'Catalog',
                    onTap: () => _openCatalog(context),
                  ),
                  QuickActionCard(
                    actionKey: 'blood_levels',
                    icon: Icons.bloodtype,
                    label: 'Blood Levels',
                    onTap: () => _openBloodLevels(context),
                  ),
                ],
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
              GridView.count(
                crossAxisCount: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: ThemeConstants.cardSpacing,
                mainAxisSpacing: ThemeConstants.cardSpacing,
                childAspectRatio: 2.5,
                children: const [
                  StatCard(
                    icon: Icons.calendar_today,
                    value: '127',
                    label: 'Days Tracked',
                    subtitle: 'Keep up the momentum!',
                  ),
                  StatCard(
                    icon: Icons.note_alt,
                    value: '12',
                    label: 'Entries This Week',
                    subtitle: '+3 from last week',
                  ),
                  StatCard(
                    icon: Icons.psychology,
                    value: '8',
                    label: 'Active Reflections',
                    subtitle: 'Recent insights',
                    progress: 0.65,
                  ),
                ],
              ),
              
              const SizedBox(height: ThemeConstants.cardSpacing),
            ],
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
          onPressed: () => _openLogEntry(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
      );
    } else {
      // Light theme: blue
      return FloatingActionButton(
        onPressed: () => _openLogEntry(context),
        child: const Icon(Icons.add),
      );
    }
  }
}
