import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Tokens
  static const Color obsidianBlack = Color(0xFF0A0B0D);
  static const Color darkCharcoal = Color(0xFF14161B);
  static const Color cardBg = Color(0xFF1D2026);
  static const Color cardBorder = Color(0xFF2C3039);
  
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3E5AB);
  static const Color roseGold = Color(0xFFE0A96D);
  
  static const Color textPrimary = Color(0xFFF7F8FA);
  static const Color textSecondary = Color(0xFFA0A7B5);
  static const Color textMuted = Color(0xFF656B77);
  
  static const Color errorRed = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF43A047);
  static const Color infoBlue = Color(0xFF1E88E5);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: obsidianBlack,
      primaryColor: goldAccent,
      colorScheme: const ColorScheme.dark(
        primary: goldAccent,
        secondary: roseGold,
        surface: darkCharcoal,
        error: errorRed,
        onPrimary: obsidianBlack,
        onSecondary: obsidianBlack,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: obsidianBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: goldAccent),
        titleTextStyle: GoogleFonts.cinzel(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.montserrat(color: textMuted, fontSize: 14),
        labelStyle: GoogleFonts.montserrat(color: textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: goldAccent, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: goldAccent,
          foregroundColor: obsidianBlack,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: goldAccent,
          side: const BorderSide(color: goldAccent, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
          letterSpacing: 1.5,
        ),
        displayMedium: GoogleFonts.cinzel(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 1.2,
        ),
        headlineSmall: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 15,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.montserrat(
          fontSize: 13,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: goldAccent,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
