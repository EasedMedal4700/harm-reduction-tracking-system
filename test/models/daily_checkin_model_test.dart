import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/models/daily_checkin_model.dart';

void main() {
  group('DailyCheckin Model', () {
    test('fromJson creates correct instance', () {
      final json = {
        'id': '1',
        'uuid_user_id': 'user123',
        'checkin_date': '2023-10-27',
        'mood': 'Happy',
        'emotions': ['Joy'],
        'time_of_day': 'Morning',
        'notes': 'Good day',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final checkin = DailyCheckin.fromJson(json);

      expect(checkin.id, '1');
      expect(checkin.userId, 'user123');
      expect(checkin.mood, 'Happy');
      expect(checkin.emotions, ['Joy']);
    });

    test('toJson returns correct map', () {
      final checkin = DailyCheckin(
        id: '1',
        userId: 'user123',
        checkinDate: DateTime(2023, 10, 27),
        mood: 'Happy',
        emotions: ['Joy'],
        timeOfDay: 'Morning',
        notes: 'Good day',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final json = checkin.toJson();

      expect(json['id'], '1');
      expect(json['mood'], 'Happy');
      expect(json['emotions'], ['Joy']);
    });
  });
}
