import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/widgets/bucket_details_widget.dart';
import 'package:mobile_drug_use_app/models/bucket_definitions.dart';

import '../../../helpers/test_app_wrapper.dart';

void main() {
  group('BucketDetailsWidget', () {
    testWidgets('renders header + empty contributions message', (tester) async {
      final bucketType = BucketDefinitions.orderedBuckets.first;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: BucketDetailsWidget(
            bucketType: bucketType,
            tolerancePercent: 10,
            substanceContributions: const {},
            onClose: () {},
          ),
        ),
      );

      expect(
        find.text(BucketDefinitions.getDisplayName(bucketType)),
        findsOneWidget,
      );
      expect(find.text('No active contributions'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('renders contributions list when present', (tester) async {
      final bucketType = BucketDefinitions.orderedBuckets.first;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: BucketDetailsWidget(
            bucketType: bucketType,
            tolerancePercent: 55,
            substanceContributions: const {'caffeine': 12.3, 'alcohol': 4.0},
            onClose: () {},
          ),
        ),
      );

      expect(find.text('Contributing Substances'), findsOneWidget);
      expect(find.text('caffeine'), findsOneWidget);
      expect(find.text('alcohol'), findsOneWidget);
      expect(find.text('12.3%'), findsOneWidget);
      expect(find.text('4.0%'), findsOneWidget);
    });

    testWidgets('close button calls onClose', (tester) async {
      var closed = false;
      final bucketType = BucketDefinitions.orderedBuckets.first;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: BucketDetailsWidget(
            bucketType: bucketType,
            tolerancePercent: 10,
            substanceContributions: const {},
            onClose: () => closed = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(closed, isTrue);
    });
  });
}
