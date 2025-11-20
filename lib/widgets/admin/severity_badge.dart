import 'package:flutter/material.dart';

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
    final colors = _getSeverityColors(severity);
    final icon = _getSeverityIcon(severity);
    
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: colors.text),
            const SizedBox(width: 4),
            Text(
              severity.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.text,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.text),
          const SizedBox(width: 8),
          Text(
            severity.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.text,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  _SeverityColors _getSeverityColors(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return _SeverityColors(
          background: const Color(0xFFFFEBEE),
          border: const Color(0xFFD32F2F),
          text: const Color(0xFFB71C1C),
        );
      case 'high':
        return _SeverityColors(
          background: const Color(0xFFFFF3E0),
          border: const Color(0xFFF57C00),
          text: const Color(0xFFE65100),
        );
      case 'medium':
        return _SeverityColors(
          background: const Color(0xFFFFFDE7),
          border: const Color(0xFFFBC02D),
          text: const Color(0xFFF57F17),
        );
      case 'low':
        return _SeverityColors(
          background: const Color(0xFFE3F2FD),
          border: const Color(0xFF1976D2),
          text: const Color(0xFF0D47A1),
        );
      default:
        return _SeverityColors(
          background: const Color(0xFFF5F5F5),
          border: const Color(0xFF9E9E9E),
          text: const Color(0xFF616161),
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
