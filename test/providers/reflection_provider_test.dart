import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/reflection/models/reflection_model.dart';
import 'package:mobile_drug_use_app/features/reflection/providers/reflection_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('ReflectionController', () {
    test('updateReflection replaces state reference', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(reflectionControllerProvider.notifier);
      final updated = Reflection(effectiveness: 9, notes: 'Great day');

      controller.updateReflection(updated);

      final state = container.read(reflectionControllerProvider);
      expect(state.reflection.effectiveness, 9);
      expect(state.reflection.notes, 'Great day');
    });

    test('toggleEntry adds and removes ids', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(reflectionControllerProvider.notifier);

      controller.toggleEntry('123', true);
      expect(
        container.read(reflectionControllerProvider).selectedIds,
        contains('123'),
      );

      controller.toggleEntry('123', false);
      expect(container.read(reflectionControllerProvider).selectedIds, isEmpty);
    });

    test('setShowForm and setSaving flip flags', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(reflectionControllerProvider.notifier);

      controller.setShowForm(true);
      controller.setSaving(true);

      final state = container.read(reflectionControllerProvider);
      expect(state.showForm, isTrue);
      expect(state.isSaving, isTrue);
    });

    test('reset clears selections and restores defaults', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = container.read(reflectionControllerProvider.notifier);

      controller.toggleEntry('1', true);
      controller.setShowForm(true);
      controller.updateReflection(
        container
            .read(reflectionControllerProvider)
            .reflection
            .copyWith(effectiveness: 2, notes: 'Custom'),
      );

      controller.reset();

      final state = container.read(reflectionControllerProvider);
      expect(state.selectedIds, isEmpty);
      expect(state.showForm, isFalse);
      expect(state.reflection.effectiveness, 5.0);
      expect(state.reflection.notes, '');
    });
  });
}
