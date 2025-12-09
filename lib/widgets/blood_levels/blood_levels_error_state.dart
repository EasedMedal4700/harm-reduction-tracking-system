// MIGRATION
import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

/// Error state for blood levels with retry option
class BloodLevelsErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const BloodLevelsErrorState({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final sp = context.spacing;
    final text = context.text;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 64, color: c.error),
          SizedBox(height: sp.lg),
          Text(error, style: text.body),
          SizedBox(height: sp.lg),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: c.error,
              foregroundColor: c.textInverse,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
