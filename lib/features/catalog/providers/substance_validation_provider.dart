// MIGRATION:
// State: MODERN
// Navigation: N/A
// Models: N/A
// Theme: N/A
// Common: N/A
// Notes: Drug provider.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'drug_names_provider.dart';

final substanceValidationProvider =
    Provider.family<String? Function(String?), String>((ref, currentValue) {
      final asyncNames = ref.watch(drugNamesProvider);
      return (String? value) {
        final trimmed = value?.trim() ?? '';
        if (trimmed.isEmpty) return 'Substance cannot be empty';
        return asyncNames.when(
          data: (names) {
            final lower = trimmed.toLowerCase();
            final exists = names.any((n) => n.toLowerCase() == lower);
            if (!exists) return 'Unknown substance';
            return null;
          },
          loading: () => null,
          error: (_, __) => null,
        );
      };
    });
