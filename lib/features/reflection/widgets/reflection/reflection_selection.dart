// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
// Notes: No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/theme/app_layout.dart';
import '../../../../common/layout/common_spacer.dart';
import '../../../../constants/theme/app_theme_extension.dart';

class ReflectionSelection extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  final Set<String> selectedIds;
  final Function(String id, bool selected) onEntryChanged; // Change to function
  final VoidCallback onNext;

  const ReflectionSelection({
    super.key,
    required this.entries,
    required this.selectedIds,
    required this.onEntryChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.theme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(t.spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Select entries to reflect on', style: t.typography.heading2),
          CommonSpacer.vertical(t.spacing.sm),
          Text(
            'Choose one or more recent logs to associate with this reflection.',
            style: t.typography.body.copyWith(color: t.colors.textSecondary),
          ),
          CommonSpacer.vertical(t.spacing.xl),
          if (entries.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(t.spacing.xl3),
                child: Text(
                  'No recent entries found.',
                  style: t.typography.body.copyWith(
                    color: t.colors.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) =>
                  CommonSpacer.vertical(t.spacing.md),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final id = entry['use_id']?.toString() ?? '';
                final isSelected = selectedIds.contains(id);
                final substance = entry['name'] ?? 'Unknown';
                final dose = entry['dose'] ?? '';
                final time = DateTime.parse(entry['start_time']).toLocal();
                final place = entry['place'] ?? 'Unknown';

                return _buildEntryCard(
                  context,
                  isSelected,
                  substance,
                  dose,
                  time,
                  place,
                  () => onEntryChanged(id, !isSelected),
                );
              },
            ),
          CommonSpacer.vertical(t.spacing.xl3),
          SizedBox(
            width: double.infinity,
            height: context.sizes.buttonHeightLg,
            child: ElevatedButton(
              onPressed: selectedIds.isNotEmpty ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.accent.primary,
                foregroundColor: t.colors.textInverse,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.shapes.radiusLg),
                ),
                elevation: context.sizes.elevationNone,
                disabledBackgroundColor: t.colors.surface,
              ),
              child: Text('Next Step', style: t.typography.button),
            ),
          ),
          CommonSpacer.vertical(t.spacing.xl3),
        ],
      ),
    );
  }

  Widget _buildEntryCard(
    BuildContext context,
    bool isSelected,
    String substance,
    String dose,
    DateTime time,
    String place,
    VoidCallback onTap,
  ) {
    final t = context.theme;
    final borderColor = isSelected ? t.accent.primary : t.colors.border;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(t.shapes.radiusMd),
      child: Container(
        padding: EdgeInsets.all(t.spacing.lg),
        decoration: BoxDecoration(
          color: t.colors.surface,
          borderRadius: BorderRadius.circular(t.shapes.radiusMd),
          border: Border.all(
            color: borderColor,
            width: isSelected ? t.borders.medium : t.borders.thin,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: t.accent.primary.withValues(alpha: 0.2),
                    blurRadius: t.sizes.cardElevationHovered,
                    offset: Offset(0, t.spacing.xs),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: t.sizes.iconMd,
              height: t.sizes.iconMd,
              decoration: BoxDecoration(
                shape: context.shapes.boxShapeCircle,
                color: isSelected
                    ? t.accent.primary
                    : context.colors.transparent,
                border: Border.all(
                  color: isSelected ? t.accent.primary : t.colors.textSecondary,
                  width: t.borders.medium,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: context.sizes.iconSm,
                      color: t.colors.textInverse,
                    )
                  : null,
            ),
            CommonSpacer.horizontal(t.spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  Text('$substance • $dose', style: t.typography.bodyBold),
                  CommonSpacer.vertical(t.spacing.xs),
                  Text(
                    '${_formatTime(time)} • $place',
                    style: t.typography.bodySmall.copyWith(
                      color: t.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
