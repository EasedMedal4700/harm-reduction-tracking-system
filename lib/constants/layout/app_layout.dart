import 'package:flutter/material.dart';

/// Layout constants for consistent widget placement and sizing
/// These are Flutter's enum values, centralized for discoverability
class AppLayout {
  // MainAxisSize
  static const mainAxisSizeMin = MainAxisSize.min;
  static const mainAxisSizeMax = MainAxisSize.max;

  // MainAxisAlignment
  static const mainAxisAlignmentStart = MainAxisAlignment.start;
  static const mainAxisAlignmentEnd = MainAxisAlignment.end;
  static const mainAxisAlignmentCenter = MainAxisAlignment.center;
  static const mainAxisAlignmentSpaceBetween = MainAxisAlignment.spaceBetween;
  static const mainAxisAlignmentSpaceAround = MainAxisAlignment.spaceAround;
  static const mainAxisAlignmentSpaceEvenly = MainAxisAlignment.spaceEvenly;

  // CrossAxisAlignment
  static const crossAxisAlignmentStart = CrossAxisAlignment.start;
  static const crossAxisAlignmentEnd = CrossAxisAlignment.end;
  static const crossAxisAlignmentCenter = CrossAxisAlignment.center;
  static const crossAxisAlignmentStretch = CrossAxisAlignment.stretch;
  static const crossAxisAlignmentBaseline = CrossAxisAlignment.baseline;

  // TextAlign
  static const textAlignLeft = TextAlign.left;
  static const textAlignRight = TextAlign.right;
  static const textAlignCenter = TextAlign.center;
  static const textAlignJustify = TextAlign.justify;
  static const textAlignStart = TextAlign.start;
  static const textAlignEnd = TextAlign.end;

  // TextOverflow
  static const textOverflowClip = TextOverflow.clip;
  static const textOverflowEllipsis = TextOverflow.ellipsis;
  static const textOverflowFade = TextOverflow.fade;
  static const textOverflowVisible = TextOverflow.visible;

  // Flex values
  static const flex1 = 1;
  static const flex2 = 2;
  static const flex3 = 3;
  static const flex4 = 4;

  // Stack fit
  static const stackFitExpand = StackFit.expand;
  static const stackFitLoose = StackFit.loose;
  static const stackFitPassthrough = StackFit.passthrough;

  // Clip behavior
  static const clipNone = Clip.none;
  static const clipHardEdge = Clip.hardEdge;
  static const clipAntiAlias = Clip.antiAlias;
  static const clipAntiAliasWithSaveLayer = Clip.antiAliasWithSaveLayer;

  // BoxFit
  static const boxFitFill = BoxFit.fill;
  static const boxFitContain = BoxFit.contain;
  static const boxFitCover = BoxFit.cover;
  static const boxFitFitWidth = BoxFit.fitWidth;
  static const boxFitFitHeight = BoxFit.fitHeight;
  static const boxFitNone = BoxFit.none;
  static const boxFitScaleDown = BoxFit.scaleDown;

  // Auth & form layout constraints
  static const double authCardMaxWidth = 420;
  static const double authHeaderHeight = 40;

}
