/// Centralized bucket type definitions and metadata
/// CRITICAL: This file defines the CANONICAL bucket order and display information.
/// All buckets rendered in the UI MUST use this order.
class BucketDefinitions {
  /// Canonical bucket order for display
  /// If a bucket doesn't exist in a substance, show it as "Recovered 0.0%"
  static const List<String> orderedBuckets = [
    'gaba',
    'stimulant',
    'serotonin_release',
    'serotonin_psychedelic',
    'opioid',
    'nmda',
    'cannabinoid',
  ];

  /// Get display name for bucket type
  static String getDisplayName(String bucketType) {
    switch (bucketType.toLowerCase()) {
      case 'gaba':
        return 'GABA';
      case 'stimulant':
        return 'Stimulant';
      case 'serotonin_release':
        return 'Serotonin Release';
      case 'serotonin_psychedelic':
        return 'Serotonin Psychedelic';
      case 'serotonin': // Legacy compatibility
        return 'Serotonin';
      case 'opioid':
        return 'Opioid';
      case 'nmda':
        return 'NMDA';
      case 'cannabinoid':
        return 'Cannabinoid';
      default:
        return bucketType.toUpperCase();
    }
  }

  /// Get description for bucket type
  static String getDescription(String bucketType) {
    switch (bucketType.toLowerCase()) {
      case 'gaba':
        return 'GABA-A receptor agonists (depressants, anxiolytics, sedatives)';
      case 'stimulant':
        return 'Dopamine/Norepinephrine reuptake inhibitors and releasers';
      case 'serotonin_release':
        return 'Serotonin releasing agents (MDMA-like compounds)';
      case 'serotonin_psychedelic':
        return '5-HT2A receptor agonists (classic psychedelics)';
      case 'serotonin':
        return 'Serotonergic compounds';
      case 'opioid':
        return 'μ-opioid receptor agonists (pain relief, euphoria)';
      case 'nmda':
        return 'NMDA receptor antagonists (dissociatives)';
      case 'cannabinoid':
        return 'CB1/CB2 receptor agonists (THC, synthetic cannabinoids)';
      default:
        return 'Unknown neurochemical system';
    }
  }

  /// Get icon for bucket type
  static String getIconName(String bucketType) {
    switch (bucketType.toLowerCase()) {
      case 'gaba':
        return 'psychology';
      case 'stimulant':
        return 'bolt';
      case 'serotonin_release':
        return 'favorite';
      case 'serotonin_psychedelic':
        return 'auto_awesome';
      case 'serotonin':
        return 'sentiment_satisfied_alt';
      case 'opioid':
        return 'medication';
      case 'nmda':
        return 'blur_on';
      case 'cannabinoid':
        return 'eco';
      default:
        return 'science';
    }
  }

  /// Normalize bucket names for compatibility
  /// Maps legacy bucket names to current standard
  static String normalizeBucketName(String bucketType) {
    switch (bucketType.toLowerCase()) {
      case 'serotonin':
        // Legacy "serotonin" maps to "serotonin_release" for compatibility
        return 'serotonin_release';
      default:
        return bucketType.toLowerCase();
    }
  }

  /// Get all unique bucket types from a list of tolerance models
  /// Returns ordered list based on orderedBuckets
  static List<String> getAllBucketTypes(Map<String, dynamic> toleranceModels) {
    final allBuckets = <String>{};
    // Add all canonical buckets first
    allBuckets.addAll(orderedBuckets);
    // Add any custom buckets from models (rare, but supported)
    for (final model in toleranceModels.values) {
      if (model is Map && model.containsKey('neuro_buckets')) {
        final neuroBuckets = model['neuro_buckets'] as Map?;
        if (neuroBuckets != null) {
          allBuckets.addAll(neuroBuckets.keys.cast<String>());
        }
      }
    }
    // Return in canonical order, with unknowns at end
    final ordered = <String>[];
    for (final bucket in orderedBuckets) {
      if (allBuckets.contains(bucket)) {
        ordered.add(bucket);
      }
    }
    // Add any non-canonical buckets at the end
    for (final bucket in allBuckets) {
      if (!orderedBuckets.contains(bucket)) {
        ordered.add(bucket);
      }
    }
    return ordered;
  }
}
