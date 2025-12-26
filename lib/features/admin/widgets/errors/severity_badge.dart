// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Fully theme-compliant Severity Badge.
import 'package:flutter/material.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import '../../../../constants/theme/app_theme_extension.dart';

/// Severity badge for error logs
class SeverityBadge extends StatelessWidget {
  final String severity;
  final bool compact;
  const SeverityBadge({
    required this.severity,
    this.compact = false,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final tx = context.text;
    final sp = context.spacing;
    final sh = context.shapes;
    final colors = _getSeverityColors(context, severity);
    final icon = _getSeverityIcon(severity);
    final padding = compact
        ? EdgeInsets.symmetric(horizontal: sp.xs, vertical: sp.xs)
        : EdgeInsets.symmetric(horizontal: sp.md, vertical: sp.sm);
    final borderRadius = BorderRadius.circular(
      compact ? sh.radiusSm : sh.radiusMd,
    );
    final textStyle = (compact ? tx.caption : tx.bodySmall).copyWith(
      color: colors.text,
      fontWeight: tx.bodyBold.fontWeight,
      letterSpacing: compact ? 0 : context.sizes.letterSpacingSm,
    );
    final iconSize =
        (compact ? tx.caption.fontSize : tx.bodySmall.fontSize) ??
        context.sizes.iconSm;
    final borderWidth = compact ? context.borders.thin : context.borders.medium;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: borderRadius,
        border: Border.all(color: colors.border, width: borderWidth),
      ),
      child: Row(
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Icon(icon, size: iconSize, color: colors.text),
          SizedBox(width: compact ? sp.xs : sp.sm),
          Text(severity.toUpperCase(), style: textStyle),
        ],
      ),
    );
  }

  /// THEME-DRIVEN severity colors
  _SeverityColors _getSeverityColors(BuildContext context, String severity) {
    final c = context.colors;
    switch (severity.toLowerCase()) {
      case 'critical':
        return _SeverityColors(
          background: c.error.withValues(alpha: context.opacities.veryLow),
          border: c.error.withValues(alpha: context.opacities.high),
          text: c.error,
        );
      case 'high':
        return _SeverityColors(
          background: c.warning.withValues(alpha: context.opacities.veryLow),
          border: c.warning.withValues(alpha: context.opacities.high),
          text: c.warning,
        );
      case 'medium':
        return _SeverityColors(
          background: c.info.withValues(alpha: context.opacities.veryLow),
          border: c.info.withValues(alpha: context.opacities.high),
          text: c.info,
        );
      case 'low':
        return _SeverityColors(
          background: c.success.withValues(alpha: context.opacities.veryLow),
          border: c.success.withValues(alpha: context.opacities.high),
          text: c.success,
        );
      default:
        return _SeverityColors(
          background: c.surfaceVariant,
          border: c.border,
          text: c.textSecondary,
        );
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Icons.error;
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.info;
      case 'low':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }
}

class _SeverityColors {
  final Color background;
  final Color border;
  final Color text;
  const _SeverityColors({
    required this.background,
    required this.border,
    required this.text,
  });
}
