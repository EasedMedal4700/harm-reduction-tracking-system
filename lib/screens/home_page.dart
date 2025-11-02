import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/quick_action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openLogEntry(BuildContext context) {
    Navigator.pushNamed(context, '/log_entry');
  }
  void _openAnalytics(BuildContext context) {
    Navigator.pushNamed(context, '/analytics');
  }

  @override
  Widget build(BuildContext context) {
    // Define all quick actions in one list (modular, like your drawer)
    final quickActions = [
      {'icon': Icons.note_add, 'label': 'Log Entry', 'onTap': () => _openLogEntry(context)},
      {'icon': Icons.self_improvement, 'label': 'Reflection', 'onTap': () => print('Reflection pressed')},
      {'icon': Icons.analytics, 'label': 'Analytics', 'onTap': () => _openAnalytics(context)},
      {'icon': Icons.local_fire_department, 'label': 'Cravings', 'onTap': () => print('Cravings pressed')},
      {'icon': Icons.directions_run, 'label': 'Activity', 'onTap': () => print('Activity pressed')},
      {'icon': Icons.dashboard, 'label': 'Dashboard', 'onTap': () => print('Dashboard pressed')},
      {'icon': Icons.menu_book, 'label': 'Library', 'onTap': () => print('Library pressed')},
      {'icon': Icons.inventory, 'label': 'Catalog', 'onTap': () => print('Catalog pressed')},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const DrawerMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLogEntry(context),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
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
    );
  }
}
