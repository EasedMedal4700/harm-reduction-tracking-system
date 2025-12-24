// Recent Uses Card Widget
//
// Created: 2024-11-15
// Last Modified: 2025-12-14
//
// Purpose:
// Displays a list of the most recent substance use events with timestamps and dosages.
// Shows up to 5 recent entries in a clean, card-based format. Provides empty state
// when no use events are recorded.
//
// Features:
// - Displays recent use events with formatted timestamps
// - Shows dosage information for each entry
// - Empty state messaging when no data available
// - Fully theme-aware with modern design system
// - Responsive spacing and typography
// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: COMPLETE
// Notes: Fully migrated to use AppTheme, modern components, and Riverpod patterns.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../constants/theme/app_theme_extension.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../models/tolerance_model.dart';

/// Card widget that displays a list of recent substance use events
///
/// Shows up to 5 most recent entries with timestamps and dosage information.
/// Automatically handles empty states with appropriate messaging.
class RecentUsesCard extends ConsumerWidget {
  /// List of use log entries to display
  final List<UseLogEntry> useEvents;

  /// Optional substance name for contextual empty state message
  final String? substanceName;
  const RecentUsesCard({
    required this.useEvents,
    this.substanceName,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access theme components through context extensions
    final c = context.colors;
    final sp = context.spacing;
    final tx = context.text;
    final sh = context.shapes;
    // Date formatter for displaying timestamps
    final formatter = DateFormat('MMM d · HH:mm');
    // EMPTY STATE: Show message when no use events exist
    if (useEvents.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(sh.radiusMd),
          border: Border.all(color: c.border),
        ),
        padding: EdgeInsets.all(sp.lg),
        child: Text(
          substanceName != null
              ? 'No recent use events recorded for $substanceName.'
              : 'No recent use events recorded.',
          style: tx.bodySmall.copyWith(color: c.textSecondary),
        ),
      );
    }
    // Get the 5 most recent events
    final recentEvents = useEvents.take(5).toList();
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.border),
        boxShadow: context.cardShadow,
      ),
      padding: EdgeInsets.all(sp.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          // HEADER
          Text('Recent use events', style: tx.heading4),
          CommonSpacer.vertical(sp.md),
          // LIST OF EVENTS
          // Map each event to a row showing timestamp and dosage
          ...recentEvents.map(
            (event) => Padding(
              padding: EdgeInsets.symmetric(vertical: sp.xs),
              child: Row(
                mainAxisAlignment: AppLayout.mainAxisAlignmentSpaceBetween,
                children: [
                  // Timestamp (e.g., "Dec 14 · 21:30")
                  Text(formatter.format(event.timestamp), style: tx.body),
                  // Dosage amount
                  Text(
                    '${event.doseUnits.toStringAsFixed(1)} units',
                    style: tx.bodySmall.copyWith(color: c.textSecondary),
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
