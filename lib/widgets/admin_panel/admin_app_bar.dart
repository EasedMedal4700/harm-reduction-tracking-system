import 'package:flutter/material.dart';
import '../../screens/admin/error_analytics_screen.dart';
import '../../screens/admin/bug_report_screen.dart';

/// Custom app bar for the admin panel screen
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoading;
  final VoidCallback onRefresh;

  const AdminAppBar({
    super.key,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: const Text('Admin Panel'),
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.report_problem_outlined),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BugReportScreen()),
          ),
          tooltip: 'Report Bug',
        ),
        IconButton(
          icon: const Icon(Icons.bug_report_outlined),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ErrorAnalyticsScreen()),
          ),
          tooltip: 'Error Analytics',
        ),
        IconButton(
          icon: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.refresh),
          onPressed: isLoading ? null : onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
