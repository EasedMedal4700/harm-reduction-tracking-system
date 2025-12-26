// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: COMPLETE
// Common: COMPLETE
// Notes: Extension for DoseTier theme colors.
import 'package:flutter/material.dart';

import '../../../constants/theme/app_theme_extension.dart';
import '../services/pharmacokinetics_service.dart';

extension DoseTierThemeColorX on DoseTier {
  Color themeColor(BuildContext context) {
    final c = context.colors;

    switch (this) {
      case DoseTier.threshold:
        return c.info;
      case DoseTier.light:
        return c.success;
      case DoseTier.common:
        return context.accent.primary;
      case DoseTier.strong:
        return c.warning;
      case DoseTier.heavy:
        return c.error;
    }
  }
}
