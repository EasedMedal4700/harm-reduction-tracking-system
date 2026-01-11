import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/log_entry/utils/roa_normalization.dart';

void main() {
  group('RoaNormalization', () {
    test('buildDisplayROAs always starts with primary 3', () {
      final roas = RoaNormalization.buildDisplayROAs(['smoked', 'oral']);
      expect(roas.take(3).toList(), RoaNormalization.primaryDisplayROAs);
    });

    test('maps DB smoked to display inhaled (no extra smoked option)', () {
      final roas = RoaNormalization.buildDisplayROAs(['smoked']);
      expect(roas, contains('inhaled'));
      expect(roas, isNot(contains('smoked')));
    });

    test('normalize display inhaled to DB smoked when DB only has smoked', () {
      final normalized = RoaNormalization.normalizeDisplayToDbKey(
        displayRoa: 'inhaled',
        dbROAsLower: ['smoked'],
      );
      expect(normalized, 'smoked');
    });

    test(
      'DB vapourized is treated as inhaled (valid + normalizes back on save)',
      () {
        final roas = RoaNormalization.buildDisplayROAs(['vapourized']);
        expect(roas, contains('inhaled'));
        expect(roas, isNot(contains('vapourized')));

        final validated = RoaNormalization.isDisplayValidated(
          displayRoa: 'inhaled',
          dbROAsLower: ['vapourized'],
        );
        expect(validated, isTrue);

        final normalized = RoaNormalization.normalizeDisplayToDbKey(
          displayRoa: 'inhaled',
          dbROAsLower: ['vapourized'],
        );
        expect(normalized, 'vapourized');
      },
    );

    test(
      'normalize display sublingual to DB buccal when DB only has buccal',
      () {
        final normalized = RoaNormalization.normalizeDisplayToDbKey(
          displayRoa: 'sublingual',
          dbROAsLower: ['buccal'],
        );
        expect(normalized, 'buccal');
      },
    );

    test('isDisplayValidated accepts inhaled when DB has smoked', () {
      final validated = RoaNormalization.isDisplayValidated(
        displayRoa: 'inhaled',
        dbROAsLower: ['smoked'],
      );
      expect(validated, isTrue);
    });
  });
}
