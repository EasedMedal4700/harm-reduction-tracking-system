// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Tab for displaying cravings. Uses ActivityCard and ActivityEmptyState.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import '../models/activity_models.dart';
import 'activity_card.dart';
import 'activity_empty_state.dart';

class ActivityCravingsTab extends StatelessWidget {
  final List<ActivityCravingEntry> cravings;
  final void Function(ActivityCravingEntry) onCravingTap;
  final Future<void> Function() onRefresh;
  const ActivityCravingsTab({
    super.key,
    required this.cravings,
    required this.onCravingTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final th = context.theme;
    final sp = context.spacing;
    if (cravings.isEmpty) {
      return const ActivityEmptyState(
        icon: Icons.favorite_border,
        title: 'No Cravings Logged',
        subtitle: 'Your craving records will appear here',
      );
    }
    return RefreshIndicator(
      color: th.accent.primary,
      backgroundColor: th.colors.surface,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(sp.lg),
        itemCount: cravings.length,
        itemBuilder: (context, index) {
          final craving = cravings[index];
          final intensity = craving.intensity;
          return ActivityCard(
            title: craving.substance,
            subtitle:
                'Intensity: ${intensity.toStringAsFixed(1)}/10 • ${craving.location}',
            timestamp: craving.time,
            icon: Icons.favorite,
            accentColor: _getIntensityColor(context, intensity),
            badge: craving.action == 'Resisted' ? 'Resisted' : null,
            onTap: () => onCravingTap(craving),
          );
        },
      ),
    );
  }

  /// Intensity → theme-aware accent colors
  Color _getIntensityColor(BuildContext context, double intensity) {
    final c = context.colors;
    if (intensity >= 8) return c.error;
    if (intensity >= 5) return c.warning;
    return c.info;
  }
}
