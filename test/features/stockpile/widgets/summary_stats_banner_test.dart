import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/stockpile/widgets/personal_library/summary_stats_banner.dart';
import '../../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets('SummaryStatsBanner renders totals and category', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: const SummaryStatsBanner(
          totalUses: 12,
          activeSubstances: 3,
          avgUses: 4.0,
          mostUsedCategory: 'Stimulant',
        ),
      ),
    );

    expect(find.text('12'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('Most Used Category: Stimulant'), findsOneWidget);
  });
}
