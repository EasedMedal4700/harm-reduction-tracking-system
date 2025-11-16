import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {'icon': Icons.home, 'title': 'Home', 'builder': AppRoutes.buildHomePage}, // Add builders
      {'icon': Icons.note_add, 'title': 'Log Entry', 'builder': AppRoutes.buildLogEntryPage},
      {'icon': Icons.mood, 'title': 'Daily Check-In', 'builder': AppRoutes.buildDailyCheckinPage},
      {'icon': Icons.self_improvement, 'title': 'Reflection', 'builder': AppRoutes.buildReflectionPage},
      {'icon': Icons.analytics, 'title': 'Analytics', 'builder': AppRoutes.buildAnalyticsPage},
      {'icon': Icons.local_fire_department, 'title': 'Cravings', 'builder': AppRoutes.buildCravingsPage},
      {'icon': Icons.access_time, 'title': 'Recent Activity', 'builder': AppRoutes.buildActivityPage},
      {'icon': Icons.bloodtype, 'title': 'Blood Levels', 'builder': AppRoutes.buildBloodLevelsPage},
      {'icon': Icons.menu_book, 'title': 'Library', 'builder': AppRoutes.buildLibraryPage},
      {'icon': Icons.inventory, 'title': 'Catalog', 'builder': AppRoutes.buildCatalogPage},
      {'icon': Icons.settings, 'title': 'Settings', 'builder': AppRoutes.buildSettingsPage},
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ...pages.map((page) {
            return ListTile(
              leading: Icon(page['icon']),
              title: Text(page['title']),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => page['builder']()));
              },
            );
          }),
        ],
      ),
    );
  }
}
