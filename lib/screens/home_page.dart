import 'package:flutter/material.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/quick_action_button.dart';
import '../routes/app_routes.dart'; // Ensure this import is added
import '../widgets/drawer_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
