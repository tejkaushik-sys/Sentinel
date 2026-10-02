import 'package:flutter/material.dart';

class AppColors {
  // Deep Backgrounds
  static const Color background = Color(0xFF07141C);
  static const Color surface = Color(0xFF0C2730);
  static const Color surfaceElevated = Color(0xFF102D36);
  static const Color surfaceHighlight = Color(0xFF153944);
  static const Color surfaceCard = Color(0xFF0B2129);

  // Borders and Dividers
  static const Color border = Color(0xFF1A404D);
  static const Color borderLight = Color(0x335DE1E6);
  static const Color borderGlow = Color(0x665DE1E6);

  // Brand Accents
  static const Color cyan = Color(0xFF5DE1E6);
  static const Color cyanDark = Color(0xFF197D87);
  static const Color gold = Color(0xFFF4C96B);
  static const Color emerald = Color(0xFF62D6A7);
  static const Color warningOrange = Color(0xFFFFB84D);
  static const Color criticalRed = Color(0xFFFF6262);
  static const Color purple = Color(0xFFA88BFF);

  // Category Palette
  static const Color catRoad = Color(0xFF5DE1E6);
  static const Color catAccident = Color(0xFFFF6275);
  static const Color catFire = Color(0xFFFF8B4D);
  static const Color catLighting = Color(0xFFF4C96B);
  static const Color catFlood = Color(0xFF38B2AC);
  static const Color catHazard = Color(0xFFE53E3E);
  static const Color catNews = Color(0xFF48BB78);
  static const Color catOther = Color(0xFFA88BFF);

  // Typography
  static const Color textPrimary = Color(0xFFF4F1E8);
  static const Color textSecondary = Color(0xFFA8B8BD);
  static const Color textMuted = Color(0xFF6B7E84);
  static const Color textDisabled = Color(0xFF45555C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5DE1E6), Color(0xFF3AA8B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0F2C35), Color(0xFF0A1F26)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient redAlertGradient = LinearGradient(
    colors: [Color(0xCC741B1B), Color(0xDD3A0A0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient proGradient = LinearGradient(
    colors: [Color(0xFF3B1E63), Color(0xFF1A2744)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
