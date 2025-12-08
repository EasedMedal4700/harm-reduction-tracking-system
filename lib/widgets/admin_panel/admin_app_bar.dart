import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
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
    final t = context.theme;

    return AppBar(
      title: Text(
        'Admin Panel',
        style: t.typography.heading3.copyWith(
          color: t.colors.textPrimary,
        ),
      ),
      backgroundColor: t.colors.surface,
      foregroundColor: t.colors.textPrimary,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.report_problem_outlined),
          color: t.colors.textPrimary,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BugReportScreen()),
          ),
          tooltip: 'Report Bug',
        ),
        IconButton(
          icon: const Icon(Icons.bug_report_outlined),
          color: t.colors.textPrimary,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ErrorAnalyticsScreen()),
          ),
          tooltip: 'Error Analytics',
        ),
        IconButton(
          icon: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(t.colors.textPrimary),
                  ),
                )
              : Icon(Icons.refresh, color: t.colors.textPrimary),
          onPressed: isLoading ? null : onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
