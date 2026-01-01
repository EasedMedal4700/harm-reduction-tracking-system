import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';
import 'package:mobile_drug_use_app/features/tolerance/widgets/dashboard_content_widget.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/bucket_definitions.dart';

import '../../../helpers/test_app_wrapper.dart';

ToleranceResult _resultWithPercents(Map<String, double> percents) {
  return ToleranceResult(
    bucketPercents: percents,
    bucketRawLoads: percents.map((k, v) => MapEntry(k, 0.0)),
    toleranceScore: 0,
    daysUntilBaseline: percents.map((k, v) => MapEntry(k, 0.0)),
    overallDaysUntilBaseline: 0,
  );
}

void main() {
  group('DashboardContentWidget', () {
    testWidgets('shows empty state when systemTolerance is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: DashboardContentWidget(
            systemTolerance: null,
            substanceActiveStates: const {},
            substanceContributions: const {},
            selectedBucket: null,
            onBucketSelected: (_) {},
          ),
        ),
      );

      expect(find.text('No Tolerance Data'), findsOneWidget);
    });

    testWidgets('shows bucket details when selectedBucket is provided', (
      tester,
    ) async {
      final bucket = BucketDefinitions.orderedBuckets.first;
      final percents = {
        for (final b in BucketDefinitions.orderedBuckets) b: 0.0,
        bucket: 12.3,
      };

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: DashboardContentWidget(
            systemTolerance: _resultWithPercents(percents),
            substanceActiveStates: const {'caffeine': true},
            substanceContributions: {
              bucket: const {'caffeine': 12.3},
            },
            selectedBucket: bucket,
            onBucketSelected: (_) {},
          ),
        ),
      );

      expect(find.text('Contributing Substances'), findsOneWidget);
      expect(find.text('caffeine'), findsOneWidget);
    });
  });
}
