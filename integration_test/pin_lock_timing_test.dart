import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_drug_use_app/providers/core_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App Lock Timing: Resume within grace period does not lock', (tester) async {
    // Setup SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              final state = ref.watch(appLockControllerProvider);
              return Text(state.requiresPin ? 'LOCKED' : 'UNLOCKED');
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('UNLOCKED'), findsOneWidget);

    // Simulate backgrounding
    final container = ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
    await container.read(appLockControllerProvider.notifier).onBackgroundStart();
    
    // Wait a bit (less than grace period)
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate resume
    await container.read(appLockControllerProvider.notifier).onForegroundResume();
    await tester.pump();

    expect(find.text('UNLOCKED'), findsOneWidget);
  });
}
