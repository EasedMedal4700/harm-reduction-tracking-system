import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/quick_action_button.dart';
import '../routes/app_routes.dart'; // Ensure this import is added

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openLogEntry(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildLogEntryPage()));
  }
  void _openAnalytics(BuildContext context) {
    Navigator.pushNamed(context, '/analytics');
  }
  void _openCatalog(BuildContext context) {
    Navigator.pushNamed(context, '/catalog');
  }
  void _openCravings(BuildContext context) {
    Navigator.pushNamed(context, '/cravings');
  }
  void _openBloodLevels(BuildContext context) {
    Navigator.pushNamed(context, '/blood_levels');
  }
  void _openReflection(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AppRoutes.buildReflectionPage()));
  }
  void _openActivity(BuildContext context) {
    // Placeholder for Activity page navigation
    print('Activity page navigation not implemented yet.');
  }
  void _openLibrary(BuildContext context) {
    // Placeholder for Library page navigation
    print('Library page navigation not implemented yet.');
  }

  @override
  Widget build(BuildContext context) {
    // Define all quick actions in one list (modular, like your drawer)
    final quickActions = [
      {'icon': Icons.note_add, 'label': 'Log Entry', 'onTap': () => _openLogEntry(context)},
      {'icon': Icons.self_improvement, 'label': 'Reflection', 'onTap': () => _openReflection(context)},
      {'icon': Icons.analytics, 'label': 'Analytics', 'onTap': () => _openAnalytics(context)},
      {'icon': Icons.local_fire_department, 'label': 'Cravings', 'onTap': () => _openCravings(context)},
      {'icon': Icons.directions_run, 'label': 'Activity', 'onTap': () => print('Activity pressed')},
      {'icon': Icons.menu_book, 'label': 'Library', 'onTap': () => print('Library pressed')},
      {'icon': Icons.inventory, 'label': 'Catalog', 'onTap': () => _openCatalog(context)},
      {'icon': Icons.bloodtype, 'label': 'Blood Levels', 'onTap': () => _openBloodLevels(context)},
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
