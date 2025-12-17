
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-based. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';
import '../../screens/error_analytics_screen.dart';
import '../../screens/bug_report_screen.dart';

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
    final c = context.colors;
    final text = context.text;
    final sp = context.spacing;

    return AppBar(
      title: Text(
        'Admin Panel',
        style: text.heading3.copyWith(color: c.textPrimary),
      ),
      backgroundColor: c.surface,
      foregroundColor: c.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      actions: [
        Padding(
          padding: EdgeInsets.only(right: sp.sm),
          child: IconButton(
            icon: const Icon(Icons.report_problem_outlined),
            color: c.textPrimary,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BugReportScreen()),
            ),
            tooltip: 'Report Bug',
          ),
        ),

        IconButton(
          icon: const Icon(Icons.bug_report_outlined),
          color: c.textPrimary,
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
                        AlwaysStoppedAnimation<Color>(c.textPrimary),
                  ),
                )
              : Icon(Icons.refresh, color: c.textPrimary),
          onPressed: isLoading ? null : onRefresh,
          tooltip: 'Refresh',
        ),

        SizedBox(width: sp.xs),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
