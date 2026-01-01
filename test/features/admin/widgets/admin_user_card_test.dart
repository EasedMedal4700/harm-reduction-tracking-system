import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_drug_use_app/features/admin/models/admin_user.dart';
import 'package:mobile_drug_use_app/features/admin/widgets/users/admin_user_card.dart';

import '../../../flutter_test_config.dart';

void main() {
  group('AdminUserCard', () {
    testWidgets('renders invalid user data fallback when authUserId empty', (
      tester,
    ) async {
      const user = AdminUser(
        authUserId: '',
        displayName: 'Unknown',
        email: 'unknown@example.com',
      );

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AdminUserCard(user: user, onToggleAdmin: (_, __) async {}),
        ),
      );

      expect(find.text('Invalid user data'), findsOneWidget);
      expect(find.textContaining('Email:'), findsOneWidget);
    });

    testWidgets('shows ADMIN badge and toggle button label', (tester) async {
      const user = AdminUser(
        authUserId: 'abcdef1234567890',
        displayName: 'Alice',
        email: 'alice@example.com',
        isAdmin: true,
        entryCount: 3,
        cravingCount: 1,
        reflectionCount: 2,
      );

      await tester.pumpWidget(
        TestUtils.createTestApp(
          child: AdminUserCard(user: user, onToggleAdmin: (_, __) async {}),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('ADMIN'), findsOneWidget);

      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();

      expect(find.text('Remove Admin'), findsOneWidget);
      expect(find.text('Total Activity'), findsOneWidget);
      expect(find.text('6'), findsOneWidget);
    });
  });
}
