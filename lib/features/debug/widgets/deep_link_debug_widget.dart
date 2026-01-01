// MIGRATION:
// State: MODERN
// Navigation: CENTRALIZED
// Models: N/A
// Theme: TODO
// Common: TODO
// Notes: Debug-only widget.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_drug_use_app/common/layout/common_spacer.dart';
import 'package:mobile_drug_use_app/constants/layout/app_layout.dart';
import 'package:mobile_drug_use_app/constants/theme/app_theme_extension.dart';
import 'package:mobile_drug_use_app/core/providers/navigation_provider.dart';
import 'package:mobile_drug_use_app/core/routes/app_router.dart';
import 'package:mobile_drug_use_app/core/services/navigation_service.dart';

/// Debug utility widget for simulating auth deep-link flows.
///
/// Only visible in debug mode.
class DeepLinkDebugWidget extends ConsumerWidget {
  const DeepLinkDebugWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final nav = ref.read(navigationProvider);
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    final tx = context.text;
    final ac = context.accent;

    return Container(
      margin: EdgeInsets.all(sp.md),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(
          color: c.warning.withValues(alpha: 0.5),
          width: context.sizes.borderRegular,
        ),
      ),
      child: Column(
        crossAxisAlignment: AppLayout.crossAxisAlignmentStart,
        mainAxisSize: AppLayout.mainAxisSizeMin,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: c.warning,
                size: context.sizes.iconMd,
              ),
              CommonSpacer.horizontal(sp.sm),
              Text(
                'Deep Link Debug Tools',
                style: tx.heading3.copyWith(color: c.textPrimary),
              ),
            ],
          ),
          CommonSpacer.vertical(sp.sm),
          Text(
            'Simulate auth deep links',
            style: tx.bodySmall.copyWith(color: c.textSecondary),
          ),
          CommonSpacer.vertical(sp.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => nav.replace(AppRoutePaths.emailConfirmed),
              icon: const Icon(Icons.email_outlined),
              label: const Text('Simulate Email Confirmation'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ac.primary,
                side: BorderSide(color: ac.primary),
                padding: EdgeInsets.symmetric(vertical: sp.md),
              ),
            ),
          ),
          CommonSpacer.vertical(sp.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => nav.replace(AppRoutePaths.setNewPassword),
              icon: const Icon(Icons.lock_reset),
              label: const Text('Simulate Password Reset'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ac.primary,
                side: BorderSide(color: ac.primary),
                padding: EdgeInsets.symmetric(vertical: sp.md),
              ),
            ),
          ),
          CommonSpacer.vertical(sp.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSupabaseVerifyChooser(context, nav),
              icon: const Icon(Icons.link),
              label: const Text('Simulate Supabase Verify URL'),
              style: OutlinedButton.styleFrom(
                foregroundColor: ac.primary,
                side: BorderSide(color: ac.primary),
                padding: EdgeInsets.symmetric(vertical: sp.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSupabaseVerifyChooser(BuildContext context, NavigationService nav) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Choose Verification Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Signup / Email verification'),
                onTap: () {
                  nav.pop();
                  nav.replace(AppRoutePaths.emailConfirmed);
                },
              ),
              ListTile(
                title: const Text('Recovery / Password reset'),
                onTap: () {
                  nav.pop();
                  nav.replace(AppRoutePaths.setNewPassword);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => nav.pop(), child: const Text('Cancel')),
          ],
        );
      },
    );
  }
}
