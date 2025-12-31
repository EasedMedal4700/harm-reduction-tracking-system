import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/framework.dart';
import 'package:mobile_drug_use_app/features/setup_account/controllers/recovery_key_controller.dart';
import 'package:mobile_drug_use_app/features/setup_account/models/recovery_key_state.dart';
import 'package:mobile_drug_use_app/features/setup_account/pages/recovery_key_page.dart';
import '../../helpers/test_app_wrapper.dart';

class _FakeRecoveryKeyController extends RecoveryKeyController {
  _FakeRecoveryKeyController({required this.resetPinOk});

  final bool resetPinOk;

  @override
  RecoveryKeyState build() => const RecoveryKeyState();

  @override
  void toggleKeyObscure() =>
      state = state.copyWith(keyObscure: !state.keyObscure);

  @override
  void togglePinObscure() => state = state.copyWith(pinObscure: !state.pinObscure);

  @override
  void toggleConfirmPinObscure() => state =
      state.copyWith(confirmPinObscure: !state.confirmPinObscure);

  @override
  void backToRecoveryKeyEntry() {
    state = state.copyWith(
      recoveryKeyValidated: false,
      validatedRecoveryKey: null,
      errorMessage: null,
    );
  }

  @override
  Future<bool> validateRecoveryKey(String recoveryKeyRaw) async {
    final trimmed = recoveryKeyRaw.trim();
    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      recoveryKeyValidated: true,
      validatedRecoveryKey: trimmed,
    );
    return true;
  }

  @override
  Future<bool> resetPin({
    required String newPinRaw,
    required String confirmPinRaw,
  }) async {
    state = state.copyWith(isLoading: false, errorMessage: null);
    return resetPinOk;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  List<Override> overrides({required bool resetPinOk}) => [
        recoveryKeyControllerProvider.overrideWith(
          () => _FakeRecoveryKeyController(resetPinOk: resetPinOk),
        ),
      ];

  testWidgets('RecoveryKeyScreen can validate key and reset pin', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: const RecoveryKeyScreen(),
        providerOverrides: overrides(resetPinOk: false),
        size: const Size(400, 900),
      ),
    );

    expect(find.text('Enter Recovery Key'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'a' * 24);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Create New PIN'), findsAtLeastNWidgets(1));

    // Toggle visibility icons to exercise controller methods.
    await tester.tap(find.byIcon(Icons.visibility).first);
    await tester.pump();

    // Enter PINs and submit.
    final pinFields = find.byType(TextField);
    expect(pinFields, findsNWidgets(2));
    await tester.enterText(pinFields.at(0), '123456');
    await tester.enterText(pinFields.at(1), '123456');

    await tester.ensureVisible(find.text('Reset PIN'));
    await tester.pump();
    await tester.tap(find.text('Reset PIN'), warnIfMissed: false);
    await tester.pump();

    // Fake controller returns false to avoid navigation requiring GoRouter.
    expect(find.text('Create New PIN'), findsAtLeastNWidgets(1));
  });

  testWidgets('RecoveryKeyScreen back button returns to recovery key step', (tester) async {
    await tester.pumpWidget(
      createEnhancedTestWrapper(
        child: const RecoveryKeyScreen(),
        providerOverrides: overrides(resetPinOk: false),
        size: const Size(400, 900),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'a' * 24);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Create New PIN'), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Enter Recovery Key'), findsOneWidget);
  });
}
