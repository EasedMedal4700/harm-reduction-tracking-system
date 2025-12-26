import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_drug_use_app/features/tolerance/widgets/empty_state_widget.dart';

import '../../../helpers/test_app_wrapper.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('renders copy and no CTA when onAddEntry is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createEnhancedTestWrapper(child: const EmptyStateWidget()),
      );

      expect(find.text('No Tolerance Data'), findsOneWidget);
      expect(find.text('Add Log Entry'), findsNothing);
    });

    testWidgets('renders CTA when onAddEntry is provided', (tester) async {
      await tester.pumpWidget(
        createEnhancedTestWrapper(child: EmptyStateWidget(onAddEntry: () {})),
      );

      expect(find.text('No Tolerance Data'), findsOneWidget);
      expect(find.text('Add Log Entry'), findsOneWidget);
    });
  });
}
