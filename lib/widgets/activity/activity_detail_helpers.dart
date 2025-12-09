
// MIGRATION
// Theme: COMPLETE
// Common: PARTIAL
// Riverpod: TODO
// Notes: Fully theme-based. Some common component extraction possible. No Riverpod.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

import 'activity_detail_sheet.dart';
import 'activity_helpers.dart';
import '../../screens/edit/edit_log_entry_page.dart';
import '../../screens/edit/edit_craving_page.dart';
import '../../screens/edit/edit_refelction_page.dart';

/// Helper methods to show detail sheets for different activity types.
class ActivityDetailHelpers {
  /// Shows a detail sheet for a drug use entry.
  static void showDrugUseDetail({
    required BuildContext context,
    required Map<String, dynamic> entry,
    required Function(String, String, String) onDelete,
    required VoidCallback onUpdate,
  }) {
    final t = context.theme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityDetailSheet(
        title: entry['name'] ?? 'Unknown Substance',
        icon: Icons.medication,
        accentColor: t.accent.primary,
        details: [
          DetailItem(label: 'Dose', value: entry['dose'] ?? 'Unknown'),
          DetailItem(label: 'Route', value: entry['consumption'] ?? 'Not specified'),
          DetailItem(label: 'Location', value: entry['place'] ?? 'Not specified'),
          DetailItem(
            label: 'Time',
            value: ActivityHelpers.formatDetailTimestamp(
              entry['start_time'] ?? entry['time'],
            ),
          ),
          if (entry['notes'] != null && entry['notes'].toString().isNotEmpty)
            DetailItem(label: 'Notes', value: entry['notes']),
          if (entry['is_medical_purpose'] == true)
            DetailItem(label: 'Purpose', value: 'Medical', highlight: true),
        ],
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditDrugUsePage(entry: entry),
            ),
          ).then((_) => onUpdate());
        },
        onDelete: () => onDelete(
          entry['use_id']?.toString() ?? entry['id']?.toString() ?? '',
          'drug use',
          'drug_use',
        ),
      ),
    );
  }

  /// Shows a detail sheet for a craving entry.
  static void showCravingDetail({
    required BuildContext context,
    required Map<String, dynamic> craving,
    required Function(String, String, String) onDelete,
    required VoidCallback onUpdate,
  }) {
    final intensity = craving['intensity'] ?? 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final t = context.theme;

        return ActivityDetailSheet(
          title: craving['substance'] ?? 'Unknown Substance',
          icon: Icons.favorite,
          accentColor: ActivityHelpers.getCravingColor(intensity, context),
          details: [
            DetailItem(
              label: 'Intensity',
              value: '${ActivityHelpers.getIntensityLabel(intensity)} (Level $intensity)',
            ),
            DetailItem(
              label: 'Trigger',
              value: craving['trigger'] ?? 'No trigger noted',
            ),
            DetailItem(
              label: 'Time',
              value: ActivityHelpers.formatDetailTimestamp(
                craving['time'] ?? craving['created_at'],
              ),
            ),
            if (craving['notes'] != null && craving['notes'].toString().isNotEmpty)
              DetailItem(label: 'Notes', value: craving['notes']),
          ],
          onEdit: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditCravingPage(entry: craving),
              ),
            ).then((_) => onUpdate());
          },
          onDelete: () => onDelete(
            craving['craving_id']?.toString() ?? craving['id']?.toString() ?? '',
            'craving',
            'cravings',
          ),
        );
      },
    );
  }

  /// Shows a detail sheet for a reflection entry.
  static void showReflectionDetail({
    required BuildContext context,
    required Map<String, dynamic> reflection,
    required Function(String, String, String) onDelete,
    required VoidCallback onUpdate,
  }) {
    final t = context.theme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ActivityDetailSheet(
        title: 'Reflection Entry',
        icon: Icons.notes,
        accentColor: t.accent.secondary,
        details: [
          DetailItem(
            label: 'Time',
            value: ActivityHelpers.formatDetailTimestamp(
              reflection['created_at'] ?? reflection['time'],
            ),
          ),
          if (reflection['notes'] != null && reflection['notes'].toString().isNotEmpty)
            DetailItem(label: 'Notes', value: reflection['notes']),
        ],
        onEdit: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditReflectionPage(entry: reflection),
            ),
          ).then((_) => onUpdate());
        },
        onDelete: () => onDelete(
          reflection['reflection_id']?.toString() ??
              reflection['id']?.toString() ??
              '',
          'reflection',
          'reflections',
        ),
      ),
    );
  }
}
