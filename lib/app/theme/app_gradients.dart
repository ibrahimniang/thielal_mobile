import 'package:flutter/material.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient primaryRed = LinearGradient(
    colors: [Color(0xFFE53946), Color(0xFFC1121F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumDark = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1F2937)],
  );

  static const LinearGradient blueGlow = LinearGradient(
    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
  );
}
