import 'package:flutter/material.dart';

/// Centralized color system for DataVault.
/// Modern fintech palette: deep indigo, vibrant violet, teal, coral, amber.
class AppColors {
  AppColors._();

  // Brand — modern indigo/violet
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5A4BD1);
  static const Color primaryLight = Color(0xFFE8E6FC);
  static const Color navy = Color(0xFF1A1B3D);
  static const Color navyLight = Color(0xFF2D2E5E);
  static const Color gold = Color(0xFFFFB800);
  static const Color goldLight = Color(0xFFFFF4D6);

  // Neutrals — cooler, more modern
  static const Color background = Color(0xFFF4F5FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E6F0);
  static const Color textPrimary = Color(0xFF1A1B3D);
  static const Color textSecondary = Color(0xFF6B6E8C);
  static const Color textMuted = Color(0xFFA0A3BD);
  static const Color disabled = Color(0xFFD0D2E8);

  // Semantic
  static const Color success = Color(0xFF00C853);
  static const Color successLight = Color(0xFFE0F7EA);
  static const Color error = Color(0xFFFF4757);
  static const Color errorLight = Color(0xFFFFE9EB);
  static const Color warning = Color(0xFFFFB800);
  static const Color warningLight = Color(0xFFFFF4D6);
  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Stat card gradients — vibrant, modern combos
  static const List<Gradient> statGradients = [
    LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF7675), Color(0xFFFFA07A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFE17055), Color(0xFFFFB800)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFFFD79A8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  // Service accent colors — fresh, distinct, modern
  static const Color airtime = Color(0xFF6C5CE7);
  static const Color data = Color(0xFF00B894);
  static const Color electricity = Color(0xFFFFB800);
  static const Color cable = Color(0xFF0984E3);
  static const Color education = Color(0xFFE17055);
  static const Color wallet = Color(0xFFFD79A8);
}
