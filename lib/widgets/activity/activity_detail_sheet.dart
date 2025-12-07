import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// A modal bottom sheet that displays detailed information about an activity entry
/// (drug use, craving, or reflection).
class ActivityDetailSheet extends StatelessWidget {
  final bool isDark;
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<DetailItem> details;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityDetailSheet({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.details,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(ThemeConstants.radiusLarge)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandleBar(),
            SizedBox(height: ThemeConstants.space20),
            _buildHeader(),
            SizedBox(height: ThemeConstants.space24),
            _buildDetailsList(),
            SizedBox(height: ThemeConstants.space24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: EdgeInsets.only(top: ThemeConstants.space12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ThemeConstants.space20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ThemeConstants.space12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(width: ThemeConstants.space16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: ThemeConstants.fontXLarge,
                fontWeight: ThemeConstants.fontBold,
                color: isDark ? UIColors.darkText : UIColors.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ThemeConstants.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: details.map((detail) {
          return Padding(
            padding: EdgeInsets.only(bottom: ThemeConstants.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.label,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSmall,
                    fontWeight: ThemeConstants.fontSemiBold,
                    color: isDark ? UIColors.darkTextSecondary : UIColors.lightTextSecondary,
                  ),
                ),
                SizedBox(height: ThemeConstants.space4),
                Container(
                  padding: detail.highlight ? EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space8,
                    vertical: ThemeConstants.space4,
                  ) : null,
                  decoration: detail.highlight ? BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                    border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                  ) : null,
                  child: Text(
                    detail.value,
                    style: TextStyle(
                      fontSize: ThemeConstants.fontMedium,
                      fontWeight: detail.highlight ? ThemeConstants.fontSemiBold : FontWeight.normal,
                      color: detail.highlight ? accentColor : (isDark ? UIColors.darkText : UIColors.lightText),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(ThemeConstants.space20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                ),
              ),
            ),
          ),
          SizedBox(width: ThemeConstants.space12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Entry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: ThemeConstants.space16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMedium),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A data class representing a single detail item in the activity detail sheet.
class DetailItem {
  final String label;
  final String value;
  final bool highlight;

  DetailItem({
    required this.label,
    required this.value,
    this.highlight = false,
  });
}
