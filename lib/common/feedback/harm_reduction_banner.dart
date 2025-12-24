import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';
import '../../constants/theme/app_theme_extension.dart';

// MIGRATION
// Theme: COMPLETE
// Common: COMPLETE
// Riverpod: TODO
// Notes: Moved from old_common. Uses AppThemeExtension.
/// A banner that displays a harm reduction warning to users
/// Emphasizes that calculated values are estimates, not medical advice
/// Can be dismissed and state persists across app restarts
class HarmReductionBanner extends StatefulWidget {
  final String message;
  final String? dismissKey; // SharedPreferences key for persistence
  final VoidCallback? onDismiss;
  const HarmReductionBanner({
    super.key,
    this.message =
        'These calculations are estimates only and should not be taken as medical advice. '
        'Individual responses vary significantly based on factors like metabolism, tolerance, '
        'and substance purity. Always prioritize safety and consult healthcare professionals.',
    this.dismissKey,
    this.onDismiss,
  });
  @override
  State<HarmReductionBanner> createState() => _HarmReductionBannerState();
}

class _HarmReductionBannerState extends State<HarmReductionBanner> {
  bool _isDismissed = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkDismissedState();
  }

  Future<void> _checkDismissedState() async {
    if (widget.dismissKey != null) {
      final isDismissed = await onboardingService.isHarmNoticeDismissed(
        widget.dismissKey!,
      );
      if (mounted) {
        setState(() {
          _isDismissed = isDismissed;
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDismiss() async {
    if (widget.dismissKey != null) {
      await onboardingService.dismissHarmNotice(widget.dismissKey!);
    }
    if (mounted) {
      setState(() => _isDismissed = true);
      widget.onDismiss?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isDismissed) return const SizedBox.shrink();
    final th = context.theme;
    final c = context.colors;
    final sp = context.spacing;
    final sh = context.shapes;
    return Container(
      margin: EdgeInsets.only(bottom: sp.md),
      padding: EdgeInsets.all(sp.md),
      decoration: BoxDecoration(
        color: c.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(sh.radiusMd),
        border: Border.all(color: c.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: c.warning),
              SizedBox(width: sp.sm),
              Expanded(
                child: Text(
                  'Harm Reduction Notice',
                  style: th.text.heading4.copyWith(
                    color: c.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.dismissKey != null)
                IconButton(
                  icon: Icon(Icons.close, size: 20, color: c.textSecondary),
                  onPressed: _handleDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Dismiss',
                ),
            ],
          ),
          SizedBox(height: sp.sm),
          Text(
            widget.message,
            style: th.text.bodyMedium.copyWith(color: c.textPrimary),
          ),
        ],
      ),
    );
  }
}
