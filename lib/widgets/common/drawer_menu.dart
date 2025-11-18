import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update every second to keep time live
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(dt.hour)}:${two(dt.minute)}:${two(dt.second)}';
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {'icon': Icons.home, 'title': 'Home', 'builder': AppRoutes.buildHomePage},
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
      {'icon': Icons.speed, 'title': 'Tolerance Dashboard', 'builder': AppRoutes.buildToleranceDashboardPage},
    ];

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          // Use Expanded so the time stays at the bottom
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: pages.map((page) {
                return ListTile(
                  leading: Icon(page['icon']),
                  title: Text(page['title']),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => page['builder']()));
                  },
                );
              }).toList(),
            ),
          ),

          // Live time at the bottom of the drawer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_formatDate(_now), style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  _formatTime(_now),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
