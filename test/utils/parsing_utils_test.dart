import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/utils/parsing_utils.dart';

void main() {
  group('ParsingUtils', () {
    group('parseDouble', () {
      test('parses valid double string', () {
        expect(ParsingUtils.parseDouble('10.5'), 10.5);
        expect(ParsingUtils.parseDouble('0.123'), 0.123);
        expect(ParsingUtils.parseDouble('100'), 100.0);
      });

      test('parses numeric types', () {
        expect(ParsingUtils.parseDouble(42), 42.0);
        expect(ParsingUtils.parseDouble(3.14), 3.14);
      });

      test('returns 0.0 for invalid input', () {
        expect(ParsingUtils.parseDouble('invalid'), 0.0);
        expect(ParsingUtils.parseDouble(''), 0.0);
        expect(ParsingUtils.parseDouble(null), 0.0);
      });
    });

    group('parseInt', () {
      test('parses valid int string', () {
        expect(ParsingUtils.parseInt('42'), 42);
        expect(ParsingUtils.parseInt('0'), 0);
        expect(ParsingUtils.parseInt('-15'), -15);
      });

      test('parses numeric types', () {
        expect(ParsingUtils.parseInt(42), 42);
        expect(ParsingUtils.parseInt(100), 100);
      });

      test('returns 0 for invalid input', () {
        expect(ParsingUtils.parseInt('invalid'), 0);
        expect(ParsingUtils.parseInt('3.14'), 0);
        expect(ParsingUtils.parseInt(''), 0);
        expect(ParsingUtils.parseInt(null), 0);
      });
    });

    group('toList', () {
      test('converts List to List<String>', () {
        expect(ParsingUtils.toList(['a', 'b', 'c']), ['a', 'b', 'c']);
        expect(ParsingUtils.toList([1, 2, 3]), ['1', '2', '3']);
      });

      test('filters out empty strings', () {
        expect(ParsingUtils.toList(['a', '', 'b', null, 'c']), ['a', 'b', 'c']);
      });

      test('splits comma-separated string', () {
        expect(ParsingUtils.toList('happy,sad,angry'), ['happy', 'sad', 'angry']);
      });

      test('splits semicolon-separated string', () {
        expect(ParsingUtils.toList('item1;item2;item3'), ['item1', 'item2', 'item3']);
      });

      test('splits space-separated string when splitBySpace=true', () {
        expect(ParsingUtils.toList('John Jane Bob', splitBySpace: true), 
               ['John', 'Jane', 'Bob']);
      });

      test('trims whitespace from split strings', () {
        expect(ParsingUtils.toList(' a , b , c '), ['a', 'b', 'c']);
      });

      test('returns empty list for null', () {
        expect(ParsingUtils.toList(null), []);
      });

      test('returns empty list for empty string', () {
        expect(ParsingUtils.toList(''), []);
      });

      test('handles mixed whitespace splitting', () {
        expect(ParsingUtils.toList('a  b   c', splitBySpace: true), ['a', 'b', 'c']);
      });
    });

    group('toMap', () {
      test('converts Map to Map<String, List<String>>', () {
        final input = {'key1': ['a', 'b'], 'key2': ['c']};
        expect(ParsingUtils.toMap(input), {'key1': ['a', 'b'], 'key2': ['c']});
      });

      test('converts single values to lists', () {
        final input = {'key1': 'value1', 'key2': 'value2'};
        expect(ParsingUtils.toMap(input), {
          'key1': ['value1'],
          'key2': ['value2'],
        });
      });

      test('converts mixed Map types', () {
        final input = {'list': ['a', 'b'], 'single': 'value'};
        expect(ParsingUtils.toMap(input), {
          'list': ['a', 'b'],
          'single': ['value'],
        });
      });

      test('converts keys to strings', () {
        final input = {1: ['a'], 2: ['b']};
        expect(ParsingUtils.toMap(input), {
          '1': ['a'],
          '2': ['b'],
        });
      });

      test('converts string to default key map', () {
        expect(ParsingUtils.toMap('a,b,c'), {'default': ['a', 'b', 'c']});
      });

      test('converts List to default key map', () {
        expect(ParsingUtils.toMap(['x', 'y']), {'default': ['x', 'y']});
      });

      test('returns empty map for null', () {
        expect(ParsingUtils.toMap(null), {});
      });

      test('returns empty map for empty string', () {
        expect(ParsingUtils.toMap(''), {});
      });
    });

    group('parseTimezone', () {
      test('parses +HH:MM format', () {
        expect(ParsingUtils.parseTimezone('+05:30'), 5.5);
        expect(ParsingUtils.parseTimezone('+08:00'), 8.0);
        expect(ParsingUtils.parseTimezone('+00:30'), 0.5);
      });

      test('parses -HH:MM format', () {
        expect(ParsingUtils.parseTimezone('-05:30'), -5.5);
        expect(ParsingUtils.parseTimezone('-08:00'), -8.0);
      });

      test('parses +HHMM format without colon', () {
        expect(ParsingUtils.parseTimezone('+0530'), 5.5);
        expect(ParsingUtils.parseTimezone('+0800'), 8.0);
      });

      test('parses -HHMM format without colon', () {
        expect(ParsingUtils.parseTimezone('-0530'), -5.5);
      });

      test('parses single digit hours', () {
        expect(ParsingUtils.parseTimezone('+5:30'), 5.5);
        expect(ParsingUtils.parseTimezone('-8:00'), -8.0);
      });

      test('parses numeric values', () {
        expect(ParsingUtils.parseTimezone(5.5), 5.5);
        expect(ParsingUtils.parseTimezone(-8), -8.0);
        expect(ParsingUtils.parseTimezone('3.5'), 3.5);
      });

      test('returns 0.0 for null', () {
        expect(ParsingUtils.parseTimezone(null), 0.0);
      });

      test('returns 0.0 for invalid format', () {
        expect(ParsingUtils.parseTimezone('invalid'), 0.0);
        expect(ParsingUtils.parseTimezone(''), 0.0);
      });

      test('handles UTC (zero offset)', () {
        expect(ParsingUtils.parseTimezone('+00:00'), 0.0);
        expect(ParsingUtils.parseTimezone('0'), 0.0);
      });
    });
  });
}
