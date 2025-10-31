import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {'icon': Icons.home, 'title': 'Home', 'route': '/home_page'},
      {'icon': Icons.note_add, 'title': 'Log Entry', 'route': '/log_entry'},
      {'icon': Icons.self_improvement, 'title': 'Reflection', 'route': '/reflection'},
      {'icon': Icons.analytics, 'title': 'Analytics', 'route': '/analytics'},
      {'icon': Icons.local_fire_department, 'title': 'Cravings', 'route': '/cravings'},
      {'icon': Icons.directions_run, 'title': 'Activity', 'route': '/activity'},
      {'icon': Icons.dashboard, 'title': 'Dashboard', 'route': '/dashboard'},
      {'icon': Icons.menu_book, 'title': 'Library', 'route': '/library'},
      {'icon': Icons.inventory, 'title': 'Catalog', 'route': '/catalog'},
      {'icon': Icons.settings, 'title': 'Settings', 'route': '/settings'},
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
                if (page['route'] != null) {
                  Navigator.pushNamed(context, page['route']);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}
