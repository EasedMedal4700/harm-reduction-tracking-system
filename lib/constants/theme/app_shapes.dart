import 'package:flutter/painting.dart';

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
  
  // Alignment constants
  static const Alignment alignmentCenter = Alignment.center;
  static const Alignment alignmentTopLeft = Alignment.topLeft;
  static const Alignment alignmentTopCenter = Alignment.topCenter;
  static const Alignment alignmentTopRight = Alignment.topRight;
  static const Alignment alignmentCenterLeft = Alignment.centerLeft;
  static const Alignment alignmentCenterRight = Alignment.centerRight;
  static const Alignment alignmentBottomLeft = Alignment.bottomLeft;
  static const Alignment alignmentBottomCenter = Alignment.bottomCenter;
  static const Alignment alignmentBottomRight = Alignment.bottomRight;
  
  // BoxShape constants
  static const BoxShape boxShapeRectangle = BoxShape.rectangle;
  static const BoxShape boxShapeCircle = BoxShape.circle;
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
  
  // Alignment getters
  Alignment get alignmentCenter => AppShapeConstants.alignmentCenter;
  Alignment get alignmentTopLeft => AppShapeConstants.alignmentTopLeft;
  Alignment get alignmentTopCenter => AppShapeConstants.alignmentTopCenter;
  Alignment get alignmentTopRight => AppShapeConstants.alignmentTopRight;
  Alignment get alignmentCenterLeft => AppShapeConstants.alignmentCenterLeft;
  Alignment get alignmentCenterRight => AppShapeConstants.alignmentCenterRight;
  Alignment get alignmentBottomLeft => AppShapeConstants.alignmentBottomLeft;
  Alignment get alignmentBottomCenter => AppShapeConstants.alignmentBottomCenter;
  Alignment get alignmentBottomRight => AppShapeConstants.alignmentBottomRight;
  
  // BoxShape getters
  BoxShape get boxShapeRectangle => AppShapeConstants.boxShapeRectangle;
  BoxShape get boxShapeCircle => AppShapeConstants.boxShapeCircle;
}


