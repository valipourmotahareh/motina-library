import 'package:flutter/material.dart';

abstract final class DesignTokens {
  static const paper = Color(0xFFFAF8F4);
  static const ink = Color(0xFF242824);
  static const muted = Color(0xFF535B55);
  static const green = Color(0xFF285943);
  static const paleGreen = Color(0xFFEAF1EC);
  static const line = Color(0xFFD9DDD7);
  static const control = Color(0xFF707970);
  static const space = 8.0;
  static const gap = 16.0;
  static const section = 32.0;
  static const maxWidth = 1200.0;
  static const searchWidth = 560.0;
  static const cardMin = 160.0;
  static const radius = 8.0;
  // Minimum internal canvas for decorative cover artwork, fitted at small sizes.
  static const coverCanvasMinWidth = 160.0;
  static const coverRadius = 4.0;
  static const coverLabelSize = 10.0;
  static const coverTitleSize = 24.0;
  static const coverTracking = 1.5;
  static const emptyIconSize = 40.0;
  static const coverRatio = 2 / 3;
  static const coverColors = [
    Color(0xFF294F46),
    Color(0xFF834E3D),
    Color(0xFFDECA9F),
    Color(0xFF4E5B70),
    Color(0xFF643F49),
    Color(0xFF6C7454),
  ];

  // Bundled Persian/Arabic and Latin family; no runtime font package.
  static const fontFamily = 'Vazirmatn';

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: paper,
    colorScheme: ColorScheme.fromSeed(seedColor: green, surface: paper),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      titleLarge: TextStyle(fontSize: 24, height: 1.5, color: ink),
      titleMedium: TextStyle(
        fontSize: 18,
        height: 1.55,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.65, color: ink),
      bodyMedium: TextStyle(fontSize: 14, height: 1.6, color: muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.all(gap),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: green,
        minimumSize: const Size(48, 48),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: control),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: control),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: green, width: 2),
      ),
    ),
  );
}
