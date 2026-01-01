import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/stockpile/widgets/library_search_bar.dart';
import '../../../helpers/test_app_wrapper.dart';

void main() {
  testWidgets('LibrarySearchBar shows clear button only when text exists', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    var changed = '';
    var cleared = 0;

    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: LibrarySearchBar(
          controller: controller,
          onChanged: (v) => changed = v,
          onClear: () => cleared++,
        ),
      ),
    );

    expect(find.byIcon(Icons.clear), findsNothing);

    controller.text = 'abc';
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: LibrarySearchBar(
          controller: controller,
          onChanged: (v) => changed = v,
          onClear: () => cleared++,
        ),
      ),
    );

    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'abcd');
    expect(changed, 'abcd');

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();
    expect(cleared, 1);
  });
}
