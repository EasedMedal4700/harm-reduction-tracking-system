// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and existing common components. No logic or state changes.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/buttons/common_icon_button.dart';

class LibraryAppBar extends StatelessWidget {
  final bool showArchived;
  final VoidCallback onToggleArchived;
  final VoidCallback onRefresh;
  const LibraryAppBar({
    super.key,
    required this.showArchived,
    required this.onToggleArchived,
    required this.onRefresh,
  });
  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    return SliverAppBar(
      title: const Text('Personal Library'),
      backgroundColor: th.colors.surface,
      pinned: true,
      floating: false,
      actions: [
        CommonIconButton(
          icon: showArchived ? Icons.archive : Icons.archive_outlined,
          onPressed: onToggleArchived,
          tooltip: showArchived ? 'Hide Archived' : 'Show Archived',
        ),
        CommonIconButton(
          icon: Icons.refresh,
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }
}
