import 'package:flutter/material.dart';
import '../../constants/theme/app_theme_extension.dart';

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
      duration: const Duration(milliseconds: 220),
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
      _isExpanded ? _animationController.forward() : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final accent = t.accent.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: t.colors.surface,
        borderRadius: BorderRadius.circular(t.spacing.md),
        border: Border.all(
          color: _isExpanded ? accent.withOpacity(0.4) : t.colors.border,
          width: _isExpanded ? 1.4 : 1,
        ),
        boxShadow: _isExpanded ? t.cardShadow : [],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(t.spacing.md),
              bottom: Radius.circular(_isExpanded ? 0 : t.spacing.md),
            ),
            child: Container(
              padding: EdgeInsets.all(t.spacing.lg),
              decoration: _isExpanded
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: t.colors.border,
                          width: 1,
                        ),
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  // Icon container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: EdgeInsets.all(t.spacing.md),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(_isExpanded ? 0.18 : 0.1),
                      borderRadius: BorderRadius.circular(t.spacing.sm),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: accent,
                      size: 22,
                    ),
                  ),

                  SizedBox(width: t.spacing.lg),

                  // Titles
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Advanced Filters',
                              style: t.typography.bodyBold.copyWith(
                                color: t.colors.textPrimary,
                              ),
                            ),
                            if (_isExpanded) ...[
                              SizedBox(width: t.spacing.sm),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: t.spacing.sm,
                                  vertical: t.spacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(t.spacing.sm),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: t.typography.overline.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),

                        SizedBox(height: t.spacing.xs),

                        Text(
                          _isExpanded
                              ? 'Refine your analytics data'
                              : 'Tap to customize data visibility',
                          style: t.typography.caption.copyWith(
                            color: t.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: t.spacing.md),

                  // Chevron
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Container(
                      padding: EdgeInsets.all(t.spacing.xs),
                      decoration: BoxDecoration(
                        color: t.colors.border.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: t.colors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Container(
                    padding: EdgeInsets.all(t.spacing.lg),
                    child: widget.filterContent,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
