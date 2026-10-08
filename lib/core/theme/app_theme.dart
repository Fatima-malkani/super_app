import 'package:flutter/material.dart';

class AppTheme {


  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color secondaryColor = Color(0xFF14B8A6);

  // Light Theme Colors
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textColor = Color(0xFF0F172A);
  static const Color secondaryTextColor = Color(0xFF64748B);

  // Dark Theme Colors
  static const Color darkBackgroundColor = Color(0xFF0F172A);
  static const Color darkCardColor = Color(0xFF1E293B);
  static const Color darkTextColor = Color(0xFFF8FAFC);
  static const Color darkSecondaryTextColor = Color(0xFF94A3B8);

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: backgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: secondaryColor,
    ),

    // -------------------------------------------------------
    // APP BAR
    // -------------------------------------------------------

    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: false,
    ),

    // -------------------------------------------------------
    // TEXT FIELD
    // -------------------------------------------------------

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    ),

    // -------------------------------------------------------
    // ELEVATED BUTTON
    // -------------------------------------------------------

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          55,
        ),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // -------------------------------------------------------
    // CARD
    // -------------------------------------------------------

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

  

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),

      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),

      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),

      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: secondaryTextColor,
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        color: secondaryTextColor,
      ),
    ),
  );

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: darkBackgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: secondaryColor,
    ),

    // -------------------------------------------------------
    // APP BAR
    // -------------------------------------------------------

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      foregroundColor: darkTextColor,
      elevation: 0,
      centerTitle: false,
    ),

    // -------------------------------------------------------
    // TEXT FIELD
    // -------------------------------------------------------

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardColor,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),

      hintStyle: const TextStyle(
        color: darkSecondaryTextColor,
      ),
    ),

    // -------------------------------------------------------
    // ELEVATED BUTTON
    // -------------------------------------------------------

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          55,
        ),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    // -------------------------------------------------------
    // CARD
    // -------------------------------------------------------

    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

  

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkTextColor,
      ),

      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: darkTextColor,
      ),

      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: darkTextColor,
      ),

      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkTextColor,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkTextColor,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkSecondaryTextColor,
      ),

      bodySmall: TextStyle(
        fontSize: 12,
        color: darkSecondaryTextColor,
      ),
    ),
  );
}