import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drug_catalog_entry.dart';

/// Manages local drug preferences (favorites, notes, etc.)
class DrugPreferencesManager {
  /// Read preferences for a specific drug
  static LocalPrefs readPreferences(SharedPreferences prefs, String name) {
    final stored = prefs.getString(_prefsKey(name)) ?? 
                   prefs.getString(_legacyKey(name));
    
    if (stored == null) {
      return const LocalPrefs(
        favorite: false,
        archived: false,
        notes: '',
        quantity: 0,
      );
    }
    
    try {
      final decoded = jsonDecode(stored);
      if (decoded is Map<String, dynamic>) {
        return LocalPrefs(
          favorite: decoded['favorite'] == true,
          archived: decoded['archived'] == true,
          notes: decoded['notes']?.toString() ?? '',
          quantity: _parseQuantity(decoded['quantity']),
        );
      }
    } catch (_) {
      // Ignore malformed data
    }
    
    return const LocalPrefs(
      favorite: false,
      archived: false,
      notes: '',
      quantity: 0,
    );
  }

  /// Save/update favorite status for a drug
  static Future<void> saveFavorite(
    String drugName,
    bool favorite,
    LocalPrefs current,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final updated = {
      'favorite': favorite,
      'archived': current.archived,
      'notes': current.notes,
      'quantity': current.quantity,
    };
    
    final encoded = jsonEncode(updated);
    final primary = _prefsKey(drugName);
    final legacy = _legacyKey(drugName);
    
    await prefs.setString(primary, encoded);
    if (legacy != primary) {
      await prefs.setString(legacy, encoded);
    }
  }

  static num _parseQuantity(dynamic value) {
    if (value is num) return value;
    if (value == null) return 0;
    return double.tryParse(value.toString()) ?? 0;
  }

  static String _prefsKey(String name) => 'drug_${name.trim()}';
  
  static String _legacyKey(String name) => 'drug_${name.trim().toLowerCase()}';
}
