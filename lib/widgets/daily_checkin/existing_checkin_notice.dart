import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: TODO
// Common: TODO
// Riverpod: TODO
// Notes: Needs migration to AppTheme/context extensions and new constants. Remove deprecated theme usage.
import 'package:flutter/material.dart';



class ExistingCheckinNotice extends StatelessWidget {
  const ExistingCheckinNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(
          ThemeConstants.radiusMedium,
        ),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Check-in already exists for this time.',
              style: TextStyle(
                color: Colors.red[300],
                fontWeight: FontWeight.bold,
                fontSize: ThemeConstants.fontSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


