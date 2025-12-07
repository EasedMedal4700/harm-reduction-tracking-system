import 'package:flutter/material.dart';
import '../../constants/deprecated/ui_colors.dart';
import '../../constants/deprecated/theme_constants.dart';

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

    return AnimatedContainer(
      duration: ThemeConstants.animationNormal,
      decoration: isDark
          ? UIColors.createGlassmorphism(
              accentColor: accentColor,
              radius: ThemeConstants.cardRadius,
            )
          : BoxDecoration(
              color: UIColors.lightSurface,
              borderRadius: BorderRadius.circular(ThemeConstants.cardRadius),
              border: Border.all(
                color: _isExpanded ? accentColor.withValues(alpha: 0.3) : UIColors.lightBorder,
                width: _isExpanded ? ThemeConstants.borderMedium : ThemeConstants.borderThin,
              ),
              boxShadow: _isExpanded 
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : UIColors.createSoftShadow(),
            ),
      child: Column(
        children: [
          // Filter header
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpanded,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(ThemeConstants.cardRadius),
                bottom: _isExpanded ? Radius.zero : Radius.circular(ThemeConstants.cardRadius),
              ),
              child: Container(
                padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
                decoration: _isExpanded
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark ? UIColors.darkBorder : UIColors.lightBorder,
                            width: ThemeConstants.borderThin,
                          ),
                        ),
                      )
                    : null,
                child: Row(
                  children: [
                    // Filter icon with animation
                    AnimatedContainer(
                      duration: ThemeConstants.animationNormal,
                      padding: EdgeInsets.all(ThemeConstants.space12),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: _isExpanded ? (isDark ? 0.25 : 0.15) : (isDark ? 0.15 : 0.08)),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                        boxShadow: _isExpanded && isDark
                            ? UIColors.createNeonGlow(accentColor, intensity: 0.2)
                            : null,
                      ),
                      child: Icon(
                        Icons.tune_rounded,
                        color: accentColor,
                        size: ThemeConstants.iconMedium,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.space16),
                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Advanced Filters',
                                style: TextStyle(
                                  fontSize: ThemeConstants.fontMedium,
                                  fontWeight: ThemeConstants.fontSemiBold,
                                  color: isDark ? UIColors.darkText : UIColors.lightText,
                                ),
                              ),
                              if (_isExpanded) ...[
                                SizedBox(width: ThemeConstants.space8),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ThemeConstants.space8,
                                    vertical: ThemeConstants.space4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: UIColors.darkNeonEmerald.withValues(alpha: isDark ? 0.2 : 0.1),
                                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSmall),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: TextStyle(
                                      fontSize: ThemeConstants.fontXSmall,
                                      fontWeight: ThemeConstants.fontBold,
                                      color: UIColors.darkNeonEmerald,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: ThemeConstants.space4),
                          Text(
                            _isExpanded 
                                ? 'Refine your analytics data'
                                : 'Tap to customize data visibility',
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
                    SizedBox(width: ThemeConstants.space8),
                    // Chevron icon with rotation animation
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        padding: EdgeInsets.all(ThemeConstants.space4),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? UIColors.darkBorder.withValues(alpha: 0.5)
                              : UIColors.lightBorder,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.expand_more_rounded,
                          color: isDark
                              ? UIColors.darkTextSecondary
                              : UIColors.lightTextSecondary,
                          size: ThemeConstants.iconMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expandable content
          AnimatedSize(
            duration: ThemeConstants.animationNormal,
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Container(
                    padding: EdgeInsets.all(ThemeConstants.cardPaddingMedium),
                    child: widget.filterContent,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
