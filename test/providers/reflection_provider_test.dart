import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/reflection_model.dart';
import 'package:mobile_drug_use_app/providers/reflection_provider.dart';

void main() {
  group('ReflectionProvider', () {
    test('updateReflection replaces state reference', () {
      final provider = ReflectionProvider();
      final updated = Reflection(effectiveness: 9, notes: 'Great day');

      provider.updateReflection(updated);

      expect(provider.reflection.effectiveness, 9);
      expect(provider.reflection.notes, 'Great day');
    });

    test('toggleEntry adds and removes ids', () {
      final provider = ReflectionProvider();

      provider.toggleEntry('123', true);
      expect(provider.selectedIds, contains('123'));

      provider.toggleEntry('123', false);
      expect(provider.selectedIds, isEmpty);
    });

    test('setShowForm and setSaving flip flags', () {
      final provider = ReflectionProvider();

      provider.setShowForm(true);
      provider.setSaving(true);

      expect(provider.showForm, isTrue);
      expect(provider.isSaving, isTrue);
    });

    test('reset clears selections and restores defaults', () {
      final provider = ReflectionProvider();
      provider.toggleEntry('1', true);
      provider.setShowForm(true);
      provider.reflection.effectiveness = 2;
      provider.reflection.notes = 'Custom';

      provider.reset();

      expect(provider.selectedIds, isEmpty);
      expect(provider.showForm, isFalse);
      expect(provider.reflection.effectiveness, 5.0);
      expect(provider.reflection.notes, '');
    });
  });
}
