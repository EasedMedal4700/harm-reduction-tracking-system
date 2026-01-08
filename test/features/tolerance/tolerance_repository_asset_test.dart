import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/controllers/tolerance_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ToleranceRepository parses tolerance neuro buckets asset shape', () async {
    // Provide a minimal fake asset bundle response for the repository to parse.
    ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        final key = utf8.decode(message!.buffer.asUint8List());
        if (key ==
            'backend/ML/drug_tolerance_model/outputs/tolerance_neuro_buckets.json') {
          final payload = {
            'substances': {
              'caffeine': {
                'slug': 'caffeine',
                'display_name': 'Caffeine',
                'half_life_hours': 5.0,
                'tolerance_decay_days': 7.0,
                'neuro_buckets': {
                  'stimulant': {'baseline': 0.0, 'max': 1.0},
                },
              },
            },
          };
          final bytes = utf8.encode(jsonEncode(payload));
          return ByteData.view(Uint8List.fromList(bytes).buffer);
        }
        return null;
      },
    );

    final repo = ToleranceRepository(null);
    final models = await repo.fetchToleranceModels();

    expect(models, isNotEmpty);
    expect(models.containsKey('caffeine'), isTrue);
  });
}
