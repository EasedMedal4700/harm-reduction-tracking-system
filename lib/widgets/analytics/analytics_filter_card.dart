import 'package:flutter/material.dart';
import '../../constants/ui_colors.dart';
import '../../constants/theme_constants.dart';

class AnalyticsFilterCard extends StatefulWidget {
  final Widget filterContent;

  const AnalyticsFilterCard({
    super.key,
    required this.filterContent,
  });

  @override
  State<AnalyticsFilterCard> createState() => _AnalyticsFilterCardState();
}

class _AnalyticsFilterCardState extends State<AnalyticsFilterCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: ThemeConstants.animationNormal,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? UIColors.darkNeonBlue : UIColors.lightAccentBlue;

    return Container(
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: UIColors.lightBorder,
                width: ThemeConstants.borderThin,
              ),
              boxShadow: UIColors.createSoftShadow(),
            ),
      child: Column(
        children: [
          // Filter header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              child: Padding(
                padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
                child: Row(
                  children: [
                    // Filter icon
                    Container(
                      padding: EdgeInsets.all(ThemeConstants.space8),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                      ),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: accentColor,
                        size: ThemeConstants.iconMedium,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space12),
                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontMedium,
                              fontWeight: ThemeConstants.fontSemiBold,
                              color: isDark ? UIColors.darkText : UIColors.lightText,
                            ),
                          ),
                          SizedBox(height: ThemeConstants.space4),
                          Text(
                            'Customize data visibility',
                            style: TextStyle(
                              fontSize: ThemeConstants.fontXSmall,
                              fontWeight: ThemeConstants.fontRegular,
                              color: isDark
                                  ? UIColors.darkTextSecondary
                                  : UIColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Chevron icon
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark
                            ? UIColors.darkTextSecondary
                            : UIColors.lightTextSecondary,
                        size: ThemeConstants.iconMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(
                left: ThemeConstants.cardPaddingMedium,
                right: ThemeConstants.cardPaddingMedium,
                bottom: ThemeConstants.cardPaddingMedium,
              ),
              child: widget.filterContent,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: ThemeConstants.animationNormal,
          ),
        ],
      ),
    );
  }
}
