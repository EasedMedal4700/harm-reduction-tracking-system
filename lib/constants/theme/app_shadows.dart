import 'package:flutter/material.dart';

class LightShadows {
  List<BoxShadow> get card => const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  List<BoxShadow> get cardHovered => const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  List<BoxShadow> get button => const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];
}

class DarkShadows {
  List<BoxShadow> get card => const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ];

  List<BoxShadow> get cardHovered => const [
        BoxShadow(
          color: Color(0x60000000),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
      ];

  List<BoxShadow> get button => const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ];
}
