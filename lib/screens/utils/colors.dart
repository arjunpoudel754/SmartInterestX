import 'package:flutter/material.dart';

/// Colors pulled from the SmartInterestX Figma file.
class DashColors {
  static const background = Color(0xFFF8FAFC);
  static const border = Color(0xFFE2E8F0);
  static const mainText = Color(0xFF0F172A);
  static const subText = Color(0xFF64748B);

  static const blue = Color(0xFF2563EB);
  static const blueSoft = Color(0xFFEFF6FF);
  static const blueRowBg = Color(0xFFEBF5FF);
  static const blueRowIcon = Color(0xFFA4D1FF);

  static const success = Color(0xFF0D9467);
  static const successBg = Color(0xFFECFDF5);

  static const danger = Color(0xFFDC2626);
  static const dangerBg = Color(0xFFFEF2F2);

  static const pending = Color(0xFFF97316);
  static const pendingBg = Color(0xFFFFF7ED);
  static const pendingBgHigh = Color(0xFFFFEADB);

  static const orange = Color(0xFFEA580C);
  static const purple = Color(0xFF7C3AED);
  static const purpleBg = Color(0xFFF5F3FF);
}

/// Inter is used everywhere in the design.
/// Either bundle it in assets/fonts (pubspec.yaml) or use the google_fonts package.
TextStyle dashText(double size, FontWeight weight, Color color) => TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: weight,
      color: color,
    );