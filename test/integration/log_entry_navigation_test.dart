import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mobile_drug_use_app/constants/theme/app_theme.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_provider.dart';
import 'package:mobile_drug_use_app/features/log_entry/log_entry_page.dart';

void main() {
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('launches and navigates to Log Entry page', (tester) async {
    await tester.pumpWidget(
      AppThemeProvider(
        theme: AppTheme.light(),
        child: MaterialApp(
          routes: {
            '/': (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/log'),
                    child: const Text('Go to Log'),
                  ),
                ),
              );
            },
            '/log': (context) => const QuickLogEntryPage(),
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Go to Log'));
    await tester.pumpAndSettle();

    // Smoke assertions: page loads and core inputs are visible.
    expect(find.text('Save Entry'), findsOneWidget);
    expect(find.text('Substance'), findsOneWidget);
    expect(find.text('Dose'), findsOneWidget);
    // The route dropdown defaults to a selected value, so the hint text is not visible.
    expect(find.text('Oral'), findsWidgets);
  });
}
