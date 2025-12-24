/// Spacing constants and system
class AppSpacingConstants {
  AppSpacingConstants._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xl2 = 32.0;
  static const double xl3 = 48.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;
  static const double cardSpacing = 16.0;
  static const double homePagePadding = 16.0;
  static const double quickActionSpacing = 16.0;
  static const double cardPaddingSmall = 12.0;
  // Compact mode spacing (reduced by 25%)
  static const double xsCompact = 3.0;
  static const double smCompact = 6.0;
  static const double mdCompact = 9.0;
  static const double lgCompact = 12.0;
  static const double xlCompact = 18.0;
  static const double xl2Compact = 24.0;
  static const double xl3Compact = 36.0;
  static const double cardPadding = 16.0;
  static const double cardPaddingCompact = 12.0;
  static const double cardMargin = 12.0;
  static const double cardMarginCompact = 8.0;
}

class Spacing {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xl2;
  final double xl3;
  final double cardPadding;
  final double cardMargin;
  const Spacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xl2,
    required this.xl3,
    required this.cardPadding,
    required this.cardMargin,
  });
  factory Spacing.normal() => const Spacing(
    xs: AppSpacingConstants.xs,
    sm: AppSpacingConstants.sm,
    md: AppSpacingConstants.md,
    lg: AppSpacingConstants.lg,
    xl: AppSpacingConstants.xl,
    xl2: AppSpacingConstants.xl2,
    xl3: AppSpacingConstants.xl3,
    cardPadding: AppSpacingConstants.cardPadding,
    cardMargin: AppSpacingConstants.cardMargin,
  );
  factory Spacing.compact() => const Spacing(
    xs: AppSpacingConstants.xsCompact,
    sm: AppSpacingConstants.smCompact,
    md: AppSpacingConstants.mdCompact,
    lg: AppSpacingConstants.lgCompact,
    xl: AppSpacingConstants.xlCompact,
    xl2: AppSpacingConstants.xl2Compact,
    xl3: AppSpacingConstants.xl3Compact,
    cardPadding: AppSpacingConstants.cardPaddingCompact,
    cardMargin: AppSpacingConstants.cardMarginCompact,
  );
}
