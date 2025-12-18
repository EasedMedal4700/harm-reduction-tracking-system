// MIGRATION
// Theme: PARTIAL
// Common: PARTIAL
// Riverpod: TODO
// Notes: Initial migration header added. Some theme extension usage, but not fully migrated or Riverpod integrated.
import 'package:flutter/material.dart';
import '../../../../constants/theme/app_theme_extension.dart';

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
      _isExpanded
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.theme;
    final text = context.text;
    final sp = context.spacing;
    final c = context.colors;
    final acc = context.accent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(sp.md),
        border: Border.all(
          color: _isExpanded ? acc.primary.withValues(alpha: 0.4) : c.border,
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
              top: Radius.circular(sp.md),
              bottom: Radius.circular(_isExpanded ? 0 : sp.md),
            ),
            child: Container(
              padding: EdgeInsets.all(sp.lg),
              decoration: _isExpanded
                  ? BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: c.border,
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
                    padding: EdgeInsets.all(sp.md),
                    decoration: BoxDecoration(
                      color: acc.primary.withValues(
                          alpha: _isExpanded ? 0.18 : 0.1),
                      borderRadius: BorderRadius.circular(sp.sm),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: acc.primary,
                      size: 22,
                    ),
                  ),

                  SizedBox(width: sp.lg),

                  // Titles
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Advanced Filters',
                              style: text.bodyBold.copyWith(
                                color: c.textPrimary,
                              ),
                            ),
                            if (_isExpanded) ...[
                              SizedBox(width: sp.sm),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: sp.sm,
                                  vertical: sp.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: acc.primary.withValues(alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(sp.sm),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: text.overline.copyWith(
                                    color: acc.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),

                        SizedBox(height: sp.xs),

                        Text(
                          _isExpanded
                              ? 'Refine your analytics data'
                              : 'Tap to customize data visibility',
                          style: text.caption.copyWith(
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: sp.md),

                  // Chevron
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Container(
                      padding: EdgeInsets.all(sp.xs),
                      decoration: BoxDecoration(
                        color: c.border.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.expand_more_rounded,
                        color: c.textSecondary,
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
                    padding: EdgeInsets.all(sp.lg),
                    child: widget.filterContent,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
