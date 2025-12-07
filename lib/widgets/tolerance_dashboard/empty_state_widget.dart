import 'package:flutter/material.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isDark;

  const EmptyStateWidget({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: ThemeConstants.space16,
      ),
      child: Text(
        'Log entries with substance names to see tolerance insights.',
        style: TextStyle(
          color: isDark
              ? UIColors.darkTextSecondary
              : UIColors.lightTextSecondary,
        ),
      ),
    );
  }
}
