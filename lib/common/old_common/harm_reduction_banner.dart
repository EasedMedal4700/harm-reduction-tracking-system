import 'package:flutter/material.dart';
import '../../services/onboarding_service.dart';

/// A banner that displays a harm reduction warning to users
/// Emphasizes that calculated values are estimates, not medical advice
/// Can be dismissed and state persists across app restarts
class HarmReductionBanner extends StatefulWidget {
  final String message;
  final String? dismissKey; // SharedPreferences key for persistence
  final VoidCallback? onDismiss;

  const HarmReductionBanner({
    super.key,
    this.message = 'These calculations are estimates only and should not be taken as medical advice. '
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
      final isDismissed = await onboardingService.isHarmNoticeDismissed(widget.dismissKey!);
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
    
    setState(() => _isDismissed = true);
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show if loading or dismissed
    if (_isLoading || _isDismissed) {
      return const SizedBox.shrink();
    }
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.amber.withOpacity(0.15) 
            : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark 
              ? Colors.amber.shade700 
              : Colors.amber.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: isDark ? Colors.amber.shade400 : Colors.amber.shade800,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Harm Reduction Notice',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.amber.shade300 : Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          // Always show dismiss button when dismissKey is provided
          if (widget.dismissKey != null)
            GestureDetector(
              onTap: _handleDismiss,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
