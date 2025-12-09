// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SliverAppBar(
      title: const Text('Personal Library'),
      backgroundColor: isDark ? UIColors.darkSurface : UIColors.lightSurface,
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
