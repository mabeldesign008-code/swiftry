import 'package:flutter/material.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Primary ───────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0068FF);
  static const Color primaryLight = Color(0xFFEFF5FF);
  static const Color primaryDark = Color(0xFF0052CC);
  static const Color primaryShadow = Color(0x330068FF);

  // ─── Secondary (Yellow Brand Color) ────────────────────────────────────────
  static const Color secondary = Color(0xFFFACC15);
  static const Color secondaryLight = Color(0xFFFEF9C3);
  static const Color secondaryDark = Color(0xFFEAB308);
  static const Color secondaryShadow = Color(0x33FACC15);

  // ─── Backgrounds ───────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceCard = Color(0xFFFFFFFF);

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF334155);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Border ────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // ─── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color successText = Color(0xFF15803D);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color errorText = Color(0xFFB91C1C);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningText = Color(0xFF92400E);

  static const Color info = Color(0xFF0068FF);
  static const Color infoLight = Color(0xFFEFF5FF);

  // ─── Misc ──────────────────────────────────────────────────────────────────
  static const Color star = secondary; // Use brand yellow for ratings
  static const Color accent = secondary; // Use brand yellow for accents
  static const Color divider = Color(0xFFF1F5F9);
  static const Color shimmerBase = Color(0xFFE2E8F0);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // ─── Border Radius ─────────────────────────────────────────────────────────
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 999.0;

  // ─── Spacing ───────────────────────────────────────────────────────────────
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;

  // ─── Shadows ───────────────────────────────────────────────────────────────
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> bottomNavShadow = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, -4)),
  ];

  static List<BoxShadow> primaryButtonShadow = [
    BoxShadow(
      color: Color(0x4D0068FF),
      blurRadius: 15,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> secondaryButtonShadow = [
    BoxShadow(
      color: secondaryShadow,
      blurRadius: 15,
      offset: Offset(0, 8),
    ),
  ];

  // ─── Text Styles ───────────────────────────────────────────────────────────
  static TextStyle heading1 = AppFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -1,
  );

  static TextStyle heading2 = AppFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle heading3 = AppFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle heading4 = AppFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle bodyLarge = AppFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = AppFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = AppFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiary,
  );

  static TextStyle labelLarge = AppFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle labelMedium = AppFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle labelSmall = AppFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textTertiary,
  );

  static TextStyle caption = AppFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: textDisabled,
  );

  static TextStyle buttonText = AppFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle linkText = AppFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primary,
  );

  // ─── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      fontFamily: AppFonts.family,
      textTheme: AppFonts.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary, size: 24),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
        ),
        shadowColor: const Color(0x0A000000),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: AppFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: AppFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: AppFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: Color(0xFFE9EAEB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        hintStyle: AppFonts.inter(
          fontSize: 14,
          color: textDisabled,
        ),
        labelStyle: AppFonts.inter(
          fontSize: 14,
          color: textTertiary,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: primary,
        unselectedLabelColor: textTertiary,
        labelStyle: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        dividerColor: border,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXXL),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryLight,
        labelStyle: AppFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        side: BorderSide.none,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: AppFonts.inter(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Button Helpers ────────────────────────────────────────────────────────
  
  /// Creates a secondary (yellow) ElevatedButton style
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: secondary,
    foregroundColor: Colors.black,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMD),
    ),
    textStyle: AppFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    minimumSize: const Size(double.infinity, 56),
  );

  /// Creates a secondary (yellow) OutlinedButton style  
  static ButtonStyle get secondaryOutlinedButtonStyle => OutlinedButton.styleFrom(
    foregroundColor: secondaryDark,
    side: BorderSide(color: secondary, width: 1.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMD),
    ),
    textStyle: AppFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    minimumSize: const Size(double.infinity, 56),
  );

  // ─── Status Helpers ─────────────────────────────────────────────────────────
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return successLight;
      case 'in transit':
      case 'on the way':
      case 'processing':
      case 'confirmed':
        return primaryLight;
      case 'cancelled':
      case 'rejected':
        return errorLight;
      case 'pending':
        return warningLight;
      default:
        return surfaceVariant;
    }
  }

  static Color statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return successText;
      case 'in transit':
      case 'on the way':
      case 'processing':
      case 'confirmed':
        return primaryDark;
      case 'cancelled':
      case 'rejected':
        return errorText;
      case 'pending':
        return warningText;
      default:
        return textTertiary;
    }
  }
}
