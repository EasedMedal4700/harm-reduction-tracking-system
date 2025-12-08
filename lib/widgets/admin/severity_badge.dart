// MIGRATION COMPLETE – Severity badge uses theme colors.
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
    final t = context.theme;
    final colors = _getSeverityColors(context, severity);
    final icon = _getSeverityIcon(severity);

    final padding = compact
        ? EdgeInsets.symmetric(
            horizontal: t.spacing.xs,
            vertical: t.spacing.xs * 0.7,
          )
        : EdgeInsets.symmetric(
            horizontal: t.spacing.md,
            vertical: t.spacing.sm,
          );

    final borderRadius =
        BorderRadius.circular(compact ? t.spacing.sm : t.spacing.md);

    final textStyle = (compact ? t.typography.caption : t.typography.bodySmall)
        .copyWith(
          color: colors.text,
          fontWeight: FontWeight.bold,
          letterSpacing: compact ? 0 : 0.5,
        );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: borderRadius,
        border: Border.all(
          color: colors.border,
          width: compact ? 1 : 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 12 : 16,
            color: colors.text,
          ),
          SizedBox(width: compact ? t.spacing.xs : t.spacing.sm),
          Text(severity.toUpperCase(), style: textStyle),
        ],
      ),
    );
  }

  // THEME-DRIVEN severity colors
  _SeverityColors _getSeverityColors(BuildContext context, String severity) {
    final t = context.theme;
    switch (severity.toLowerCase()) {
      case 'critical':
        return _SeverityColors(
          background: t.colors.error.withOpacity(0.12),
          border: t.colors.error.withOpacity(0.6),
          text: t.colors.error,
        );
      case 'high':
        return _SeverityColors(
          background: t.colors.warning.withOpacity(0.12),
          border: t.colors.warning.withOpacity(0.6),
          text: t.colors.warning,
        );
      case 'medium':
        return _SeverityColors(
          background: t.colors.info.withOpacity(0.12),
          border: t.colors.info.withOpacity(0.6),
          text: t.colors.info,
        );
      case 'low':
        return _SeverityColors(
          background: t.colors.success.withOpacity(0.12),
          border: t.colors.success.withOpacity(0.6),
          text: t.colors.success,
        );
      default:
        return _SeverityColors(
          background: t.colors.surfaceVariant,
          border: t.colors.border,
          text: t.colors.textSecondary,
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
