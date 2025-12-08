import 'package:flutter/material.dart';
import '../../constants/colors/app_colors_dark.dart';
import '../../constants/colors/app_colors_light.dart';

/// Riverpod-ready Save Button
/// Accepts callback instead of state
class SaveButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onSave;

  const SaveButton({
    super.key,
    required this.isDark,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColorsLight.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColorsDark.border : AppColorsLight.border,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? AppColorsDark.accentBlue
              : AppColorsLight.accentPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save),
            SizedBox(width: 8.0),
            Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

