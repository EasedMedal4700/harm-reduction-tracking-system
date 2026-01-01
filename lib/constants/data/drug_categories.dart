// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Data catalog.
import 'package:flutter/material.dart';

class DrugCategories {
  // Category priority list (higher priority first)
  static const List<String> categoryPriority = [
    "Supplement",
    "Psychedelic",
    "Deliriant",
    "Dissociative",
    "Empathogen",
    "Opioid",
    "Benzodiazepine",
    "Barbiturate",
    "Stimulant",
    "Cathinone",
    "Depressant",
    "Nootropic",
    "SSRI",
  ];
  // Category icon map (Material Icons)
  static const Map<String, IconData> categoryIconMap = {
    "Psychedelic": Icons.blur_on,
    "Deliriant": Icons.visibility_off,
    "Dissociative": Icons.cloud,
    "Empathogen": Icons.favorite,
    "Opioid": Icons.healing,
    "Depressant": Icons.nightlight_round,
    "Benzodiazepine": Icons.bedtime,
    "Barbiturate": Icons.water_drop,
    "Stimulant": Icons.flash_on,
    "Cathinone": Icons.bolt,
    "Nootropic": Icons.psychology,
    "SSRI": Icons.mood,
    "Supplement": Icons.eco,
    "Experimental": Icons.science,
    "Placeholder": Icons.help_outline,
  };

  static const Set<String> _ignoredCategoryTokens = {
    'tentative',
    'research chemical',
    'habit-forming',
    'common',
    'inactive',
    'unknown',
  };

  /// Picks a primary, known category key suitable for [categoryIconMap]
  /// and [DrugCategoryColors.colorFor].
  ///
  /// Handles multi-category strings like "Stimulant, Cathinone".
  /// Returns "Placeholder" when missing/empty and "Experimental" when
  /// the value doesn't map to a known category.
  static String primaryCategoryFromRaw(String? rawCategory) {
    final raw = rawCategory?.trim();
    if (raw == null || raw.isEmpty) return 'Placeholder';

    final parts = raw
        .split(RegExp(r'[,/;|]+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return 'Placeholder';

    final filtered = parts
        .where((p) => !_ignoredCategoryTokens.contains(p.toLowerCase()))
        .toList(growable: false);
    final candidates = filtered.isEmpty ? parts : filtered;

    for (final priority in categoryPriority) {
      if (candidates.any((c) => c.toLowerCase() == priority.toLowerCase())) {
        return priority;
      }
    }

    final first = candidates.first;
    final firstLower = first.toLowerCase();
    for (final key in categoryIconMap.keys) {
      if (key.toLowerCase() == firstLower) return key;
    }
    if (DrugCategoryColors.map.containsKey(firstLower)) {
      return first;
    }
    return 'Experimental';
  }
}

/// Shared color palette for drug categories across the app.
/// Shared color palette for drug categories across the app.
/// Balanced: readable, calm, modern — not neon, not muddy.
class DrugCategoryColors {
  DrugCategoryColors._();

  // Keep these values stable: tests and UI rely on specific hex colors.
  static const Color psychedelic = Color(0xFF9C6BFF);
  static const Color deliriant = Color(0xFFC67EFF);
  static const Color dissociative = Color(0xFF00BFFF);
  static const Color empathogen = Color(0xFFFF5FB7);
  static const Color opioid = Color(0xFFFF914D);
  static const Color depressant = Color(0xFF1E90FF);
  static const Color benzodiazepine = Color(0xFF6EB5FF);
  static const Color barbiturate = Color(0xFFFFD86E);
  static const Color stimulant = Color(0xFF00E0FF);
  static const Color cathinone = Color(0xFF00C8FF);
  static const Color nootropic = Color(0xFF00C896);
  static const Color ssri = Color(0xFF8C9EFF);
  static const Color supplement = Color(0xFFA7FF83);
  static const Color experimental = Color(0xFF9CA3AF); // neutral gray
  static const Color placeholder = Color(0xFF9CA3AF);

  static const Color defaultColor = stimulant;

  static const Map<String, Color> _colorByCategory = {
    'psychedelic': psychedelic,
    'deliriant': deliriant,
    'dissociative': dissociative,
    'empathogen': empathogen,
    'opioid': opioid,
    'depressant': depressant,
    'benzodiazepine': benzodiazepine,
    'barbiturate': barbiturate,
    'stimulant': stimulant,
    'cathinone': cathinone,
    'nootropic': nootropic,
    'ssri': ssri,
    'supplement': supplement,
    'cannabinoid': supplement,
    'experimental': experimental,
    'placeholder': placeholder,
  };

  /// Returns the shared color for a drug [category].
  static Color colorFor(String? category) {
    if (category == null) return defaultColor;
    final normalized = category.trim().toLowerCase();
    return _colorByCategory[normalized] ?? defaultColor;
  }

  /// Exposes the immutable map of category colors (keys are lowercase).
  static Map<String, Color> get map => _colorByCategory;
}
