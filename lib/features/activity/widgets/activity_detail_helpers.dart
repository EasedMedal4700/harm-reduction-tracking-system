// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Helper methods to show detail sheets. Fully theme-compliant.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/features/activity/models/activity_models.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import 'activity_detail_sheet.dart';
import 'activity_delete_dialog.dart';
import 'activity_helpers.dart';

typedef ActivityOnDelete =
    void Function({required String entryId, required ActivityItemType type});

/// Helper methods to show detail sheets for different activity types.
class ActivityDetailHelpers {
  /// Shows a detail sheet for a drug use entry.
  static void showDrugUseDetail({
    required BuildContext context,
    required ActivityDrugUseEntry entry,
    required ActivityOnDelete onDelete,
    required VoidCallback onUpdate,
  }) {
    final th = context.theme;
    final rootContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: th.colors.transparent,
      builder: (context) => ActivityDetailSheet(
        title: entry.name,
        icon: Icons.medication,
        accentColor: th.accent.primary,
        details: [
          DetailItem(label: 'Dose', value: entry.dose),
          DetailItem(
            label: 'Route',
            value: entry.raw['consumption']?.toString() ?? 'Not specified',
          ),
          DetailItem(label: 'Location', value: entry.place),
          DetailItem(
            label: 'Time',
            value: ActivityHelpers.formatDetailTimestamp(entry.time),
          ),
          if (entry.notes != null && entry.notes!.isNotEmpty)
            DetailItem(label: 'Notes', value: entry.notes!),
          if (entry.isMedicalPurpose)
            DetailItem(label: 'Purpose', value: 'Medical', highlight: true),
        ],
        onEdit: () {
          context.pop();
          rootContext
              .push(
                AppRoutePaths.editDrugUse,
                extra: Map<String, dynamic>.from(entry.raw),
              )
              .then((_) => onUpdate());
        },
        onDelete: () async {
          final confirmed = await ActivityDeleteDialog.show(
            rootContext,
            ActivityItemType.drugUse.displayName,
          );
          if (!confirmed) return;
          if (context.mounted) context.pop();
          onDelete(entryId: entry.id, type: ActivityItemType.drugUse);
        },
      ),
    );
  }

  /// Shows a detail sheet for a craving entry.
  static void showCravingDetail({
    required BuildContext context,
    required ActivityCravingEntry craving,
    required ActivityOnDelete onDelete,
    required VoidCallback onUpdate,
  }) {
    final intensity = craving.intensity.round();
    final rootContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.transparent,
      builder: (context) {
        return ActivityDetailSheet(
          title: craving.substance,
          icon: Icons.favorite,
          accentColor: ActivityHelpers.getCravingColor(intensity, context),
          details: [
            DetailItem(
              label: 'Intensity',
              value:
                  '${ActivityHelpers.getIntensityLabel(intensity)} (Level $intensity)',
            ),
            DetailItem(
              label: 'Trigger',
              value: craving.trigger ?? 'No trigger noted',
            ),
            DetailItem(
              label: 'Time',
              value: ActivityHelpers.formatDetailTimestamp(craving.time),
            ),
            if (craving.notes != null && craving.notes!.isNotEmpty)
              DetailItem(label: 'Notes', value: craving.notes!),
          ],
          onEdit: () {
            context.pop();
            rootContext
                .push(
                  AppRoutePaths.editCraving,
                  extra: Map<String, dynamic>.from(craving.raw),
                )
                .then((_) => onUpdate());
          },
          onDelete: () async {
            final confirmed = await ActivityDeleteDialog.show(
              rootContext,
              ActivityItemType.craving.displayName,
            );
            if (!confirmed) return;
            if (context.mounted) context.pop();
            onDelete(entryId: craving.id, type: ActivityItemType.craving);
          },
        );
      },
    );
  }

  /// Shows a detail sheet for a reflection entry.
  static void showReflectionDetail({
    required BuildContext context,
    required ActivityReflectionEntry reflection,
    required ActivityOnDelete onDelete,
    required VoidCallback onUpdate,
  }) {
    final ac = context.accent;
    final rootContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.transparent,
      builder: (context) => ActivityDetailSheet(
        title: 'Reflection Entry',
        icon: Icons.notes,
        accentColor: ac.secondary,
        details: [
          DetailItem(
            label: 'Time',
            value: ActivityHelpers.formatDetailTimestamp(reflection.createdAt),
          ),
          if (reflection.notes != null && reflection.notes!.isNotEmpty)
            DetailItem(label: 'Notes', value: reflection.notes!),
        ],
        onEdit: () {
          context.pop();
          rootContext
              .push(
                AppRoutePaths.editReflection,
                extra: Map<String, dynamic>.from(reflection.raw),
              )
              .then((_) => onUpdate());
        },
        onDelete: () async {
          final confirmed = await ActivityDeleteDialog.show(
            rootContext,
            ActivityItemType.reflection.displayName,
          );
          if (!confirmed) return;
          if (context.mounted) context.pop();
          onDelete(entryId: reflection.id, type: ActivityItemType.reflection);
        },
      ),
    );
  }
}
