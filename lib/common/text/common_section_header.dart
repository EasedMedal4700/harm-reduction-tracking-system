import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Deprecated theme references removed. Fully aligned with AppThemeExtension.

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
    final t = context.theme;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: t.text.heading3.copyWith(
              fontSize: titleFontSize,
              fontWeight: titleFontWeight,
              color: t.colors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: t.spacing.sm),
            Text(
              subtitle!,
              style: t.text.bodySmall.copyWith(
                fontSize: subtitleFontSize,
                color: t.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
