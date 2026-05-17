import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> redGlow = [
    BoxShadow(
      color: Color(0xFFE53946).withOpacity(0.35),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}
