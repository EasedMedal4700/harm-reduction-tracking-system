
// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? UIColors.darkText : UIColors.lightText;
    final secondaryTextColor = isDark
        ? UIColors.darkTextSecondary
        : UIColors.lightTextSecondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(ThemeConstants.homePagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select entries to reflect on',
            style: TextStyle(
              fontSize: ThemeConstants.fontLarge,
              fontWeight: ThemeConstants.fontBold,
              color: textColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space8),
          Text(
            'Choose one or more recent logs to associate with this reflection.',
            style: TextStyle(
              fontSize: ThemeConstants.fontMedium,
              color: secondaryTextColor,
            ),
          ),
          const SizedBox(height: ThemeConstants.space24),
          if (entries.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No recent entries found.',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: ThemeConstants.space12),
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
          const SizedBox(height: ThemeConstants.space32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: selectedIds.isNotEmpty ? onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? UIColors.darkNeonPurple
                    : UIColors.lightAccentPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.radiusLarge,
                  ),
                ),
                elevation: 0,
                disabledBackgroundColor: isDark
                    ? Colors.white10
                    : Colors.grey[300],
              ),
              child: const Text(
                'Next Step',
                style: TextStyle(
                  fontSize: ThemeConstants.fontMedium,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ),
          ),
          const SizedBox(height: ThemeConstants.space32),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? UIColors.darkSurface : Colors.white;
    final borderColor = isSelected
        ? (isDark ? UIColors.darkNeonPurple : UIColors.lightAccentPurple)
        : (isDark ? UIColors.darkBorder : UIColors.lightBorder);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.cardPaddingMedium),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow: isSelected && isDark
              ? [
                  BoxShadow(
                    color: UIColors.darkNeonPurple.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (isDark
                          ? UIColors.darkNeonPurple
                          : UIColors.lightAccentPurple)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? (isDark
                            ? UIColors.darkNeonPurple
                            : UIColors.lightAccentPurple)
                      : (isDark
                            ? UIColors.darkTextSecondary
                            : UIColors.lightTextSecondary),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$substance • $dose',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontMedium,
                      fontWeight: ThemeConstants.fontSemiBold,
                      color: isDark ? UIColors.darkText : UIColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatTime(time)} • $place',
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSmall,
                      color: isDark
                          ? UIColors.darkTextSecondary
                          : UIColors.lightTextSecondary,
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
