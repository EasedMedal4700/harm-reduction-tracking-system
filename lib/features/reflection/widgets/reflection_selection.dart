// MIGRATION // Theme: [Migrated] // Common: [Migrated] // Riverpod: TODO
// Notes: No hardcoded values.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../common/layout/common_spacer.dart';
import '../../../constants/theme/app_theme_extension.dart';

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
    final th = context.theme;
    return SingleChildScrollView(
      padding: EdgeInsets.all(th.spacing.lg),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        children: [
          Text('Select entries to reflect on', style: th.typography.heading2),
          CommonSpacer.vertical(th.spacing.sm),
          Text(
            'Choose one or more recent logs to associate with this reflection.',
            style: th.typography.body.copyWith(color: th.colors.textSecondary),
          ),
          CommonSpacer.vertical(th.spacing.xl),
          if (entries.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(th.spacing.xl3),
                child: Text(
                  'No recent entries found.',
                  style: th.typography.body.copyWith(
                    color: th.colors.textSecondary,
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
                  CommonSpacer.vertical(th.spacing.md),
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
          CommonSpacer.vertical(th.spacing.xl3),
          SizedBox(
            width: double.infinity,
            height: context.sizes.buttonHeightLg,
            child: ElevatedButton(
              onPressed: selectedIds.isNotEmpty ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: th.accent.primary,
                foregroundColor: th.colors.textInverse,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(th.shapes.radiusLg),
                ),
                elevation: context.sizes.elevationNone,
                disabledBackgroundColor: th.colors.surface,
              ),
              child: Text('Next Step', style: th.typography.button),
            ),
          ),
          CommonSpacer.vertical(th.spacing.xl3),
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
    final th = context.theme;

    final borderColor = isSelected ? th.accent.primary : th.colors.border;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(th.shapes.radiusMd),
      child: Container(
        padding: EdgeInsets.all(th.spacing.lg),
        decoration: BoxDecoration(
          color: th.colors.surface,
          borderRadius: BorderRadius.circular(th.shapes.radiusMd),
          border: Border.all(
            color: borderColor,
            width: isSelected ? th.borders.medium : th.borders.thin,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: th.accent.primary.withValues(alpha: 0.2),
                    blurRadius: th.sizes.cardElevationHovered,
                    offset: Offset(0, th.spacing.xs),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: th.sizes.iconMd,
              height: th.sizes.iconMd,
              decoration: BoxDecoration(
                shape: context.shapes.boxShapeCircle,
                color: isSelected
                    ? th.accent.primary
                    : context.colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? th.accent.primary
                      : th.colors.textSecondary,
                  width: th.borders.medium,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: context.sizes.iconSm,
                      color: th.colors.textInverse,
                    )
                  : null,
            ),
            CommonSpacer.horizontal(th.spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
                children: [
                  Text('$substance • $dose', style: th.typography.bodyBold),
                  CommonSpacer.vertical(th.spacing.xs),
                  Text(
                    '${_formatTime(time)} • $place',
                    style: th.typography.bodySmall.copyWith(
                      color: th.colors.textSecondary,
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
