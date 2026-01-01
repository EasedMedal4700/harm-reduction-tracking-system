import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';
import 'package:mobile_drug_use_app/features/tolerance/widgets/system_bucket_card.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/bucket_definitions.dart';

import '../../../helpers/test_app_wrapper.dart';

void main() {
  group('SystemBucketCard', () {
    testWidgets('renders bucket display name and percent', (tester) async {
      final bucketType = BucketDefinitions.orderedBuckets.first;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SystemBucketCard(
            bucketType: bucketType,
            tolerancePercent: 12.3,
            state: ToleranceSystemState.recovered,
            isActive: false,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(
        find.text(BucketDefinitions.getDisplayName(bucketType)),
        findsOneWidget,
      );
      expect(find.text('12.3%'), findsOneWidget);
      expect(find.text('Recovered'), findsOneWidget);
      expect(find.text('ACTIVE'), findsNothing);
    });

    testWidgets('shows ACTIVE pill when isActive true', (tester) async {
      final bucketType = BucketDefinitions.orderedBuckets.first;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SystemBucketCard(
            bucketType: bucketType,
            tolerancePercent: 12.3,
            state: ToleranceSystemState.recovered,
            isActive: true,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('ACTIVE'), findsOneWidget);
    });

    testWidgets('tap calls onTap', (tester) async {
      var tapped = false;
      final bucketType = BucketDefinitions.orderedBuckets.first;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SystemBucketCard(
            bucketType: bucketType,
            tolerancePercent: 12.3,
            state: ToleranceSystemState.recovered,
            isActive: false,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(SystemBucketCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
