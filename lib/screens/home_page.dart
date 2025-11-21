import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/home/daily_checkin_banner.dart';
import '../widgets/home/greeting_banner.dart';
import '../widgets/home/quick_actions_grid.dart';
import '../widgets/home/progress_overview_card.dart';
import '../providers/daily_checkin_provider.dart';
import '../providers/settings_provider.dart';
import '../routes/app_routes.dart';
import '../services/daily_checkin_service.dart';
import '../services/user_service.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_panel_screen.dart';
import '../styles/app_theme.dart';
import '../constants/app_theme_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.dailyCheckinRepository});

  final DailyCheckinRepository? dailyCheckinRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations for card entrance
    _animationController = AnimationController(
      duration: AppThemeConstants.animationNormal,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppThemeConstants.animationCurveEmphasized,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    // Get theme from settings
    final settingsProvider = context.watch<SettingsProvider>();
    final theme = AppTheme.fromSettings(settingsProvider.settings);
    
    // Build quick actions list
    final quickActions = _buildQuickActions();
    
    // Build stats data (example - you can fetch real data)
    final stats = _buildStatsData();

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: theme.isDark ? theme.colors.surface : theme.accent.primary,
        foregroundColor: theme.isDark ? theme.colors.textPrimary : theme.colors.textInverse,
        elevation: 0,
        title: Text(
          'Home',
          style: theme.typography.heading3.copyWith(
            color: theme.isDark ? theme.colors.textPrimary : theme.colors.textInverse,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLogEntry(context),
        backgroundColor: theme.accent.primary,
        child: Icon(Icons.add, color: theme.colors.textInverse),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Daily Check-In Banner (existing)
                ChangeNotifierProvider(
                  create: (_) => DailyCheckinProvider(repository: widget.dailyCheckinRepository),
                  child: const DailyCheckinBanner(),
                ),

                SizedBox(height: theme.spacing.md),

                // Greeting Banner (new)
                GreetingBanner(theme: theme),

                SizedBox(height: theme.spacing.xl),

                // Quick Actions Grid (new design)
                QuickActionsGrid(
                  theme: theme,
                  actions: quickActions,
                ),

                SizedBox(height: theme.spacing.xl),

                // Progress Overview (new)
                ProgressOverviewCard(
                  theme: theme,
                  stats: stats,
                ),

                SizedBox(height: theme.spacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<QuickActionData> _buildQuickActions() {
    return [
      QuickActionData(
        icon: Icons.note_add,
        label: 'Log Entry',
        onTap: () => _openLogEntry(context),
      ),
      QuickActionData(
        icon: Icons.self_improvement,
        label: 'Reflection',
        onTap: () => _openReflection(context),
      ),
      QuickActionData(
        icon: Icons.analytics,
        label: 'Analytics',
        onTap: () => _openAnalytics(context),
      ),
      QuickActionData(
        icon: Icons.local_fire_department,
        label: 'Cravings',
        onTap: () => _openCravings(context),
      ),
      QuickActionData(
        icon: Icons.directions_run,
        label: 'Activity',
        onTap: () => _openActivity(context),
      ),
      QuickActionData(
        icon: Icons.menu_book,
        label: 'Library',
        onTap: () => _openLibrary(context),
      ),
      QuickActionData(
        icon: Icons.inventory,
        label: 'Catalog',
        onTap: () => _openCatalog(context),
      ),
      QuickActionData(
        icon: Icons.bloodtype,
        label: 'Blood Levels',
        onTap: () => _openBloodLevels(context),
      ),
      QuickActionData(
        icon: Icons.speed,
        label: 'Tolerance',
        onTap: () => _openToleranceDashboard(context),
      ),
    ];
  }

  List<StatsData> _buildStatsData() {
    // TODO: Replace with real data from services
    return const [
      StatsData(
        title: 'Days Tracked',
        value: '127',
        subtitle: 'Keep up the momentum!',
        icon: Icons.calendar_today,
      ),
      StatsData(
        title: 'Entries This Week',
        value: '12',
        subtitle: '+3 from last week',
        icon: Icons.note_alt,
      ),
      StatsData(
        title: 'Active Reflections',
        value: '8',
        subtitle: 'Recent insights',
        icon: Icons.psychology,
      ),
    ];
  }
}
