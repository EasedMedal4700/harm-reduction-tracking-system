import 'package:flutter/material.dart'; // Add this import for Icons

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
    "Experimental",
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