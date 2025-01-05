import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF177EC6),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Color(0xFFE5E5E5),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF177EC6)),
      titleTextStyle: TextStyle(
        color: Color(0xFF2D2D2D),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      titleLarge: TextStyle(
          color: Color(0xFF2D2D2D), fontSize: 24, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: Color(0xFF2D2D2D), fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Color(0xFF2D2D2D), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFF64748B), fontSize: 14),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFEFF8FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFD9D9D9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF177EC6)),
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF177EC6),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF177EC6),
    scaffoldBackgroundColor: Color(0xFF1A1A1A),
    cardColor: Color(0xFF2D2D2D),
    dividerColor: Color(0xFF404040),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: Colors.white,
    ),

    // Text Theme
    textTheme: TextTheme(
      titleLarge: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF404040)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF404040)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF177EC6)),
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF177EC6),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    // Color Scheme
    colorScheme: ColorScheme.dark(
      background: Color(0xFF1A1A1A),
      surface: Color(0xFF2D2D2D),
      primary: Color(0xFF177EC6),
      secondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
  );
}
