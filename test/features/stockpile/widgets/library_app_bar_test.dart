import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/stockpile/widgets/personal_library/library_app_bar.dart';
import '../../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets('LibraryAppBar renders and triggers actions', (tester) async {
    var toggled = 0;
    var refreshed = 0;

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: CustomScrollView(
          slivers: [
            LibraryAppBar(
              showArchived: false,
              onToggleArchived: () => toggled++,
              onRefresh: () => refreshed++,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
          ],
        ),
      ),
    );

    expect(find.text('Personal Library'), findsOneWidget);

    await tester.tap(find.byTooltip('Show Archived'));
    await tester.pump();
    expect(toggled, 1);

    await tester.tap(find.byTooltip('Refresh'));
    await tester.pump();
    expect(refreshed, 1);
  });
}
