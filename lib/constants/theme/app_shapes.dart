/// Shape and radius constants
class AppShapeConstants {
  AppShapeConstants._();

  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 999.0;
  
  static const double buttonRadius = 12.0;
  static const double quickActionRadius = 16.0;
}

class AppShapes {
  final double radiusXs;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radiusFull;

  const AppShapes({
    required this.radiusXs,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radiusFull,
  });

  factory AppShapes.defaults() {
    return const AppShapes(
      radiusXs: AppShapeConstants.radiusXs,
      radiusSm: AppShapeConstants.radiusSm,
      radiusMd: AppShapeConstants.radiusMd,
      radiusLg: AppShapeConstants.radiusLg,
      radiusXl: AppShapeConstants.radiusXl,
      radiusFull: AppShapeConstants.radiusFull,
    );
  }

  // Aliases
  double get radiusS => radiusSm;
  double get radiusM => radiusMd;
}


