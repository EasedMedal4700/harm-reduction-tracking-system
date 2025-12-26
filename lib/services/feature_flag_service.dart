// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Service.
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cache_service.dart';
import '../common/logging/app_log.dart';

/// Feature flag model representing a single flag from the database.
class FeatureFlag {
  final int id;
  final String featureName;
  final bool enabled;
  final String? description;
  final DateTime updatedAt;
  const FeatureFlag({
    required this.id,
    required this.featureName,
    required this.enabled,
    this.description,
    required this.updatedAt,
  });
  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
      id: json['id'] as int,
      featureName: json['feature_name'] as String,
      enabled: json['enabled'] as bool,
      description: json['description'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  FeatureFlag copyWith({bool? enabled}) {
    return FeatureFlag(
      id: id,
      featureName: featureName,
      enabled: enabled ?? this.enabled,
      description: description,
      updatedAt: updatedAt,
    );
  }
}

/// Service for managing feature flags from Supabase.
///
/// Loads all flags on app start, caches them in memory, and provides
/// methods to check if features are enabled. Supports admin override.
///
/// Usage:
/// ```dart
/// await featureFlagService.load();
/// final canAccess = featureFlagService.isEnabled('home_page', isAdmin: false);
/// ```
class FeatureFlagService extends ChangeNotifier {
  static final FeatureFlagService _instance = FeatureFlagService._internal();
  factory FeatureFlagService() => _instance;
  FeatureFlagService._internal();

  /// Getter for Supabase client (lazy to avoid initialization issues in tests)
  SupabaseClient get _client => Supabase.instance.client;
  final CacheService _cache = CacheService();

  /// In-memory cache of all feature flags.
  Map<String, FeatureFlag> _flags = {};

  /// Whether flags have been loaded from the database.
  bool _isLoaded = false;

  /// Whether a load operation is in progress.
  bool _isLoading = false;

  /// Error message if loading failed.
  String? _errorMessage;
  // ============================================================================
  // GETTERS
  // ============================================================================
  /// Returns true if flags have been loaded from the database.
  bool get isLoaded => _isLoaded;

  /// Returns true if a load operation is in progress.
  bool get isLoading => _isLoading;

  /// Returns error message if loading failed.
  String? get errorMessage => _errorMessage;

  /// Returns all loaded feature flags.
  List<FeatureFlag> get allFlags => _flags.values.toList();
  // ============================================================================
  // LOAD & REFRESH
  // ============================================================================
  /// Load all feature flags from Supabase.
  ///
  /// Call this on app start. Safe to call multiple times.
  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      AppLog.d('🏴 Loading feature flags from database...');
      final response = await _client
          .from('feature_flags')
          .select('id, feature_name, enabled, description, updated_at')
          .order('feature_name');
      _flags = {};
      for (final row in response as List<dynamic>) {
        final flag = FeatureFlag.fromJson(row as Map<String, dynamic>);
        _flags[flag.featureName] = flag;
      }
      _isLoaded = true;
      AppLog.d('✅ Loaded ${_flags.length} feature flags');
      // Cache the flags
      _cache.set('feature_flags_loaded', true, ttl: CacheService.longTTL);
    } catch (e, stackTrace) {
      AppLog.e('❌ Error loading feature flags: $e');
      AppLog.e('$stackTrace');
      _errorMessage = 'Failed to load feature flags: $e';
      // On error, default to all features enabled (fail-open)
      _isLoaded = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh feature flags from the database.
  Future<void> refresh() async {
    _isLoaded = false;
    await load();
  }

  // ============================================================================
  // CHECK FLAGS
  // ============================================================================
  /// Check if a feature is enabled.
  ///
  /// Returns true if:
  /// - The feature flag is enabled in the database, OR
  /// - The user is an admin (admin override)
  ///
  /// If flags haven't loaded yet, defaults to true (fail-open).
  bool isEnabled(String featureName, {required bool isAdmin}) {
    // Admin override: admins can always access all features
    if (isAdmin) {
      return true;
    }
    // If flags haven't loaded, default to enabled (fail-open)
    if (!_isLoaded) {
      AppLog.w('⚠️ Feature flags not loaded, defaulting to enabled');
      return true;
    }
    // Check if flag exists
    final flag = _flags[featureName];
    if (flag == null) {
      // Unknown feature, default to enabled
      AppLog.w('⚠️ Unknown feature flag: $featureName, defaulting to enabled');
      return true;
    }
    return flag.enabled;
  }

  /// Get a specific feature flag by name.
  FeatureFlag? getFlag(String featureName) {
    return _flags[featureName];
  }

  /// Clear the in-memory cache.
  void clearCache() {
    _flags = {};
    _isLoaded = false;
  }

  // ============================================================================
  // ADMIN: UPDATE FLAGS
  // ============================================================================
  /// Update a feature flag's enabled state (admin only).
  ///
  /// Updates the database and refreshes the local cache.
  Future<bool> updateFlag(String featureName, bool enabled) async {
    try {
      AppLog.d('🏴 Updating feature flag: $featureName = $enabled');
      await _client
          .from('feature_flags')
          .update({
            'enabled': enabled,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('feature_name', featureName);
      // Update local cache
      final existingFlag = _flags[featureName];
      if (existingFlag != null) {
        _flags[featureName] = existingFlag.copyWith(enabled: enabled);
        notifyListeners();
      }
      AppLog.d('✅ Feature flag updated successfully');
      return true;
    } catch (e, stackTrace) {
      AppLog.e('❌ Error updating feature flag: $e');
      AppLog.e('$stackTrace');
      return false;
    }
  }
}

/// Global singleton instance for easy access.
final featureFlagService = FeatureFlagService();
