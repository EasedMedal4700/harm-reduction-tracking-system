import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/admin/models/error_log_entry.dart';

void main() {
  group('ErrorLogEntry', () {
    test('parseExtraDataAsMap returns map when extraData is a map', () {
      final entry = ErrorLogEntry(extraData: {'a': 1});
      expect(entry.parseExtraDataAsMap(), {'a': 1});
    });

    test('parseExtraDataAsMap parses JSON string object', () {
      final entry = ErrorLogEntry(extraData: '{"a":1,"b":"x"}');
      expect(entry.parseExtraDataAsMap(), {'a': 1, 'b': 'x'});
    });

    test('parseExtraDataAsMap returns null for invalid JSON', () {
      final entry = ErrorLogEntry(extraData: '{not json');
      expect(entry.parseExtraDataAsMap(), isNull);
    });
  });
}
