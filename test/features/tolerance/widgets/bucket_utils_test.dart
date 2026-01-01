import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/widgets/bucket_utils.dart';

void main() {
  group('BucketUtils', () {
    test('formatTimeAgo formats days', () {
      expect(BucketUtils.formatTimeAgo(const Duration(days: 3)), '3d ago');
    });

    test('formatTimeAgo formats hours', () {
      expect(BucketUtils.formatTimeAgo(const Duration(hours: 5)), '5h ago');
    });

    test('formatTimeAgo formats minutes', () {
      expect(BucketUtils.formatTimeAgo(const Duration(minutes: 12)), '12m ago');
    });
  });
}
