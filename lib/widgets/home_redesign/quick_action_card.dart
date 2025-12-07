import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

/// Modular Quick Action Card component
/// Professional medical dashboard style with perfect centering
class QuickActionCard extends StatefulWidget {
  final String actionKey;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int? badgeCount;

  const QuickActionCard({
    required this.actionKey,
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount,
    super.key,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark
        ? UIColors.getDarkAccent(widget.actionKey)
        : UIColors.getLightAccent(widget.actionKey);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: ThemeConstants.animationFast,
        curve: Curves.easeOut,
        decoration: _buildDecoration(isDark, accentColor),
        child: Stack(
          children: [
            // Main content - perfectly centered
            Center(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.cardPaddingSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon - centered
                    Icon(widget.icon, size: 32, color: accentColor),
                    const SizedBox(height: ThemeConstants.space12),
                    // Label - centered
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ThemeConstants.fontSmall,
                        fontWeight: ThemeConstants.fontSemiBold,
                        color: isDark ? UIColors.darkText : UIColors.lightText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Badge
            if (widget.badgeCount != null && widget.badgeCount! > 0)
              Positioned(
                top: ThemeConstants.space8,
                right: ThemeConstants.space8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space8,
                    vertical: ThemeConstants.space4,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.radiusSmall,
                    ),
                  ),
                  child: Text(
                    widget.badgeCount! > 99 ? '99+' : '${widget.badgeCount}',
                    style: TextStyle(
                      color: isDark ? UIColors.darkBackground : Colors.white,
                      fontSize: ThemeConstants.fontXSmall,
                      fontWeight: ThemeConstants.fontBold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark, Color accentColor) {
    if (isDark) {
      // Dark theme: glassmorphism with subtle accent glow and gradient
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UIColors.darkSurface.withValues(alpha: 0.8),
            UIColors.darkSurface.withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.quickActionRadius),
        border: Border.all(
          color: _isPressed
              ? accentColor.withValues(alpha: 0.5)
              : UIColors.darkBorder,
          width: 1,
        ),
        boxShadow: _isPressed
            ? UIColors.createNeonGlow(accentColor, intensity: 0.4)
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                ...UIColors.createNeonGlow(accentColor, intensity: 0.1),
              ],
      );
    } else {
      // Light theme: white card + soft shadow
      return BoxDecoration(
        color: UIColors.lightSurface,
        borderRadius: BorderRadius.circular(ThemeConstants.quickActionRadius),
        boxShadow: _isPressed
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : UIColors.createSoftShadow(),
      );
    }
  }
}
