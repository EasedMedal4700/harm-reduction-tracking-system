import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Section header with title and optional subtitle
/// Used for card titles like "Substance", "Dosage", "How are you feeling?"
class CommonSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final double? subtitleFontSize;
  final EdgeInsetsGeometry? padding;

  const CommonSectionHeader({
    required this.title,
    this.subtitle,
    this.titleFontSize,
    this.titleFontWeight,
    this.subtitleFontSize,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: titleFontSize ?? ThemeConstants.fontXLarge,
              fontWeight: titleFontWeight ?? ThemeConstants.fontSemiBold,
              color: isDark ? UIColors.darkText : UIColors.lightText,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: ThemeConstants.space8),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: subtitleFontSize ?? ThemeConstants.fontSmall,
                color: isDark 
                    ? UIColors.darkTextSecondary 
                    : UIColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
