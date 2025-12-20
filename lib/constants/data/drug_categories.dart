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
}

/// Shared color palette for drug categories across the app.
class DrugCategoryColors {
  DrugCategoryColors._();

  // Individual category colors
  static const Color psychedelic = Color(0xFF9C6BFF); // purple
  static const Color deliriant = Color(0xFFC67EFF); // violet
  static const Color dissociative = Color(0xFF00BFFF);
  static const Color empathogen = Color(0xFFFF5FB7); // pink
  static const Color opioid = Color(0xFFFF914D); // orange
  static const Color depressant = Color(0xFF1E90FF); // blue
  static const Color benzodiazepine = Color(0xFF6EB5FF); // light blue
  static const Color barbiturate = Color(0xFFFFD86E); // gold
  static const Color stimulant = Color(0xFF00E0FF); // cyan
  static const Color cathinone = Color(0xFF00C8FF); // bright cyan
  static const Color nootropic = Color(0xFF00C896); // teal
  static const Color ssri = Color(0xFF8C9EFF); // lavender
  static const Color supplement = Color(0xFFA7FF83); // mint
  static const Color experimental = Color(0xFFB8B8B8); // gray
  static const Color placeholder = Color(0xFF888888); // dark gray

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
