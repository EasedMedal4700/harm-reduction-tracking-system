// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: MODERN
// Theme: N/A
// Common: N/A
// Notes: Service for settings.
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings_model.dart';
import 'package:mobile_drug_use_app/core/utils/error_handler.dart';

/// Service for managing app settings with local storage
class SettingsService {
  static const String _settingsKey = 'app_settings';
  static AppSettings? _cachedSettings;

  static final StreamController<AppSettings> _settingsChangedController =
      StreamController<AppSettings>.broadcast();

  /// Emits whenever settings are saved or reset.
  static Stream<AppSettings> get settingsChanged =>
      _settingsChangedController.stream;

  /// Load settings from local storage
  static Future<AppSettings> loadSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_settingsKey);
      if (jsonString == null) {
        _cachedSettings = const AppSettings();
        return _cachedSettings!;
      }
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _cachedSettings = AppSettings.fromJson(json);
      return _cachedSettings!;
    } catch (e, stackTrace) {
      ErrorHandler.logError('SettingsService.loadSettings', e, stackTrace);
      _cachedSettings = const AppSettings();
      return _cachedSettings!;
    }
  }

  /// Save settings to local storage
  static Future<void> saveSettings(AppSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      await prefs.setString(_settingsKey, jsonString);
      _cachedSettings = settings;
      _settingsChangedController.add(settings);
      ErrorHandler.logInfo('SettingsService', 'Settings saved successfully');
    } catch (e, stackTrace) {
      ErrorHandler.logError('SettingsService.saveSettings', e, stackTrace);
      rethrow;
    }
  }

  /// Update a specific setting
  static Future<AppSettings> updateSetting(
    AppSettings Function(AppSettings) updater,
  ) async {
    final currentSettings = await loadSettings();
    final newSettings = updater(currentSettings);
    await saveSettings(newSettings);
    return newSettings;
  }

  /// Reset settings to default
  static Future<void> resetSettings() async {
    try {
      const defaultSettings = AppSettings();
      await saveSettings(defaultSettings);
      ErrorHandler.logInfo('SettingsService', 'Settings reset to default');
    } catch (e, stackTrace) {
      ErrorHandler.logError('SettingsService.resetSettings', e, stackTrace);
      rethrow;
    }
  }

  /// Clear cached settings (call after logout)
  static void clearCache() {
    _cachedSettings = null;
  }

  /// Get cached settings (synchronous)
  static AppSettings? getCachedSettings() {
    return _cachedSettings;
  }
}
