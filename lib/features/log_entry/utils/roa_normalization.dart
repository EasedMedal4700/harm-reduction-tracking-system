// MIGRATION:
// State: N/A
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Normalizes ROA (route of administration) between UI display and DB keys.

/// ROA normalization rules:
/// - UI shows 3 primary options: oral / inhaled / insufflated.
/// - DB may use more specific keys (e.g. smoked, intranasal, buccal).
/// - When saving, we normalize the selected UI value to a DB key when possible.
class RoaNormalization {
  static const List<String> primaryDisplayROAs = [
    'oral',
    'inhaled',
    'insufflated',
  ];

  static const Map<String, String> primaryEmoji = {
    'oral': '💊',
    'inhaled': '💨',
    'insufflated': '👃',
  };

  static String displayForDbKey(String dbRoaLower) {
    final key = dbRoaLower.trim().toLowerCase();

    if (_inhaledFamily.contains(key)) return 'inhaled';
    if (_insufflatedFamily.contains(key)) return 'insufflated';
    if (_oralFamily.contains(key)) return 'oral';
    if (_sublingualFamily.contains(key)) return 'sublingual';

    return key;
  }

  /// Returns the list of ROAs to show in the UI:
  /// - Always includes the 3 primary ROAs.
  /// - Adds any substance-specific ROAs from the DB (mapped to display keys),
  ///   excluding anything already covered by the primary ROAs.
  static List<String> buildDisplayROAs(List<String> dbROAsLower) {
    final display = <String>{...primaryDisplayROAs};

    for (final dbKey in dbROAsLower) {
      final mapped = displayForDbKey(dbKey);
      if (!primaryDisplayROAs.contains(mapped)) {
        display.add(mapped);
      }
    }

    final extras = display
        .where((r) => !primaryDisplayROAs.contains(r))
        .toList(growable: false);
    extras.sort();

    return [...primaryDisplayROAs, ...extras];
  }

  /// Whether a displayed ROA is validated by DB keys.
  /// Example: UI "inhaled" is valid if DB contains "smoked" or "inhaled".
  static bool isDisplayValidated({
    required String displayRoa,
    required List<String> dbROAsLower,
  }) {
    final normalized = normalizeDisplayToDbKey(
      displayRoa: displayRoa,
      dbROAsLower: dbROAsLower,
    );
    return normalized != null;
  }

  /// Normalize a display ROA (what the user clicked) to a DB key.
  /// - If DB contains the display key directly, we return it.
  /// - If DB contains a known synonym for the display key family, we prefer that.
  /// - If we cannot find a match, returns null.
  static String? normalizeDisplayToDbKey({
    required String displayRoa,
    required List<String> dbROAsLower,
  }) {
    final display = displayRoa.trim().toLowerCase();
    final dbSet = dbROAsLower.map((e) => e.trim().toLowerCase()).toSet();

    if (dbSet.contains(display)) return display;

    final family = _familyForDisplay(display);
    if (family != null) {
      for (final candidate in family) {
        if (dbSet.contains(candidate)) return candidate;
      }
    }

    return null;
  }

  static String normalizeOrFallback({
    required String displayRoa,
    required List<String> dbROAsLower,
  }) {
    return normalizeDisplayToDbKey(
          displayRoa: displayRoa,
          dbROAsLower: dbROAsLower,
        ) ??
        displayRoa.trim().toLowerCase();
  }

  static Iterable<String>? _familyForDisplay(String display) {
    return switch (display) {
      'oral' => _oralFamily,
      'inhaled' => _inhaledFamily,
      'insufflated' => _insufflatedFamily,
      'sublingual' => _sublingualFamily,
      _ => null,
    };
  }

  static const List<String> _oralFamily = ['oral', 'swallowed', 'ingested'];

  static const List<String> _inhaledFamily = [
    'inhaled',
    'smoked',
    'vaporized',
    'vaporised',
    'vapourized',
    'vapourised',
    'vaped',
    'vaping',
    'inhalation',
  ];

  static const List<String> _insufflatedFamily = [
    'insufflated',
    'snorted',
    'intranasal',
    'nasal',
  ];

  static const List<String> _sublingualFamily = ['sublingual', 'buccal'];
}
