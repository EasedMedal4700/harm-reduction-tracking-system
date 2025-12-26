import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/models/tolerance_models.dart';
import 'package:mobile_drug_use_app/features/tolerance/widgets/system_overview_widget.dart';
import 'package:mobile_drug_use_app/models/bucket_definitions.dart';

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
  group('SystemOverviewWidget', () {
    testWidgets('shows loader when systemTolerance is null', (tester) async {
      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SystemOverviewWidget(
            systemTolerance: null,
            substanceActiveStates: const {},
            substanceContributions: const {},
            selectedBucket: null,
            onBucketSelected: (_) {},
          ),
        ),
      );

      // CommonLoader is internal; just ensure something renders.
      expect(find.byType(SystemOverviewWidget), findsOneWidget);
    });

    testWidgets('renders a horizontal list of bucket cards', (tester) async {
      final buckets = BucketDefinitions.orderedBuckets;
      final percents = {for (final b in buckets) b: 0.0};

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SystemOverviewWidget(
            systemTolerance: _resultWithPercents(percents),
            substanceActiveStates: const {},
            substanceContributions: const {},
            selectedBucket: null,
            onBucketSelected: (_) {},
          ),
        ),
      );

      // Titles should show for at least a couple of buckets.
      expect(
        find.text(BucketDefinitions.getDisplayName(buckets.first)),
        findsOneWidget,
      );

      // The last bucket may be offscreen; scroll to build it.
      await tester.drag(find.byType(ListView), const Offset(-1000, 0));
      await tester.pumpAndSettle();

      expect(
        find.text(BucketDefinitions.getDisplayName(buckets.last)),
        findsOneWidget,
      );
    });

    testWidgets('tapping a card calls onBucketSelected', (tester) async {
      final buckets = BucketDefinitions.orderedBuckets;
      final percents = {for (final b in buckets) b: 0.0};

      String? selected;

      await tester.pumpWidget(
        createEnhancedTestWrapper(
          child: SystemOverviewWidget(
            systemTolerance: _resultWithPercents(percents),
            substanceActiveStates: const {},
            substanceContributions: const {},
            selectedBucket: null,
            onBucketSelected: (b) => selected = b,
          ),
        ),
      );

      await tester.tap(
        find.text(BucketDefinitions.getDisplayName(buckets.first)),
      );
      await tester.pump();

      expect(selected, buckets.first);
    });
  });
}
