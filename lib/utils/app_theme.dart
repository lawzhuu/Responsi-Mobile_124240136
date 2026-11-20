import 'package:flutter/material.dart';

class AppTheme {
  // Palet Warna Utama
  static const Color darkBackground = Color(0xFF0C1017);
  static const Color darkSurface = Color(0xFF161F2E);
  static const Color darkSurfaceCard = Color(0xFF1C273A);
  static const Color antiqueGold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF5DE88);
  static const Color goldDark = Color(0xFF997A15);
  static const Color burgundy = Color(0xFF7F1D1D);
  static const Color burgundyDark = Color(0xFF4C0E0E);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color textMuted = Color(0xFF94A3B8);

  // Palet Warna House Hogwarts
  static const Color gryffindor = Color(0xFF8D1B1B);
  static const Color slytherin = Color(0xFF1E5B3A);
  static const Color ravenclaw = Color(0xFF1A3B6B);
  static const Color hufflepuff = Color(0xFFC69214);

  // Menentukan warna aksen berdasarkan nama house
  static Color getHouseColor(String house) {
    final lower = house.toLowerCase().trim();
    if (lower.contains('gryffindor')) return gryffindor;
    if (lower.contains('slytherin')) return slytherin;
    if (lower.contains('ravenclaw')) return ravenclaw;
    if (lower.contains('hufflepuff')) return hufflepuff;
    return antiqueGold;
  }

  // Konfigurasi tema global Material 3
  static ThemeData get magicalTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: antiqueGold,
        onPrimary: Color(0xFF1A1400),
        secondary: burgundy,
        onSecondary: Colors.white,
        surface: darkSurface,
        onSurface: textLight,
        error: Color(0xFFEF4444),
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: antiqueGold,
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
        titleTextStyle: TextStyle(
          color: antiqueGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
        iconTheme: IconThemeData(color: antiqueGold),
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceCard,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: antiqueGold.withValues(alpha: 0.2), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceCard,
        labelStyle: const TextStyle(color: antiqueGold),
        hintStyle: const TextStyle(color: textMuted),
        prefixIconColor: antiqueGold,
        suffixIconColor: antiqueGold,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: antiqueGold.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: antiqueGold.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: antiqueGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: antiqueGold,
          foregroundColor: const Color(0xFF161F2E),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkSurfaceCard,
        contentTextStyle: const TextStyle(color: textLight, fontSize: 14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: antiqueGold, width: 1),
        ),
      ),
    );
  }
}
