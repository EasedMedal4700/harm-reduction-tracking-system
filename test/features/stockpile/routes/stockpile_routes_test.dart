import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';

void main() {
  test('AppRoutePaths.library stays stable', () {
    expect(AppRoutePaths.library, '/library');
  });
}
