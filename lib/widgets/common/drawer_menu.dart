import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    // Section 1: Main Navigation
    final List<Map<String, dynamic>> mainPages = [
      {'icon': Icons.home, 'title': 'Home', 'builder': AppRoutes.buildHomePage},
      {'icon': Icons.bloodtype, 'title': 'Blood Levels', 'builder': AppRoutes.buildBloodLevelsPage},
      {'icon': Icons.directions_run, 'title': 'Activity', 'builder': AppRoutes.buildActivityPage},
      {'icon': Icons.local_fire_department, 'title': 'Cravings', 'builder': AppRoutes.buildCravingsPage},
      {'icon': Icons.self_improvement, 'title': 'Reflection', 'builder': AppRoutes.buildReflectionPage},
    ];

    // Section 2: Data & Resources
    final List<Map<String, dynamic>> dataPages = [
      {'icon': Icons.menu_book, 'title': 'Library', 'builder': AppRoutes.buildLibraryPage},
      {'icon': Icons.analytics, 'title': 'Analytics', 'builder': AppRoutes.buildAnalyticsPage},
      {'icon': Icons.inventory, 'title': 'Catalog', 'builder': AppRoutes.buildCatalogPage},
    ];

    // Section 3: Advanced Features (New)
    final List<Map<String, dynamic>> advancedPages = [
      {'icon': Icons.favorite, 'title': 'Physiological', 'builder': AppRoutes.buildPhysiologicalPage},
      {'icon': Icons.compare_arrows, 'title': 'Interactions', 'builder': AppRoutes.buildInteractionsPage},
      {'icon': Icons.speed, 'title': 'Tolerance', 'builder': AppRoutes.buildToleranceDashboardPage},
      {'icon': Icons.watch, 'title': 'WearOS', 'builder': AppRoutes.buildWearOSPage},
    ];

    return Drawer(
      child: Column(
        children: [
          // Modern gradient header
          _buildModernHeader(context),
          
          // Use Expanded so the time stays at the bottom
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Section 1: Main Navigation
                ...mainPages.map((page) => _buildMenuItem(context, page)),
                _buildSleekDivider(),
                
                // Section 2: Data & Resources
                ...dataPages.map((page) => _buildMenuItem(context, page)),
                _buildSleekDivider(),
                
                // Section 3: Advanced Features
                ...advancedPages.map((page) => _buildMenuItem(context, page)),
                _buildSleekDivider(),
                
                // Daily Check-In
                _buildMenuItem(context, {
                  'icon': Icons.mood,
                  'title': 'Daily Check-In',
                  'builder': AppRoutes.buildDailyCheckinPage
                }),
                
                // Log Entry at bottom
                _buildMenuItem(context, {
                  'icon': Icons.note_add,
                  'title': 'Log Entry',
                  'builder': AppRoutes.buildLogEntryPage
                }),
                
                // Settings
                _buildMenuItem(context, {
                  'icon': Icons.settings,
                  'title': 'Settings',
                  'builder': AppRoutes.buildSettingsPage
                }),
                
                // Bug Report
                _buildMenuItem(context, {
                  'icon': Icons.report_problem,
                  'title': 'Report a Bug',
                  'builder': AppRoutes.buildBugReportPage
                }),
              ],
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

  Widget _buildModernHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'Guest';
    final username = email.split('@')[0];
    
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1A1A2E), const Color(0xFF2A2A3E)]
              : [Colors.blue.shade700, Colors.blue.shade900],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> page) {
    return ListTile(
      leading: Icon(page['icon']),
      title: Text(page['title']),
      onTap: () async {
        Navigator.pop(context);
        // Navigate and wait for result - triggers refresh on return
        await Navigator.push(context, MaterialPageRoute(builder: (_) => page['builder']()));
        // Trigger rebuild of current page by popping/pushing context
        if (context.mounted) {
          // This causes the calling page to rebuild
          (context as Element).markNeedsBuild();
        }
      },
    );
  }

  Widget _buildSleekDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.grey.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
