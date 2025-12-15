// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Migrated to AppThemeExtension and existing common components. No logic or state changes.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    
    return SliverAppBar(
      title: const Text('Personal Library'),
      backgroundColor: t.colors.surface,
      pinned: true,
      floating: false,
      actions: [
        IconButton(
          icon: Icon(showArchived ? Icons.archive : Icons.archive_outlined),
          onPressed: onToggleArchived,
          tooltip: showArchived ? 'Hide Archived' : 'Show Archived',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
      ],
    );
  }
}
