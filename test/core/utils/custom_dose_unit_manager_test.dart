import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_drug_use_app/core/utils/custom_dose_unit_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomDoseUnitManager', () {
    test('writes and reads normalized unit mappings', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await CustomDoseUnitManager.writeUnitToMg(prefs, 'Ketamine', {
        ' Pill ': 140,
        'line': 30.0,
        '': 10,
        'bad': -5,
      });

      final read = CustomDoseUnitManager.readUnitToMg(prefs, 'ketamine');
      expect(read, containsPair('pill', 140));
      expect(read, containsPair('line', 30));
      expect(read.containsKey(''), isFalse);
      expect(read.containsKey('bad'), isFalse);
    });

    test('deletes a unit', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await CustomDoseUnitManager.writeUnitToMg(prefs, 'lsd', {
        'tab': 100,
        'drop': 50,
      });

      await CustomDoseUnitManager.deleteUnit(prefs, 'LSD', 'tab');
      final read = CustomDoseUnitManager.readUnitToMg(prefs, 'lsd');
      expect(read.containsKey('tab'), isFalse);
      expect(read, containsPair('drop', 50));
    });
  });
}
