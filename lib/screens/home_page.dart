import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/common/drawer_menu.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/home/daily_checkin_banner.dart';
import '../providers/daily_checkin_provider.dart';
import '../routes/app_routes.dart';
import '../services/daily_checkin_service.dart';
import '../services/user_service.dart';
import '../screens/profile_screen.dart';
import '../screens/admin_panel_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.dailyCheckinRepository});

  final DailyCheckinRepository? dailyCheckinRepository;

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

  @override
  Widget build(BuildContext context) {
    // Define all quick actions in one list (modular, like your drawer)
    final quickActions = [
      {'icon': Icons.note_add, 'label': 'Log Entry', 'onTap': () => _openLogEntry(context)},
      {'icon': Icons.self_improvement, 'label': 'Reflection', 'onTap': () => _openReflection(context)},
      {'icon': Icons.analytics, 'label': 'Analytics', 'onTap': () => _openAnalytics(context)},
      {'icon': Icons.local_fire_department, 'label': 'Cravings', 'onTap': () => _openCravings(context)},
      {'icon': Icons.directions_run, 'label': 'Activity', 'onTap': () => _openActivity(context)},
      {'icon': Icons.menu_book, 'label': 'Library', 'onTap': () => _openLibrary(context)},
      {'icon': Icons.inventory, 'label': 'Catalog', 'onTap': () => _openCatalog(context)},
      {'icon': Icons.bloodtype, 'label': 'Blood Levels', 'onTap': () => _openBloodLevels(context)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Daily Check-In Banner at the top
            ChangeNotifierProvider(
              create: (_) => DailyCheckinProvider(repository: dailyCheckinRepository),
              child: const DailyCheckinBanner(),
            ),

            // Quick Actions section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Generate buttons automatically from the list
                  ...quickActions.map((action) => QuickActionButton(
                        icon: action['icon'] as IconData,
                        label: action['label'] as String,
                        onPressed: action['onTap'] as VoidCallback,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
