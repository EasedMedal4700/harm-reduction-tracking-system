import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/constants/enums/app_mood.dart';

void main() {
  group('moodEmojis', () {
    test('contains all expected mood mappings', () {
      expect(moodEmojis, {
        'Great': '😊',
        'Good': '🙂',
        'Neutral': '😐',
        'Struggling': '😟',
        'Poor': '😢',
      });
    });

    test('has correct emoji for Great', () {
      expect(moodEmojis['Great'], '😊');
    });

    test('has correct emoji for Good', () {
      expect(moodEmojis['Good'], '🙂');
    });

    test('has correct emoji for Neutral', () {
      expect(moodEmojis['Neutral'], '😐');
    });

    test('has correct emoji for Struggling', () {
      expect(moodEmojis['Struggling'], '😟');
    });

    test('has correct emoji for Poor', () {
      expect(moodEmojis['Poor'], '😢');
    });

    test('has 5 mood entries', () {
      expect(moodEmojis.length, 5);
    });

    test('contains all expected keys', () {
      expect(moodEmojis.keys, containsAll(['Great', 'Good', 'Neutral', 'Struggling', 'Poor']));
    });
  });
}