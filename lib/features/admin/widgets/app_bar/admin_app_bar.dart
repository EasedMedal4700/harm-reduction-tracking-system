// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Fully theme-based. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/common/feedback/common_loader.dart';
import '../../screens/error_analytics_page.dart';
import '../../../bug_report/bug_report_page.dart';

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
      elevation: context.sizes.elevationNone,
      scrolledUnderElevation: context.sizes.elevationNone,
      surfaceTintColor: c.transparent,

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

        Semantics(
          button: true,
          enabled: !isLoading,
          label: isLoading ? 'Loading' : 'Refresh',
          child: IconButton(
            icon: isLoading
                ? CommonLoader(size: context.sizes.iconSm, color: c.textPrimary)
                : Icon(Icons.refresh, color: c.textPrimary),
            onPressed: () {
              if (!isLoading) onRefresh();
            },
            tooltip: 'Refresh',
          ),
        ),

        SizedBox(width: sp.xs),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
