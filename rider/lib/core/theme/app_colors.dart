import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - same as customer/vendor for brand consistency
  static const Color primary = Color(0xFF0068FF);
  static const Color primaryLight = Color(0xFFEFF5FF);
  static const Color primaryDark = Color(0xFF0052CC);

  static const Color secondary = Color(0xFFFACC15);
  static const Color secondaryLight = Color(0xFFFEF9C3);

  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0068FF);

  // Rider specific
  static const Color online = Color(0xFF16A34A);
  static const Color offline = Color(0xFF64748B);
  static const Color busy = Color(0xFFFACC15);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusFull = 999.0;
}
