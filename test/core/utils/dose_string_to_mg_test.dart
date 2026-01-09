import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_drug_use_app/core/utils/custom_dose_unit_manager.dart';
import 'package:mobile_drug_use_app/core/utils/dose_string_to_mg.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DoseStringToMg', () {
    test('converts custom unit doses into mg', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await CustomDoseUnitManager.writeUnitToMg(prefs, 'ketamine', {
        'line': 30,
        'pill': 140,
      });

      expect(
        DoseStringToMg.parse(
          prefs: prefs,
          substance: 'ketamine',
          dose: '2 line',
        ),
        60,
      );

      expect(
        DoseStringToMg.parse(
          prefs: prefs,
          substance: 'ketamine',
          dose: '1 pill',
        ),
        140,
      );
    });

    test('treats mg as mg (space or no-space)', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(
        DoseStringToMg.parse(prefs: prefs, substance: 'x', dose: '10 mg'),
        10,
      );
      expect(
        DoseStringToMg.parse(prefs: prefs, substance: 'x', dose: '10mg'),
        10,
      );
    });

    test('falls back to legacy behavior for unknown units', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(
        DoseStringToMg.parse(prefs: prefs, substance: 'x', dose: '3 scoops'),
        3,
      );
    });
  });
}
