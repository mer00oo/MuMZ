import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors extracted from app screenshot
  static const Color primary = Color(0xFFE8915A);       // Warm orange
  static const Color primaryLight = Color(0xFFF5B98A);  // Light peach/orange
  static const Color primaryDark = Color(0xFFD4743F);   // Deeper orange
  static const Color accent = Color(0xFFFFD4B2);        // Soft peach
  static const Color background = Color(0xFFF8F4F0);    // Warm off-white
  static const Color surface = Color(0xFFFFFFFF);       // White cards
  static const Color textPrimary = Color(0xFF3D2C2C);   // Warm dark brown
  static const Color textSecondary = Color(0xFF8B7676); // Muted warm gray
  static const Color divider = Color(0xFFEDE8E3);       // Soft divider

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Cairo',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: primaryLight,
      surface: surface,
      background: background,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: primary.withOpacity(0.15),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: textSecondary, fontFamily: 'Cairo'),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: accent,
      selectedColor: primary,
      labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
  );
}