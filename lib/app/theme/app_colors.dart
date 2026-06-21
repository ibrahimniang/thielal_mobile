import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // =========================
  // 🌞 LIGHT THEME (EXISTANT)
  // =========================
  static const Color primaryRed = Color(0xFFC62828);
  static const Color secondaryBlue = Color(0xFF1565C0);

  static const Color white = Color(0xFFFFFFFF);
  static const Color silverBackground = Color(0xFFF1F3F4);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);

  // =========================
  // 🌙 DARK MODE (PREMIUM DASHBOARD)
  // =========================

  /// Fond principal bleu nuit profond (pas noir)
  static const Color darkBackground = Color(0xFF030B25);

  /// Cartes / panels bleu marine
  static const Color darkSurface = Color(0xFF08132F);

  /// Surface secondaire (hover / sections)
  static const Color darkSurfaceSoft = Color(0xFF0B1A3A);

  /// Bordures discrètes lumineuses
  static const Color darkBorder = Color(0xFF1C2A4A);

  /// Texte principal clair
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  /// Texte secondaire légèrement grisé bleu
  static const Color darkTextSecondary = Color(0xFFB6C2E2);

  // =========================
  // 🎯 THEME COHERENT BRAND (THIELAL)
  // =========================

  /// Rouge principal conservé (identité Thielal)
  static const Color brandRed = primaryRed;

  /// Bleu accent médical UI
  static const Color brandBlue = secondaryBlue;

  /// Glow / accent léger UI dashboard
  static const Color accentGlow = Color(0xFF2D6BFF);

  // =========================
  // 🌈 STATUS (compatible dark + light)
  // =========================

  static const Color successDark = Color(0xFF22C55E);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color errorDark = Color(0xFFEF4444);
}