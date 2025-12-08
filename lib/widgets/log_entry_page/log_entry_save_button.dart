import 'package:flutter/material.dart';
import '../../common/buttons/common_primary_button.dart';
import '../../constants/deprecated/theme_constants.dart';
import '../../constants/deprecated/ui_colors.dart';

class LogEntrySaveButton extends StatelessWidget {
  final VoidCallback onSave;

  const LogEntrySaveButton({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space16),
      decoration: BoxDecoration(
        color: isDark ? UIColors.darkSurface : UIColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CommonPrimaryButton(
        label: "Save Entry",
        icon: Icons.save,
        onPressed: onSave,
        width: double.infinity,
      ),
    );
  }
}
