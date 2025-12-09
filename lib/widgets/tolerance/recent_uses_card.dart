//MIGRTAED FILE

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/theme/app_theme_extension.dart';
import '../../models/tolerance_model.dart';

  
/// Card displaying a list of recent substance use events
class RecentUsesCard extends StatelessWidget {
  final List<UseLogEntry> useEvents;
  final String? substanceName;

  const RecentUsesCard({
    required this.useEvents,
    this.substanceName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;          // typography, spacing, shapes
    final c = context.colors;         // color palette
    final formatter = DateFormat('MMM d · HH:mm');

    if (useEvents.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          border: Border.all(color: c.border),
        ),
        padding: EdgeInsets.all(t.spacing.lg),
        child: Text(
          substanceName != null
              ? 'No recent use events recorded for $substanceName.'
              : 'No recent use events recorded.',
          style: t.typography.bodySmall.copyWith(
            color: c.textSecondary,
          ),
        ),
      );
    }

    final recentEvents = useEvents.take(5).toList();

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(t.shapes.radiusMd),
        border: Border.all(color: c.border),
        boxShadow: context.theme.cardShadow,
      ),
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent use events',
            style: t.typography.heading4,
          ),
          SizedBox(height: t.spacing.md),

          ...recentEvents.map(
            (event) => Padding(
              padding: EdgeInsets.symmetric(vertical: t.spacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatter.format(event.timestamp),
                    style: t.typography.body,
                  ),
                  Text(
                    '${event.doseUnits.toStringAsFixed(1)} units',
                    style: t.typography.bodySmall.copyWith(
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
